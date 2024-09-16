import { createProduct } from "@/app/db/products";
import { z } from "zod";

export async function newProductAction(
  prevState: {
    message: string;
  },
  formData: FormData
) {
  try {
    const schema = z.object({
      title: z.string(),
      image: z.string().url().nullable().optional(),
      description: z.string(),
      price: z.string(),
      originalPrice: z.string(),
      barcode: z.string(),
      categoryIDs: z.string(),
      brandIDs: z.string(),
    });
    console.log(`schema: ${schema}`);

    const data = schema.safeParse({
      image: formData.get("image"),
      title: formData.get("title"),
      description: formData.get("description"),
      price: formData.get("price"),
      originalPrice: formData.get("originalPrice"),
      barcode: formData.get("barcode"),
      categoryIDs: formData.get("categoryIDs"),
      brandIDs: formData.get("brandIDs"),
    });
    console.log(data);
    console.log(data.success);
    if (!data.success) {
      return { message: "يجب أن يتم ملء جميع الحقول" };
    }
    const { description, price, title, originalPrice, image, barcode } =
      data.data;
    if (!image) {
      return { message: "يجب رفع صورة المنتج" };
    }
    const categoryIDs = data.data?.categoryIDs
      ? data.data.categoryIDs.split(",")
      : [];
    const brandIDs = data.data?.brandIDs ? data.data.brandIDs.split(",") : [];

    const newProduct = await createProduct({
      product: {
        description,
        image,
        originalPrice: Number(originalPrice),
        price: Number(price),
        title,
        barcode,
        brandIDs,
        categoryIDs,
        sku: [],
      },
    });
    return { message: newProduct.message };
  } catch (e) {
    console.log(e);
    return { message: "فشلت العملية" };
  }
}
