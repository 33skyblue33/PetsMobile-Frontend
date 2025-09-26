import apiClient from '..';
import { PetDTO, PetRequest } from '../../models/pet';

export const getPets = async (): Promise<PetDTO[]> => {
  const response = await apiClient.get<PetDTO[]>('/Pets');
  return response.data;
};

export const getPetById = async (id: number): Promise<PetDTO> => {
  const response = await apiClient.get<PetDTO>(`/Pets/${id}`);
  return response.data;
};

export const createPet = async (data: PetRequest): Promise<void> => {
  await apiClient.post('/Pets', data);
};

export const updatePet = async (id: number, data: PetRequest): Promise<void> => {
  await apiClient.put(`/Pets/${id}`, data);
};

export const deletePet = async (id: number): Promise<void> => {
  await apiClient.delete(`/Pets/${id}`);
};