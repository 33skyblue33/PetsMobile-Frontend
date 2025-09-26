export interface UserDTO {
  id: number;
  name: string | null;
  surname: string | null;
  age: number;
  email: string | null;
}

export interface UserRequest {
  name: string | null;
  surname: string | null;
  age: number;
  email: string | null;
  password: string | null;
}