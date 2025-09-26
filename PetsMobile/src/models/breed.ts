export interface BreedDTO {
  id: number;
  name: string | null;
  description: string | null;
}

export interface BreedRequest {
  name: string | null;
  description: string | null;
}