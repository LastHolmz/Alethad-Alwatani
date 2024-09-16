import { cn } from "@/lib/utils";
import React from "react";

const NotFoundTable = ({
  title = "لا يوجد",
  className,
}: {
  title?: string;
  className?: string;
}) => {
  return (
    <div
      className={cn(
        "rounded px-2 py-0.5 text-center bg-red-200 text-red-700",
        className
      )}
    >
      {title}
    </div>
  );
};

export default NotFoundTable;
