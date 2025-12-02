import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useApiClient } from "./useApiClient";

export const useEventsApi = (page = 1) => {
  const api = useApiClient();
  const fetchEvents = () =>
    api.get(`/api/v1/events?page=${page}`).then((res) => res.data);

  return useQuery({
    queryKey: ["events", page],
    queryFn: fetchEvents
  });
}

export const useEventsVoteApi = () => {
    const api = useApiClient();
    const queryClient = useQueryClient();
    
    return useMutation({
        mutationFn: (payload) =>
          api.post("/api/v1/event_votes", payload),
    
        onSuccess: () => {
          queryClient.invalidateQueries({ queryKey: ["events"] });
        }
      });
  }
  
