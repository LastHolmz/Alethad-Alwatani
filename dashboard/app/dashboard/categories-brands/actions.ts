import {
  createBrand,
  createCategory,
  deleteBrand,
  deleteCategory,
  updateBrand,
  updateCategory,
} from "@/app/db/categories";
import { z } from "zod";
/* category */
export async function newCategoryAction(
  prevState: {
    message: string;
  },
  formData: FormData
) {
  try {
    const schema = z.object({
      title: z.string(),
      main: z.string().nullable(),
      image: z.string().url().nullable().optional(),
    });
    console.log(`schema: ${schema}`);

    const data = schema.safeParse({
      image: formData.get("image"),
      title: formData.get("title"),
      main: formData.get("main"),
    });
    console.log(data);
    console.log(data.success);
    if (!data.success) {
      return { message: "يجب أن يتم ملء جميع الحقول" };
    }
    const { title, main, image } = data.data;
    if (!image) {
      return { message: "يجب رفع صورة المنتج" };
    }
    const newCategory = await createCategory({
      categroy: {
        image,
        title,
        main: main === "on" ? true : false,
      },
    });
    return { message: newCategory.message };
  } catch (e) {
    console.log(e);
    return { message: "فشلت العملية" };
  }
}
export async function updateCategoryAction(
  prevState: {
    message: string;
  },
  formData: FormData
) {
  try {
    const schema = z.object({
      title: z.string(),
      id: z.string(),
      main: z.string().nullable(),
      image: z.string().url().nullable().optional(),
    });
    console.log(`schema: ${schema}`);

    const data = schema.safeParse({
      image: formData.get("image"),
      id: formData.get("id"),
      title: formData.get("title"),
      main: formData.get("main"),
    });
    console.log(data);
    console.log(data.success);
    if (!data.success) {
      return { message: "يجب أن يتم ملء جميع الحقول" };
    }
    const { title, main, image, id } = data.data;
    if (!image) {
      return { message: "يجب رفع صورة المنتج" };
    }
    const newCategory = await updateCategory({
      categroy: {
        image,
        title,
        main: main === "on" ? true : false,
        id,
      },
    });
    return { message: newCategory.message };
  } catch (e) {
    console.log(e);
    return { message: "فشلت العملية" };
  }
}
export async function deleteCategoryAction(
  prevState: {
    message: string;
  },
  formData: FormData
) {
  try {
    const schema = z.object({
      id: z.string(),
    });
    console.log(`schema: ${schema}`);

    const data = schema.safeParse({
      id: formData.get("id"),
    });
    console.log(data);
    console.log(data.success);
    if (!data.success) {
      return { message: "يجب أن يتم ملء جميع الحقول" };
    }
    const { id } = data.data;

    const newCategory = await deleteCategory({
      id,
    });
    return { message: newCategory.message };
  } catch (e) {
    console.log(e);
    return { message: "فشلت العملية" };
  }
}
/* brand */
export async function newBrandAction(
  prevState: {
    message: string;
  },
  formData: FormData
) {
  try {
    const schema = z.object({
      title: z.string(),
      ids: z.string().nullable(),
      image: z.string().url().nullable().optional(),
    });
    console.log(`schema: ${schema}`);

    const data = schema.safeParse({
      image: formData.get("image"),
      title: formData.get("title"),
      ids: formData.get("ids"),
    });
    let ids = data.data?.ids ? data.data.ids.split(",") : [];
    console.log(data);
    console.log(data.success);

    if (!data.success) {
      return { message: "يجب أن يتم ملء جميع الحقول" };
    }

    const { title, image } = data.data;
    if (!image) {
      return { message: "يجب رفع صورة المنتج" };
    }
    const newCategory = await createBrand({
      brand: {
        image,
        title,
        categoryIDs: ids,
      },
    });
    return { message: newCategory.message };
  } catch (e) {
    console.log(e);
    return { message: "فشلت العملية" };
  }
}
export async function updateBrandAction(
  prevState: {
    message: string;
  },
  formData: FormData
) {
  try {
    const schema = z.object({
      title: z.string(),
      ids: z.string().nullable(),
      image: z.string().url().nullable().optional(),
      id: z.string(),
    });
    console.log(`schema: ${schema}`);

    const data = schema.safeParse({
      image: formData.get("image"),
      title: formData.get("title"),
      ids: formData.get("ids"),
      id: formData.get("id"),
    });
    let ids = data.data?.ids ? data.data.ids.split(",") : [];
    console.log(data);
    console.log(data.success);

    if (!data.success) {
      return { message: "يجب أن يتم ملء جميع الحقول" };
    }

    const { title, image, id } = data.data;
    if (!image) {
      return { message: "يجب رفع صورة المنتج" };
    }
    const newCategory = await updateBrand({
      brand: {
        image,
        title,
        categoryIDs: ids,
        id,
      },
    });
    return { message: newCategory.message };
  } catch (e) {
    console.log(e);
    return { message: "فشلت العملية" };
  }
}
export async function deleteBrandAction(
  prevState: {
    message: string;
  },
  formData: FormData
) {
  try {
    const schema = z.object({
      id: z.string(),
    });
    console.log(`schema: ${schema}`);

    const data = schema.safeParse({
      id: formData.get("id"),
    });
    console.log(data);
    console.log(data.success);
    if (!data.success) {
      return { message: "يجب أن يتم ملء جميع الحقول" };
    }
    const { id } = data.data;

    const newCategory = await deleteBrand({
      id,
    });
    return { message: newCategory.message };
  } catch (e) {
    console.log(e);
    return { message: "فشلت العملية" };
  }
}
