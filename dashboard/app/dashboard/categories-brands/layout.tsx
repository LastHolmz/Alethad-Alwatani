// import { Metadata } from "next";
import { ReactNode } from "react";
import NavigationTabs, { HomeTabLink, TabLink } from "../components/navigation";
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
// export const metadata: Metadata = {
//   title: " our gym | لوحة التحكم قسم الإستقبال",
// };
const layout = ({ children }: { children: ReactNode }) => {
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
      <NavigationTabs className="my-1">
        <HomeTabLink href={`/dashboard/categories-brands`} content="الأصناف" />
        <TabLink
          href={`/dashboard/categories-brands/brands`}
          content="البراندات"
        />
      </NavigationTabs>
      {children}
    </main>
  );
};

export default layout;
