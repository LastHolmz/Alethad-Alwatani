"use server";

import { revalidatePath, unstable_noStore } from "next/cache";
import uri from "@/lib/uri";

export const getUseres = async (query?: string) => {
  unstable_noStore();
  try {
    const res = await fetch(`${uri}/users?${query && `name=${query}`}`);
    if (!res.ok) {
      return [];
    }
    const data: { data: User[] } = await res.json();
    return data.data;
  } catch (error) {
    console.log(error);
    return [];
  }
};

export const createUser = async ({
  user,
}: {
  user: Omit<User, "id" | "createdAt" | "updatedAt" | "orders">;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/users`, {
      method: "POST",
      body: JSON.stringify(user),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });
    console.log(JSON.stringify(user));
    const data: { data: Product; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء المنتج" };
    }

    revalidatePath("/");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};

export const updateUserStatus = async ({
  id,
  status,
}: {
  id: string;
  status: string;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/users/${id}`, {
      method: "PUT",
      // body: JSON.stringify(product),
      headers: {
        "Content-Type": "application/json",

        // Add the Content-Type header
      },
      body: JSON.stringify({
        status: status,
      }),
    });

    const data: { data: Product; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء تحديث المستخدم" };
    }

    revalidatePath("/");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};
