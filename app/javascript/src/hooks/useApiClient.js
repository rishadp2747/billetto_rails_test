import axios from "axios";
import { useAuth } from "@clerk/clerk-react";

export const useApiClient = () => {
  const { getToken } = useAuth();
  const api = axios.create();

  api.interceptors.request.use(async (config) => {
    const token = await getToken();

    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    return config;
  });

  return api;
}
