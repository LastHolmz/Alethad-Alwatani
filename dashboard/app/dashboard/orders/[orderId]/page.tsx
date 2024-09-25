import { getBrands, getCategories } from "@/app/db/categories";
import { getProductById } from "@/app/db/products";
import { notFound } from "next/navigation";
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb";
import Link from "next/link";
import DashboardHeader from "@/app/dashboard/components/dashboard-header";
// import { UpdateProductForm } from "../../components/forms";
import { getOrderById } from "@/app/db/orders";
import ReusableTable from "../../components/reusable-table";
import { cartColumn } from "../components/cartItem-column";
import { Suspense } from "react";
import { Separator } from "@/components/ui/separator";
import { OrderStatusCard } from "../components/order-column";
import { getOrderQty } from "@/lib/order";
import { parseDateTime } from "@/lib/date";
import { FaPrint } from "react-icons/fa";
import ExportButton from "../components/extract-as-exel";
import { CustomLink } from "@/components/ui/custom-link";
import {
  AcceptOrderForm,
  RejectOrderForm,
  ReturnOrderForm,
  UpdateOrderMoenyForm,
} from "../components/forms";
const page = async ({ params }: { params: { orderId: string } }) => {
  const { orderId } = params;
  const order = await getOrderById(orderId);

  if (!order) {
    return notFound();
  }

  return (
    <main>
      <DashboardHeader>
        <Breadcrumb className="my-2" dir="rtl">
          <BreadcrumbList>
            <BreadcrumbItem>
              <BreadcrumbLink asChild>
                <Link href={`/`}>الرئيسية</Link>
              </BreadcrumbLink>
            </BreadcrumbItem>
            <BreadcrumbSeparator />
            <BreadcrumbItem>
              <BreadcrumbLink asChild>
                <Link href={`/dashboard`}>لوحة التحكم</Link>
              </BreadcrumbLink>
            </BreadcrumbItem>
            <BreadcrumbSeparator />
            <BreadcrumbItem>
              <BreadcrumbLink asChild>
                <Link href={`/dashboard/orders`}>الفواتير</Link>
              </BreadcrumbLink>
            </BreadcrumbItem>
            <BreadcrumbSeparator />
            <BreadcrumbItem>
              <BreadcrumbPage>{order.barcode}</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>
      </DashboardHeader>

      <div className="md:container mx-8 flex-col md:flex-row flex my-10 justify-between gap-10 items-start">
        <div className="my-5 min-w-64 md:w-1/2 w-full grid gap-2">
          <h1 className=" text-center font-bold text-2xl">معلومات</h1>
          <Separator />
          <ul className="grid gap-2">
            <li className="flex justify-between items-center">
              <div>الباركود</div>
              <div>{order.barcode}</div>
            </li>
            <Separator />
            <li className="flex justify-between items-center">
              <div>السعر الكلي</div>
              <div>{order.totalPrice} دينار</div>
            </li>
            <Separator />
            <li className="flex justify-between items-center">
              <div>تم دفع</div>
              <div>{order.totalPrice - order.rest} دينار</div>
            </li>
            <Separator />
            <li className="flex justify-between items-center">
              <div>المتبقي</div>
              <div>{order.rest} دينار</div>
            </li>
            <Separator />
            <li className="flex justify-between items-center">
              <div>حالة الفاتورة</div>
              <div>
                <OrderStatusCard status={order.status} className=" text-xs" />
              </div>
            </li>
            <Separator />
            <li className="flex justify-between items-center">
              <div>عدد القطع</div>
              <div>{getOrderQty(order)}</div>
            </li>
            <Separator />
            <li className="flex justify-between items-center">
              <div>تاريخ الإنشاء</div>
              <div>
                {parseDateTime({ dateTime: new Date(order.createdAt) })}
              </div>
            </li>
            <Separator />
            <li className="flex justify-between items-center">
              <div>اسم التاجر</div>
              <div>{order?.user?.fullName}</div>
            </li>
            <Separator />
            <li className="flex justify-between items-center">
              <div>رقم الهاتف</div>
              <div>{order?.user?.mobile}</div>
            </li>
            <Separator />
          </ul>
        </div>

        <Suspense fallback={"جاري التحميل"}>
          <ReusableTable
            showSearch={false}
            columns={cartColumn}
            data={order?.orderItems ?? []}
          >
            <div className="inline-flex flex-1">
              <div className="flex justify-between items-center">
                <div>
                  <ExportButton order={order} user={order.user} />
                  <CustomLink
                    variant={"outline"}
                    href={`/dashboard/orders/${order.id}/print`}
                  >
                    طباعة
                    <FaPrint className="mr-2 w-4 h-4 text-blue-500" />
                  </CustomLink>
                </div>
                <div>
                  <ReturnOrderForm order={order} />
                  <AcceptOrderForm order={order} />
                  <RejectOrderForm order={order} />
                  <UpdateOrderMoenyForm order={order} />
                </div>
              </div>
            </div>
          </ReusableTable>
        </Suspense>
      </div>
    </main>
  );
};

export default page;
