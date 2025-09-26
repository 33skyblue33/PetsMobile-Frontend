import { create } from "zustand";
import apiClient from "../api";
import { Pet } from "../types";

interface PetState {
  pets: Pet[];
  isLoading: boolean;
  error: string | null;
  fetchPets: () => Promise<void>;
  getPetById: (id: number) => Promise<Pet | undefined>;
}

const usePetStore = create<PetState>((set) => ({
  pets: [],
  isLoading: false,
  error: null,

  fetchPets: async () => {
    set({ isLoading: true, error: null });
    try {
      const { data } = await apiClient.get<Pet[]>("/Pets");
      set({ pets: data, isLoading: false });
    } catch (error) {
      console.error("Failed to fetch pets", error);
      set({ isLoading: false, error: "Failed to fetch pets." });
    }
  },

  getPetById: async (id: number) => {
    try {
        const { data } = await apiClient.get<Pet>(`/Pets/${id}`);
        return data;
    } catch (error) {
        console.error(`Failed to fetch pet with id ${id}`, error);
        return undefined;
    }
  },
}));

export default usePetStore;