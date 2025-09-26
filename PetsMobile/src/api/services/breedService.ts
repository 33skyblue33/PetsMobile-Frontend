import apiClient from '..';
import { BreedDTO, BreedRequest } from '../../models/breed';

export const getBreedById = async (id: number): Promise<BreedDTO> => {
  const response = await apiClient.get<BreedDTO>(`/Breeds/${id}`);
  return response.data;
};

export const createBreed = async (data: BreedRequest): Promise<BreedDTO> => {
  const response = await apiClient.post<BreedDTO>('/Breeds', data);
  return response.data;
};

export const updateBreed = async (id: number, data: BreedRequest): Promise<BreedDTO> => {
  const response = await apiClient.put<BreedDTO>(`/Breeds/${id}`, data);
  return response.data;
};

export const deleteBreed = async (id: number): Promise<BreedDTO> => {
  const response = await apiClient.delete<BreedDTO>(`/Breeds/${id}`);
  return response.data;
};