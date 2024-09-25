"use server";

import { revalidatePath, revalidateTag, unstable_noStore } from "next/cache";
import uri from "@/lib/uri";
import { getSession } from "@/lib/auth";

export const getOrders = async (barcode?: string) => {
  unstable_noStore();
  try {
    const authUser = await getSession();
    if (!authUser) {
      return [];
    }

    const res = await fetch(
      `${uri}/orders?${barcode && `barcode=${barcode}`}`,
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${authUser.token}`,
        },
      }
    );
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

export const changeOrderStatus = async ({
  id,
  status,
  to,
}: {
  id: string;
  status: OrderStatus;
  to: "cancel" | "accept" | "return";
}): Promise<{ message: string }> => {
  console.log(`${uri}/orders/${id}/${to}`);
  try {
    const authUser = await getSession();
    if (!authUser) {
      return { message: "يجب تسجيل الدخول للتمكن من اكمال العملية" };
    }

    const res = await fetch(`${uri}/orders/${id}/${to.trim()}`, {
      method: "PUT",
      // body: JSON.stringify(product),
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${authUser.token}`,

        // Add the Content-Type header
      },
      body: JSON.stringify({ status }),
    });

    const data: { data: Order; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء المنتج" };
    }
    revalidateTag("products");
    revalidatePath("/");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};
export const updateOrderMoney = async ({
  id,
  rest,
  totalPrice,
}: {
  id: string;
  totalPrice: number;
  rest: number;
}): Promise<{ message: string }> => {
  // console.log(`${uri}/orders/${id}/update-money`);
  try {
    const authUser = await getSession();
    if (!authUser) {
      return { message: "يجب تسجيل الدخول للتمكن من اكمال العملية" };
    }

    const res = await fetch(`${uri}/orders/${id}/update-money`, {
      method: "PUT",
      // body: JSON.stringify(product),
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${authUser.token}`,
      },
      body: JSON.stringify({
        totalPrice,
        rest,
      }),
    });

    const data: { data: Order; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء المنتج" };
    }
    revalidateTag("products");
    revalidatePath("/");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};

export const getOrderById = async (id: string) => {
  try {
    const authUser = await getSession();
    if (!authUser) {
      return undefined;
    }
    const res = await fetch(`${uri}/orders/${id}`, {
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${authUser.token}`,
      },
    });
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
