"use server";

import { revalidateTag, unstable_cache } from "next/cache";
import uri from "@/lib/uri";

export const getProducts = unstable_cache(
  async () => {
    try {
      const res = await fetch(`${uri}/products`);
      if (!res.ok) {
        return [];
      }
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
export const updateProduct = async ({
  product,
}: {
  product: Omit<Product, "createdAt" | "updatedAt">;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/products/${product.id}`, {
      method: "PUT",
      body: JSON.stringify(product),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });

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
export const deleteProduct = async ({
  id,
}: {
  id: string;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/products/${id}`, {
      method: "DELETE",
      // body: JSON.stringify(product),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });

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

export const getProductById = async (id: string) => {
  try {
    const res = await fetch(`${uri}/products/${id}`);
    const data: { data: Product } = await res.json();
    if (!data) {
      return undefined;
    }
    return data.data;
  } catch (error) {
    console.log(error);
    return undefined;
  }
};
