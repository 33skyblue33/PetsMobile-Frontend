import { create } from "zustand";
import * as SecureStore from "expo-secure-store";
import apiClient from "../api";
import { AuthResult, LoginRequest, User, UserRequest } from "../types";

const REFRESH_TOKEN_KEY = "refreshToken";

interface AuthState {
  user: User | null;
  accessToken: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (credentials: LoginRequest) => Promise<void>;
  logout: () => Promise<void>;
  register: (userData: UserRequest) => Promise<void>;
  checkAuth: () => Promise<void>;
}

const useAuthStore = create<AuthState>((set, get) => ({
  user: null,
  accessToken: null,
  isAuthenticated: false,
  isLoading: true,

  login: async (credentials) => {
    const { data } = await apiClient.post<AuthResult>("/Auth/login", credentials);
    const { accessToken, user } = data;

    apiClient.defaults.headers.common["Authorization"] = `Bearer ${accessToken}`;
    await SecureStore.setItemAsync(REFRESH_TOKEN_KEY, "fake-refresh-token");

    set({ user, accessToken, isAuthenticated: true });
  },

  logout: async () => {
    try {
      await apiClient.post("/Auth/logout");
    } catch (error) {
      console.error("Logout failed, clearing session locally.", error);
    } finally {
      delete apiClient.defaults.headers.common["Authorization"];
      await SecureStore.deleteItemAsync(REFRESH_TOKEN_KEY);
      set({ user: null, accessToken: null, isAuthenticated: false });
    }
  },

  register: async (userData) => {
    await apiClient.post("/Users", userData);
  },

  checkAuth: async () => {
    try {
      const refreshToken = await SecureStore.getItemAsync(REFRESH_TOKEN_KEY);
      if (!refreshToken) {
        throw new Error("No refresh token found");
      }

      const { data } = await apiClient.put<AuthResult>("/Auth/refresh");
      const { accessToken, user } = data;

      apiClient.defaults.headers.common["Authorization"] = `Bearer ${accessToken}`;

      set({ user, accessToken, isAuthenticated: true });
    } catch (e) {
      await get().logout();
    } finally {
      set({ isLoading: false });
    }
  },
}));

export default useAuthStore;