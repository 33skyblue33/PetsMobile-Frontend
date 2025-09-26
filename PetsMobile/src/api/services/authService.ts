import apiClient from '..';
import { AuthResultDTO, LoginRequest } from '../../models/auth';

export const login = async (data: LoginRequest): Promise<AuthResultDTO> => {
  const response = await apiClient.post<AuthResultDTO>('/Auth/login', data);
  return response.data;
};

export const refreshToken = async (): Promise<AuthResultDTO> => {
  const response = await apiClient.put<AuthResultDTO>('/Auth/refresh');
  return response.data;
};

export const logout = async (): Promise<void> => {
  await apiClient.post('/Auth/logout');
};