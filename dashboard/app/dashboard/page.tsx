import DashboardHeader from "./components/dashboard-header";
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb";
import Link from "next/link";
import { getProducts } from "../db/products";
const dashboardPage = async () => {
  const products = await getProducts();
  console.log(products);
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
              <BreadcrumbPage>لوحة التحكم</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>
      </DashboardHeader>
    </main>
  );
};

export default dashboardPage;
