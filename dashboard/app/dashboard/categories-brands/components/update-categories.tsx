"use client";

import useLocalStorage from "use-local-storage";
import { useEffect } from "react";

function UpdateDataToLocalStorage<T>({ data, key }: { data: T; key: string }) {
  const [_, setCategories] = useLocalStorage<T>(key, data);

  useEffect(() => {
    setCategories(data);
  }, [data]);

  return null;
}

export default UpdateDataToLocalStorage;
