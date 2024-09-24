import React, { Suspense } from "react";
import DashboardHeader from "../components/dashboard-header";
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb";
import Link from "next/link";
import { orderColumn } from "./components/order-column";
import ProductTable from "../components/reusable-table";
import { CustomLink } from "@/components/ui/custom-link";
import { getOrders } from "@/app/db/orders";

const page = async ({
  searchParams,
}: {
  searchParams?: { barcode?: string };
}) => {
  const orders = await getOrders(searchParams.barcode);
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
              <BreadcrumbPage>الفواتير</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>
      </DashboardHeader>

      <div className=" my-4 md:container">
        {" "}
        <Suspense fallback={"جاري التحميل"}>
          <ProductTable
            data={orders}
            columns={orderColumn}
            searchQuery="barcode"
            defaultColumnVisibility={{
              ["رقم الهاتف"]: false,
            }}
          >
            <CustomLink
              className="mx-2 bg-primary hover:bg-primary/80"
              variant={"destructive"}
              href="products/new"
            >
              منتج جديد
            </CustomLink>
          </ProductTable>
        </Suspense>
      </div>
    </main>
  );
};

export default page;
