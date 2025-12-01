import React from "react";
import ReactRailsUJS from "react_ujs";

const componentsContext = {
  App: React.lazy(() => import("../src/components/App"))
};

ReactRailsUJS.getConstructor = name => {
  return componentsContext[name];
};