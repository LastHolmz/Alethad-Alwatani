"use client";

import useLocalStorage from "use-local-storage";
import { useEffect } from "react";

function UpdateDataToLocalStorage<T>({
  data,
  key,
}: {
  data: Category[];
  key: string;
}) {
  const [_, setCategories] = useLocalStorage<typeof data>(key, data);

  useEffect(() => {
    setCategories(data);
  }, [data]);

  return null;
}

export default UpdateDataToLocalStorage;
