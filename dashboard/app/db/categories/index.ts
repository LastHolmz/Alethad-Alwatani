"use server";

import uri from "@/lib/uri";
import { revalidateTag, unstable_cache } from "next/cache";

export const getCategories = unstable_cache(
  async () => {
    try {
      const res = await fetch(`${uri}/categories`);
      const data: { data: Category[] } = await res.json();
      return data.data;
    } catch (error) {
      console.log(error);
      return [];
    }
  },
  ["categories"],
  { tags: ["categories"] }
);

export const createCategory = async ({
  categroy,
}: {
  categroy: Omit<Category, "id" | "brandIds" | "productIDs">;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/categories`, {
      method: "POST",
      body: JSON.stringify(categroy),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });

    const data: { data: Category; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء الصنف" };
    }

    revalidateTag("categories");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};
export const updateCategory = async ({
  categroy,
}: {
  categroy: Omit<Category, "brandIds" | "productIDs">;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/categories/${categroy.id}`, {
      method: "PUT",
      body: JSON.stringify(categroy),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });

    const data: { data: Category; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء الصنف" };
    }

    revalidateTag("categories");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};
export const deleteCategory = async ({
  id,
}: {
  id: string;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/categories/${id}`, {
      method: "DELETE",
      // body: JSON.stringify(categroy),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });

    const data: { data: Category; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء الصنف" };
    }

    revalidateTag("categories");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};
export const updateBrand = async ({
  brand,
}: {
  brand: Omit<Brand, "productIDs">;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/brands/${brand.id}`, {
      method: "PUT",
      body: JSON.stringify(brand),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });

    const data: { data: Category; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء الصنف" };
    }

    revalidateTag("categories");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};
export const deleteBrand = async ({
  id,
}: {
  id: string;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/brands/${id}`, {
      method: "Delete",
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });

    const data: { data: Category; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء الصنف" };
    }

    revalidateTag("categories");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};
export const createBrand = async ({
  brand,
}: {
  brand: Omit<Brand, "id" | "productIDs">;
}): Promise<{ message: string }> => {
  try {
    const res = await fetch(`${uri}/brands`, {
      method: "POST",
      body: JSON.stringify(brand),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });

    const data: { data: Category; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء الصنف" };
    }

    revalidateTag("categories");

    return { message: data.message };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};

export const getBrands = unstable_cache(
  async () => {
    try {
      const res = await fetch(`${uri}/brands`);
      const data: { data: Brand[] } = await res.json();
      return data.data;
    } catch (error) {
      console.log(error);
      return [];
    }
  },
  ["categories"],
  { tags: ["categories"] }
);
