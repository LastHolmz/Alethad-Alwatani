import React, { Suspense } from "react";
import { getBrands, getCategories } from "@/app/db/categories";
import BrandsTable from "../../components/reusable-table";
import { NewBrandForm } from "../components/forms";
import brandColumn from "../components/brand-columns";

const page = async () => {
  const categories = await getCategories();
  const brands = await getBrands();
  return (
    <main>
      <div className=" my-4 container">
        <div className="">
          <Suspense fallback={"جاري التحميل"}>
            <BrandsTable
              data={brands}
              columns={brandColumn}
              searchQuery="title"
            >
              <NewBrandForm data={categories} />
            </BrandsTable>
          </Suspense>
        </div>
      </div>
    </main>
  );
};

export default page;
