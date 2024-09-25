import { changeOrderStatus } from "@/app/db/orders";
import { z } from "zod";

const OrderStatusEnum = z.enum([
  "pending",
  "inProgress",
  "done",
  "rejected",
  "refused",
]);
const toLinkEnum = z.enum(["cancel", "accept", "return"]);
export async function updateOrderAction(
  prevState: {
    message: string;
  },
  formData: FormData
) {
  try {
    const schema = z.object({
      id: z.string(),
      status: OrderStatusEnum,
      to: toLinkEnum,
    });
    console.log(`schema: ${schema}`);

    const data = schema.safeParse({
      id: formData.get("id"),
      status: formData.get("status"),
      to: formData.get("to"),
    });
    console.log(data);
    if (!data.success) {
      return { message: "يجب أن يتم ملء جميع الحقول" };
    }
    const { id, status, to } = data.data;

    const newProduct = await changeOrderStatus({
      id,
      status,
      to,
    });
    return { message: newProduct.message };
  } catch (e) {
    console.log(e);
    return { message: "فشلت العملية" };
  }
}
