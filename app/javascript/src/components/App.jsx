import React from "react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import Events from "./Events";

const queryClient = new QueryClient();

const App = () => {
  return (
    <QueryClientProvider client={queryClient}>
      <Events />
    </QueryClientProvider>
  );
};

export default App;