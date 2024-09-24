import { getOrderById } from "@/app/db/orders";
import { notFound } from "next/navigation";
import PrintComponent from "./comp";

const printPage = async ({ params }: { params: { orderId: string } }) => {
  const { orderId } = params;

  const order = await getOrderById(orderId);

  if (!order) {
    return notFound();
  }
  return (
    <div>
      <PrintComponent order={order} />
    </div>
  );
};

export default printPage;
