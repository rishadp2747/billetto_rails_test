import React from "react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import Events from "./Events";
import { ClerkProvider,SignedIn, SignedOut, SignInButton, UserButton } from '@clerk/clerk-react'

const queryClient = new QueryClient();

const App = () => {
  return (
    <ClerkProvider publishableKey={window.globalProps.clerk_publishable_key}>
      <QueryClientProvider client={queryClient}>
        <SignedOut>
          <SignInButton />
        </SignedOut>
        <SignedIn>
          <UserButton />
          <Events/>
        </SignedIn>
      </QueryClientProvider>
    </ClerkProvider>
  );
};

export default App;