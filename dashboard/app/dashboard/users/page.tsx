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
import { usersColumn } from "./components/user-column";
import ProductTable from "../components/reusable-table";
import { getUseres } from "@/app/db/users";
import { CreateUserForm } from "./components/forms";

const page = async ({
  searchParams,
}: {
  searchParams?: { query?: string };
}) => {
  const users = await getUseres(searchParams.query);
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
              <BreadcrumbPage>المستخدمين</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>
      </DashboardHeader>

      <div className=" my-4 md:container">
        {" "}
        <Suspense fallback={"جاري التحميل"}>
          <ProductTable
            data={users}
            columns={usersColumn}
            searchQuery="query"
            defaultColumnVisibility={{
              ["الجنس"]: false,
              ["اسم الشركة"]: false,
              ["رقم الشركة"]: false,
            }}
          >
            <CreateUserForm />
          </ProductTable>
        </Suspense>
      </div>
    </main>
  );
};

export default page;
