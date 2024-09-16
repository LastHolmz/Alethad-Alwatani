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
import { getProducts } from "@/app/db/products";
import { productColumn } from "./components/product-column";
import ProductTable from "../components/reusable-table";
import { CustomLink } from "@/components/ui/custom-link";
import { revalidateTag } from "next/cache";

const page = async () => {
  revalidateTag("products");
  console.log("fixxess");
  // console.log(env.UPLOADTHING_APP_ID);
  const products = await getProducts();
  // console.log(products);
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
              <BreadcrumbPage>المنتجات</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>
      </DashboardHeader>

      <div className=" my-4 container">
        {" "}
        <Suspense fallback={"جاري التحميل"}>
          <ProductTable
            data={products}
            columns={productColumn}
            searchQuery="title"
          >
            <CustomLink
              className="mx-2"
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
