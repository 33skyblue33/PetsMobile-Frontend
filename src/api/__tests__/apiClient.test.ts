import apiClient from '..';
import MockAdapter from 'axios-mock-adapter';
import { AuthResult, User } from '../../types';

describe('apiClient interceptors', () => {
  let mock: MockAdapter;

  beforeEach(() => {
    mock = new MockAdapter(apiClient);
  });

  afterEach(() => {
    mock.restore();
  });

  it('should refresh token and retry the original request on 401', async () => {
    const initialAccessToken = 'expired-token';
    apiClient.defaults.headers.common['Authorization'] = `Bearer ${initialAccessToken}`;

    const user: User = { id: 1, name: 'Test', surname: 'User', age: 30, email: 'test@example.com' };
    const newAuthResult: AuthResult = { accessToken: 'new-fresh-token', user };

    // 1. Initial request fails with 401
    mock.onGet('/Pets').replyOnce(401);

    // 2. Refresh token endpoint succeeds
    mock.onPut('/auth/refresh').reply(200, newAuthResult);

    // 3. The original request is retried with the new token and succeeds
    mock.onGet('/Pets').replyOnce(200, [{ id: 1, name: 'Fido' }]);

    const response = await apiClient.get('/Pets');

    // Assertions
    expect(response.status).toBe(200);
    expect(response.data).toEqual([{ id: 1, name: 'Fido' }]);
    expect(apiClient.defaults.headers.common['Authorization']).toBe(`Bearer ${newAuthResult.accessToken}`);
    // Check if the refresh endpoint was called
    expect(mock.history.put.length).toBe(1);
    expect(mock.history.put[0].url).toBe('/auth/refresh');
  });

  it('should fail if token refresh fails', async () => {
    const initialAccessToken = 'expired-token';
    apiClient.defaults.headers.common['Authorization'] = `Bearer ${initialAccessToken}`;

    mock.onGet('/Pets').replyOnce(401);
    mock.onPut('/auth/refresh').reply(401); // Refresh also fails

    await expect(apiClient.get('/Pets')).rejects.toThrow();

    expect(mock.history.put.length).toBe(1);
  });
});