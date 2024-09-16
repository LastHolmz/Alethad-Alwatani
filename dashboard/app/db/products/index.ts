"use server";

import { revalidateTag, unstable_cache } from "next/cache";
import uri from "@/lib/uri";

export const getProducts = unstable_cache(
  async () => {
    try {
      const res = await fetch(`${uri}/products`);
      const data: { data: Product[] } = await res.json();
      return data.data;
    } catch (error) {
      console.log(error);
      return [];
    }
  },
  ["products"],
  { tags: ["products"] }
);

export const createProduct = async ({
  product,
}: {
  product: Omit<Product, "id" | "createdAt" | "updatedAt">;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/products`, {
      method: "POST",
      body: JSON.stringify(product),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });
    console.log(JSON.stringify(product));
    const data: { data: Product; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء المنتج" };
    }

    revalidateTag("products");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};
