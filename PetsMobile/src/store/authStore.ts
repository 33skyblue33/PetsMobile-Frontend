import {create} from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { UserDTO } from '../models/user';

interface AuthState {
  user: UserDTO | null;
  token: string | null;
  isAuthenticated: boolean;
  login: (user: UserDTO, token: string) => void;
  logout: () => void;
  checkAuth: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  token: null,
  isAuthenticated: false,
  login: (user, token) => {
    set({ user, token, isAuthenticated: true });
    AsyncStorage.setItem('token', token);
    AsyncStorage.setItem('user', JSON.stringify(user));
  },
  logout: () => {
    set({ user: null, token: null, isAuthenticated: false });
    AsyncStorage.removeItem('token');
    AsyncStorage.removeItem('user');
  },
  checkAuth: async () => {
    const token = await AsyncStorage.getItem('token');
    const userString = await AsyncStorage.getItem('user');
    if (token && userString) {
      const user = JSON.parse(userString);
      set({ user, token, isAuthenticated: true });
    }
  },
}));