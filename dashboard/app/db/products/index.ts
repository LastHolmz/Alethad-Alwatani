"use server";

import { revalidateTag, unstable_cache, unstable_noStore } from "next/cache";
import uri from "@/lib/uri";
import { getSession } from "@/lib/auth";

export const getProducts = async () => {
  unstable_noStore();
  try {
    const authUser = await getSession();
    if (!authUser) {
      return [];
    }
    const res = await fetch(`${uri}/products`, {
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${authUser.token}`,
      },
    });
    if (!res.ok) {
      return [];
    }
    const data: { data: Product[] } = await res.json();
    return data.data;
  } catch (error) {
    console.log(error);
    return [];
  }
};

export const createProduct = async ({
  product,
}: {
  product: Omit<Product, "id" | "createdAt" | "updatedAt">;
}): Promise<{ message: string }> => {
  try {
    const authUser = await getSession();
    if (!authUser) {
      return { message: "يجب تسجيل الدخول للتمكن من اكمال العملية" };
    }
    const res = await fetch(`${uri}/products`, {
      method: "POST",
      body: JSON.stringify(product),
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${authUser.token}`,
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
    const authUser = await getSession();
    if (!authUser) {
      return { message: "يجب تسجيل الدخول للتمكن من اكمال العملية" };
    }
    const res = await fetch(`${uri}/products/${product.id}`, {
      method: "PUT",
      body: JSON.stringify(product),
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${authUser.token}`,
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
    const authUser = await getSession();
    if (!authUser) {
      return { message: "يجب تسجيل الدخول للتمكن من اكمال العملية" };
    }
    const res = await fetch(`${uri}/products/${id}`, {
      method: "DELETE",
      // body: JSON.stringify(product),
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${authUser.token}`,
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
  unstable_noStore();
  try {
    const authUser = await getSession();
    if (!authUser) {
      return undefined;
    }
    const res = await fetch(`${uri}/products/${id}`, {
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${authUser.token}`,
      },
    });
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
