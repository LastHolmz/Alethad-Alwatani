import { Row } from "@tanstack/react-table";
import React, { ReactNode } from "react";
import NotFoundTable from "./not-found-table";

export default function ReusableRow<T>({
  row,
  children,
}: {
  row: Row<T>;
  children?: ReactNode;
}) {
  if (!row) {
    return <NotFoundTable />;
  } else {
    return <>{children}</>;
  }
}
