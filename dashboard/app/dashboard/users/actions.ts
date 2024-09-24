import { createProduct, deleteProduct, updateProduct } from "@/app/db/products";
import { createUser, updateUserStatus } from "@/app/db/users";
import { z } from "zod";

const UserStatusEnum = z.enum(["pending", "active", "inactive"]);
const GenderEnum = z.enum(["man", "woman"]);

export async function newUserAction(
  prevState: {
    message: string;
  },
  formData: FormData
) {
  try {
    const schema = z.object({
      fullName: z.string(),
      mobile: z.string(),
      password: z.string(),
      gender: GenderEnum,
    });
    console.log(`schema: ${schema}`);

    const data = schema.safeParse({
      fullName: formData.get("fullName"),
      mobile: formData.get("mobile"),
      password: formData.get("password"),
      gender: formData.get("gender"),
    });
    console.log(data);
    console.log(data.success);
    if (!data.success) {
      return { message: "يجب أن يتم ملء جميع الحقول" };
    }
    const { fullName, mobile, password, gender } = data.data;

    const user: Omit<User, "createdAt" | "updatedAt" | "id" | "orders"> = {
      companyTitle: "بلا",
      componeyMobile: 911111111,
      fullName,
      gender,
      mobile: Number(mobile),
      password,
      role: "admin",
      status: "active",
      location: "بلا",
    };
    const newUser = await createUser({
      user,
    });
    return { message: newUser.message };
  } catch (e) {
    console.log(e);
    return { message: "فشلت العملية" };
  }
}

export async function updateUserStatusAction(
  prevState: {
    message: string;
  },
  formData: FormData
) {
  try {
    const schema = z.object({
      id: z.string(),
      status: UserStatusEnum,
    });
    console.log(`schema: ${schema}`);

    const data = schema.safeParse({
      id: formData.get("id"),
      status: formData.get("status"),
    });
    console.log(data);
    if (!data.success) {
      return { message: "يجب أن يتم ملء جميع الحقول" };
    }
    const { id, status } = data.data;

    const newProduct = await updateUserStatus({
      id,
      status,
    });
    return { message: newProduct.message };
  } catch (e) {
    console.log(e);
    return { message: "فشلت العملية" };
  }
}
