export interface User {
    id : number;
    name : string;
    age : number;
    email : string;
}

export interface AuthResult {
    accessToken: string;
    user : User;
}

export interface Breed {
    id : number;
    name : string;
    description : string;
}

export interface Pet {
    id : number;
    name : string;
    color : string;
    age : number;
    imageUrl : string;
    description : string;
    breedName : string;
    breedDescription : string;
}

export interface BreedRequest {
    name : string;
    description : string;
}

export interface PetRequest {
    name : string;
    color : string;
    age : number;
    imageUrl : string;
    description : string;
    breedId : number;
}

export interface LoginRequest {
    email : string;
    password : string;
}

export interface UserRequest {
    name : string;
    surname : string;
    age : number;
    email : string;
    password : string;
}