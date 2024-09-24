"use client";

import { usePathname } from "next/navigation";
import { ReactNode } from "react";

const DoNotRenderIf = ({
  conditionLable,
  children,
}: {
  conditionLable: string;
  children: ReactNode;
}) => {
  const pathName = usePathname();
  if (pathName.includes(conditionLable)) {
    return <></>;
  }
  return <>{children}</>;
};

export default DoNotRenderIf;
