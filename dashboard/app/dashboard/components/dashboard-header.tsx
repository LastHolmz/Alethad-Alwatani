import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import React, { ReactNode } from "react";

const DashboardHeader = ({ children }: { children?: ReactNode }) => {
  return (
    <header className="flex justify-between items-center px-8 py-4 bg-white">
      <div>{children}</div>

      <Avatar>
        <AvatarImage src="https://github.com/shadcn.png" alt="@shadcn" />
        <AvatarFallback>CN</AvatarFallback>
      </Avatar>
    </header>
  );
};

export default DashboardHeader;
