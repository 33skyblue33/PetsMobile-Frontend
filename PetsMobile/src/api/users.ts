import apiClient from './client';
import { User, UserRequest } from '../types';

export const getUserById = async (id: number): Promise<User> => {
  const { data } = await apiClient.get<User>(`/users/${id}`);
  return data;
};

export const registerUser = async (userData: UserRequest): Promise<User> => {
  const { data } = await apiClient.post<User>('/users', userData);
  return data;
};

export const updateUser = async (id: number, userData: UserRequest): Promise<void> => {
  await apiClient.put(`/users/${id}`, userData);
};

export const deleteUser = async (id: number): Promise<void> => {
  await apiClient.delete(`/users/${id}`);
};