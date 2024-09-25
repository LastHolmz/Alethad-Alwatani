"use server";

import { revalidatePath, unstable_noStore } from "next/cache";
import uri from "@/lib/uri";
import { getSession } from "@/lib/auth";

export const getUseres = async (query?: string) => {
  unstable_noStore();
  try {
    const user = await getSession();
    if (!user) {
      return [];
    }

    const res = await fetch(`${uri}/users?${query && `name=${query}`}`, {
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${user.token}`,
      },
    });
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
    const authUser = await getSession();
    if (!authUser) {
      return { message: "يجب تسجيل الدخول للتمكن من اكمال العملية" };
    }

    const res = await fetch(`${uri}/users`, {
      method: "POST",
      body: JSON.stringify(user),
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${authUser.token}`,

        // Add the Content-Type header
      },
    });
    console.log(JSON.stringify(authUser));
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
    const authUser = await getSession();
    if (!authUser) {
      return { message: "يجب تسجيل الدخول للتمكن من اكمال العملية" };
    }

    const res = await fetch(`${uri}/users/${id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${authUser.token}`,
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
