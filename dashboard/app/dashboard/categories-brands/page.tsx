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
import { getCategories } from "@/app/db/categories";
import CategoryTable from "../components/reusable-table";
import categroyColumn from "./components/columns";
import { NewBrandForm, NewCategoryForm } from "./components/forms";
import UpdateDataToLocalStorage from "./components/update-categories";

const page = async () => {
  const categories = await getCategories();
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
              <BreadcrumbPage>الاصناف و البراندات</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>
      </DashboardHeader>
      <div className=" my-4 container">
        <div className="">
          <Suspense fallback={"جاري التحميل"}>
            <CategoryTable
              data={categories}
              columns={categroyColumn}
              searchQuery="title"
            >
              {/* <CustomLink
              className="mx-2"
              variant={"destructive"}
              href="products/new"
            >
              منتج جديد
            </CustomLink> */}

              <NewBrandForm data={categories} />
              <NewCategoryForm></NewCategoryForm>
            </CategoryTable>
          </Suspense>
        </div>
      </div>
      <UpdateDataToLocalStorage data={categories} key={"categories"} />
    </main>
  );
};

export default page;
