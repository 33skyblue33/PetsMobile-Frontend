import apiClient from '..';
import { UserDTO, UserRequest } from '../../models/user';

export const getUserById = async (id: number): Promise<UserDTO> => {
  const response = await apiClient.get<UserDTO>(`/Users/${id}`);
  return response.data;
};

export const createUser = async (data: UserRequest): Promise<void> => {
  await apiClient.post('/Users', data);
};

export const updateUser = async (id: number, data: UserRequest): Promise<void> => {
  await apiClient.put(`/Users/${id}`, data);
};

export const deleteUser = async (id: number): Promise<void> => {
  await apiClient.delete(`/Users/${id}`);
};