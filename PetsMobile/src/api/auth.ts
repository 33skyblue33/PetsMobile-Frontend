import apiClient from './client';
import { AuthResult, LoginRequest } from '../types';
import { setAccessToken, clearAccessToken } from './token';

export const login = async (credentials: LoginRequest): Promise<AuthResult> => {
  const { data } = await apiClient.post<AuthResult>('/auth/login', credentials);
  await setAccessToken(data.accessToken);
  return data;
};

export const logout = async (): Promise<void> => {
  await apiClient.post('/auth/logout');
  await clearAccessToken();
};