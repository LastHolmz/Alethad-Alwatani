import React, { Suspense } from "react";

import { getCategories } from "@/app/db/categories";
import CategoryTable from "../components/reusable-table";
import categroyColumn from "./components/columns";
import { NewCategoryForm } from "./components/forms";
import UpdateDataToLocalStorage from "./components/update-categories";

const page = async () => {
  const categories = await getCategories();
  return (
    <main>
      <div className=" my-4 md:container">
        <Suspense fallback={"جاري التحميل"}>
          <CategoryTable
            data={categories}
            columns={categroyColumn}
            searchQuery="title"
          >
            <NewCategoryForm></NewCategoryForm>
          </CategoryTable>
        </Suspense>
      </div>
      <UpdateDataToLocalStorage data={categories} keyValue={"categories"} />
    </main>
  );
};

export default page;
