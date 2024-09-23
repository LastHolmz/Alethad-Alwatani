"use client";

import useLocalStorage from "use-local-storage";
import { useEffect } from "react";

function UpdateDataToLocalStorage<T>({
  data,
  keyValue,
}: {
  data: T;
  keyValue: string;
}) {
  console.log(keyValue);
  console.log(data);
  const [_, setCategories] = useLocalStorage<T>(keyValue, data);

  useEffect(() => {
    setCategories(data);
  }, [data]);

  return null;
}

export default UpdateDataToLocalStorage;
