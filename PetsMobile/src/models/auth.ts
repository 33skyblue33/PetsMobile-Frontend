import { UserDTO } from './user';

export interface LoginRequest {
  email: string | null;
  password: string | null;
}

export interface AuthResultDTO {
  accessToken: string | null;
  user: UserDTO;
}