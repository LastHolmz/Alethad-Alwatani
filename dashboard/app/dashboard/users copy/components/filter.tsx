"use client";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { FilterIcon } from "lucide-react";
import { cn } from "@/lib/utils";
import ResponsiveDialog from "@/app/dashboard/components/responsive-dialog";
import { useQueryParam } from "@/hooks/use-query-params";
import { Label } from "@/components/ui/label";
import { Dispatch, SetStateAction, useState } from "react";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";

const Filter = () => {
  const [sortTime, setSortTime] = useState<"asc" | "desc">("desc");
  const [orderType, setOrderType] = useState<"clinic" | "gym">("clinic");
  const { setParam, deleteParams } = useQueryParam();
  const [open, setOpen] = useState(false);

  const handleSearch = (values: { value: string; key: string }[]) => {
    setParam(values);
  };

  return (
    <ResponsiveDialog
      title="تصفية البحث"
      trigger={
        <Button variant={"outline"} className="m-1">
          {"تصفية"}
          <FilterIcon className={cn("mr-2 h-4 w-4")} />
        </Button>
      }
    >
      <SelectSort setSortTime={setSortTime} sortTime={sortTime} />
      <RadioOrderType orderType={orderType} setOrderType={setOrderType} />
      <div className="flex sm:justify-between items-center sm:flex-row flex-col-reverse w-full">
        <Button
          className="w-full sm:w-fit"
          variant={"ghost"}
          onClick={() =>
            deleteParams([
              { key: "createdAt", value: sortTime },
              { key: "type", value: orderType },
            ])
          }
        >
          حذف التصفية
        </Button>
        <Button
          className="w-full sm:w-fit"
          onClick={() => {
            handleSearch([
              { key: "createdAt", value: sortTime },
              { key: "type", value: orderType as "clinic" | "gym" },
            ]);
            setOpen(!open);
          }}
        >
          تطبيق
        </Button>
      </div>
    </ResponsiveDialog>
  );
};

export default Filter;

interface SortProps {
  setSortTime: Dispatch<SetStateAction<"asc" | "desc">>;
  sortTime: "asc" | "desc";
}

interface RadioProps {
  setOrderType: Dispatch<SetStateAction<"clinic" | "gym">>;
  orderType: "clinic" | "gym";
}
export function RadioOrderType({ orderType, setOrderType }: RadioProps) {
  return (
    <RadioGroup
      dir="rtl"
      defaultValue={orderType}
      onValueChange={(e) => setOrderType(e as "clinic" | "gym")}
    >
      <div className="flex items-center space-x-2">
        <Label className="mx-2" htmlFor="r1">
          طبي
        </Label>
        <RadioGroupItem value="clinic" id="r1" />
      </div>
      <div className="flex items-center space-x-2">
        <Label className="mx-2" htmlFor="r2">
          رياضي
        </Label>
        <RadioGroupItem value="gym" id="r2" />
      </div>
    </RadioGroup>
  );
}
export function SelectSort({ setSortTime, sortTime }: SortProps) {
  return (
    <div className="flex-between-row my-2">
      <Label htmlFor="sortTime">{"الترتيب بالوقت"}</Label>
      <Select
        defaultValue={sortTime}
        onValueChange={(e) => setSortTime(e as "asc" | "desc")}
      >
        <SelectTrigger
          dir="rtl"
          className="w-[180px]"
          id="sortTime"
          defaultValue={sortTime}
        >
          <SelectValue defaultValue={sortTime} placeholder="الترتيب بالوقت" />
        </SelectTrigger>
        <SelectContent defaultValue={sortTime} dir="rtl">
          <SelectGroup>
            <SelectLabel>الترتيب بالوقت</SelectLabel>
            <SelectItem value="desc">الأحدث اولا</SelectItem>
            <SelectItem value="asc">الأقدم اولا</SelectItem>
          </SelectGroup>
        </SelectContent>
      </Select>
    </div>
  );
}
