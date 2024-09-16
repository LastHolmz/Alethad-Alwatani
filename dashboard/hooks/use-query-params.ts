"use client";

import { useRouter, useSearchParams, usePathname } from "next/navigation";
import { useCallback } from "react";

export function useQueryParam() {
  const searchParams = useSearchParams();
  const pathname = usePathname();
  const { replace } = useRouter();

  const deleteParams = useCallback(
    (values: { key: string; value: string | null }[]) => {
      const params = new URLSearchParams(searchParams as any);
      if (values.length > 0) {
        for (let i = 0; i < values.length; i++) {
          params.delete(values[i].key, values[i].value ?? "");
        }
      } else {
        // params.delete(values[0].ke);
      }
      replace(`${pathname}`);
    },
    [searchParams, pathname, replace]
  );
  const setParams = useCallback(
    (values: { key: string; value: string | null }[]) => {
      const params = new URLSearchParams(searchParams as any);
      if (values.length > 0) {
        for (let i = 0; i < values.length; i++) {
          params.set(values[i].key, values[i].value ?? "");
        }
      } else {
        // params.delete(values[0].ke);
      }
      replace(`${pathname}?${params.toString()}`);
    },
    [searchParams, pathname, replace]
  );
  const switchParam = useCallback(
    (key: string, value: string) => {
      const params = new URLSearchParams(searchParams as any);
      const oldValue = params.get(key);
      console.log(oldValue);
      console.log(oldValue?.length);
      if (!oldValue || oldValue.length < 1) {
        params.append(key, value);
      } else {
        params.delete(key);
      }

      replace(`${pathname}?${params.toString()}`);
    },
    [searchParams, pathname, replace]
  );

  return { setParam: setParams, deleteParams, switchParam };
}
