import { useAuth } from "@clerk/clerk-react";

const { getToken } = useAuth();


export const fetchEvents = async (page = 1) => {
  const response = await fetch(`/api/v1/events?page=${page}`);

  if (!response.ok) {
    throw new Error("Failed to fetch events");
  }

  return response.json();
};