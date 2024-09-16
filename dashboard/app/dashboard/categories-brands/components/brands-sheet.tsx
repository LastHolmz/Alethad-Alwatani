import { getCategories } from "@/app/db/categories";
import ResponsiveDialog from "../../components/responsive-dialog";
import BrandCard from "./brand-card";

const BrandsSheet = ({
  data,
  category,
}: {
  data?: Brand[];
  category: Category;
}) => {
  return (
    <ResponsiveDialog
      trigger={<button>عرض البراندات</button>}
      title={`عرض البراندات المرتبطة بالصنف "${category.title}"`}
    >
      <div className="px-4 py-8 flex flex-wrap gap-2 justify-around">
        {data
          ? data.map((brand, i) => (
              <BrandCard data={[]} brand={brand} key={i}></BrandCard>
            ))
          : "لا يوجد براندات بعد"}
      </div>
    </ResponsiveDialog>
  );
};

export default BrandsSheet;
