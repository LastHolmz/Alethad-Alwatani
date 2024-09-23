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
import { Button } from "@/components/ui/button";
import { RefreshCcw } from "lucide-react";
import { revalidateTag } from "next/cache";
// export const metadata: Metadata = {
//   title: " our gym | لوحة التحكم قسم الإستقبال",
// };
const layout = async ({ children }: { children: ReactNode }) => {
  const refresh = async () => {
    "use server";
    revalidateTag("categories");
    revalidateTag("products");
  };
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
      <NavigationTabs className="my-1 flex justify-between items-center">
        <div className=" flex justify-center gap-2 items-center">
          <HomeTabLink
            href={`/dashboard/categories-brands`}
            content="الأصناف"
          />
          <TabLink
            href={`/dashboard/categories-brands/brands`}
            content="البراندات"
          />
        </div>
        <form action={refresh}>
          <Button type={"submit"} size={"icon"} variant={"outline"}>
            <RefreshCcw className="h-4 w-4"></RefreshCcw>
          </Button>
        </form>
      </NavigationTabs>
      {children}
    </main>
  );
};

export default layout;
