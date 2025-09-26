import axios from "axios";
import { AuthResult } from "../types";

const apiClient = axios.create({
  baseURL: "http://10.0.2.2:5000/api/v3",
});

apiClient.interceptors.request.use(
  async (config) => {
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;
    if (error.response.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;
      try {
        const { data } = await apiClient.put<AuthResult>("/auth/refresh");

        if (data.accessToken) {
          apiClient.defaults.headers.common["Authorization"] = "Bearer " + data.accessToken;
          originalRequest.headers["Authorization"] = "Bearer " + data.accessToken;
          return apiClient(originalRequest);
        }
      } catch (refreshError) {
        return Promise.reject(refreshError);
      }
    }
    return Promise.reject(error);
  }
);

export default apiClient;