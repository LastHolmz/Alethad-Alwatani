import React, { ReactNode } from "react";
// import Header from "../components/header/header";

const layout = ({ children }: { children: ReactNode }) => {
  return (
    <main className="bg-secondary min-h-screen flex justify-center items-center">
      <div className="w-full">{children}</div>
    </main>
  );
};

export default layout;
