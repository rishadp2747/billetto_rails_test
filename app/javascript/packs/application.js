import React from "react";
import ReactRailsUJS from "react_ujs";

let globalProps = {};
window.globalProps = 
  JSON.parse(
    document.getElementsByClassName("root-container")[0]?.dataset
      ?.reactProps || "{}"
  )

globalProps = window.globalProps;

const componentsContext = {
  App: React.lazy(() => import("../src/components/App"))
};

ReactRailsUJS.getConstructor = name => {
  return componentsContext[name];
};