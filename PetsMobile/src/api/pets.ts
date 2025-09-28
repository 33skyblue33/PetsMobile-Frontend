import apiClient from '@api/client';
import { Pet, PetRequest } from '../types';

export const getPetById = async (id: number): Promise<Pet> => {
  const { data } = await apiClient.get<Pet>(`/pets/${id}`);
  return data;
};

export const getAllPets = async (): Promise<Pet[]> => {
  const { data } = await apiClient.get<Pet[]>('/pets');
  return data;
};

export const createPet = async (petData: PetRequest): Promise<Pet> => {
  const { data } = await apiClient.post<Pet>('/pets', petData);
  return data;
};

export const updatePet = async (id: number, petData: PetRequest): Promise<void> => {
  await apiClient.put(`/pets/${id}`, petData);
};

export const deletePet = async (id: number): Promise<void> => {
  await apiClient.delete(`/pets/${id}`);
};