export interface PetDTO {
  id: number;
  name: string | null;
  color: string | null;
  age: number;
  imageUrl: string | null;
  description: string | null;
  breedName: string | null;
  breedDescription: string | null;
}

export interface PetRequest {
  name: string | null;
  color: string | null;
  age: number;
  imageUrl: string | null;
  description: string | null;
  breedId: number;
}