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
import { UpdateProductForm } from "../../components/forms";
const page = async ({ params }: { params: { productId: string } }) => {
  const product = await getProductById(params.productId);
  const categories = await getCategories();
  const brands = await getBrands();

  if (!product) {
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
                <Link href={`/dashboard/products`}>المنتجات</Link>
              </BreadcrumbLink>
            </BreadcrumbItem>
            <BreadcrumbSeparator />
            <BreadcrumbItem>
              <BreadcrumbPage>تحديث {product.title}</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>
      </DashboardHeader>
      <div className="container">
        <UpdateProductForm
          product={product}
          categories={categories}
          brands={brands}
        />
      </div>
    </main>
  );
};

export default page;
