import apiClient from '@api/client';
import { Breed, BreedRequest } from '../types';

export const getBreedById = async (id: number): Promise<Breed> => {
  const { data } = await apiClient.get<Breed>(`/breeds/${id}`);
  return data;
};

export const createBreed = async (breedData: BreedRequest): Promise<Breed> => {
  const { data } = await apiClient.post<Breed>('/breeds', breedData);
  return data;
};

export const updateBreed = async (id: number, breedData: BreedRequest): Promise<BreedRequest> => {
  const { data } = await apiClient.put<BreedRequest>(`/breeds/${id}`, breedData);
  return data;
};

export const deleteBreed = async (id: number): Promise<void> => {
  await apiClient.delete(`/breeds/${id}`);
};