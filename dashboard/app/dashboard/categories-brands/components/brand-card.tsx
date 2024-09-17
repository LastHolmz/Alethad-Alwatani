import {
  HoverCard,
  HoverCardContent,
  HoverCardTrigger,
} from "@/components/ui/hover-card";
import { DeleteBrandForm, UpdateBrandForm } from "./forms";

const BrandCard = ({
  brand: { title, categoryIDs, id, categories, image },
}: {
  brand: Brand;
  data: Category[];
}) => {
  return (
    <HoverCard>
      <HoverCardTrigger asChild>
        <button className=" rounded px-2 py-0.5 text-blue-700 bg-blue-200 text-center">
          {title}
          {/* {brand.title} */}
        </button>
        {/* <button>hi</button> */}
      </HoverCardTrigger>
      <HoverCardContent className="w-60 mx-auto">
        <div className="grid gap-1 px-1 py-0.5">
          <DeleteBrandForm
            brand={{
              categoryIDs,
              id,
              title,
              categories,
              image,
              productIDs: [],
            }}
          />
          <UpdateBrandForm
            brand={{
              categoryIDs,
              id,
              title,
              categories,
              image,
              productIDs: [],
            }}
          />
        </div>
      </HoverCardContent>
    </HoverCard>
  );
};

export default BrandCard;
