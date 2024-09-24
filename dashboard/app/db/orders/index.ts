"use server";

import { revalidatePath, revalidateTag, unstable_noStore } from "next/cache";
import uri from "@/lib/uri";

export const getOrders = async (barcode?: string) => {
  unstable_noStore();
  try {
    const res = await fetch(`${uri}/orders?${barcode && `barcode=${barcode}`}`);
    if (!res.ok) {
      return [];
    }
    const data: { data: Order[] } = await res.json();
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
export const changeOrderStatus = async ({
  id,
  status,
  to,
}: {
  id: string;
  status: OrderStatus;
  to: "cancel" | "accept" | "return";
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/orders/${id}/${to}`, {
      method: "PUT",
      // body: JSON.stringify(product),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
      body: JSON.stringify(status),
    });

    const data: { data: Order; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء المنتج" };
    }

    revalidatePath("/");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};

export const getOrderById = async (id: string) => {
  try {
    const res = await fetch(`${uri}/orders/${id}`);
    const data: { data: Order } = await res.json();
    if (!data) {
      return undefined;
    }
    return data.data;
  } catch (error) {
    console.log(error);
    return undefined;
  }
};
