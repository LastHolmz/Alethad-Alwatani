"use client";
import React, { useEffect } from "react";
import AccssibleDialogForm from "../../components/accible-dialog-form";
import {
  deleteBrandAction,
  deleteCategoryAction,
  newBrandAction,
  newCategoryAction,
  updateCategoryAction,
} from "../actions";
import SubmitButton from "../../components/custom-submit-btn";
import { Button } from "@/components/ui/button";
import { TbCategoryPlus } from "react-icons/tb";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { ImageDropzone } from "../../components/dropzone";
import { Trash2Icon } from "lucide-react";

import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useLocalStorage } from "@uidotdev/usehooks";
import { ScrollArea } from "@/components/ui/scroll-area";

export const NewCategoryForm = () => {
  return (
    <AccssibleDialogForm
      success="تم الإنشاء بنجاح"
      trigger={
        <Button className="mr-2">
          صنف جديد <TbCategoryPlus className="ml-2 h-4 w-4" />
        </Button>
      }
      dontReplace={true}
      stopClosing
      action={newCategoryAction}
    >
      <div className="grid gap-2 px-2 py-10">
        <ImageDropzone className="sm:w-full" name="image" title="صورة الصنف" />
        <div>
          <Label htmlFor="title">اسم الصنف</Label>
          <Input
            type="text"
            name="title"
            placeholder="ادخل اسم الصنف"
            required
          />
        </div>
        <div className="flex items-center justify-between w-full">
          <Label htmlFor="airplane-mode">رئيسي؟</Label>
          <Switch
            dir="ltr"
            defaultValue={"off"}
            name="main"
            id="airplane-mode"
          />
        </div>
      </div>
      <SubmitButton>حفظ</SubmitButton>
    </AccssibleDialogForm>
  );
};
export const UpdateCategoryForm = ({ category }: { category: Category }) => {
  return (
    <AccssibleDialogForm
      // sucess="تم الإنشاء بنجاح"
      trigger={
        <button className="flex justify-between items-center w-full">
          تعديل صنف <TbCategoryPlus className="h-4 w-4" />
        </button>
      }
      dontReplace
      action={updateCategoryAction}
    >
      <div className="grid gap-2 px-2 py-10">
        <ImageDropzone
          className="sm:w-full"
          name="image"
          title="صورة الصنف"
          defautlImage={category.image}
        />
        <div>
          <Label htmlFor="title">اسم الصنف</Label>
          <Input
            type="text"
            name="title"
            placeholder="ادخل اسم الصنف"
            required
            defaultValue={category.title}
          />
        </div>
        <div className="flex items-center justify-between w-full">
          <Label htmlFor="airplane-mode">رئيسي؟</Label>
          <Switch
            // checked={category.main}
            // onCheckedChange={(e) => {
            //   setMain(!e);
            // }}
            defaultChecked={category.main}
            dir="ltr"
            name="main"
            id="airplane-mode"
          />
        </div>
      </div>
      <Input type={"hidden"} name="id" value={category.id} />
      <SubmitButton>تحديث</SubmitButton>
    </AccssibleDialogForm>
  );
};
export const DeleteCategoryForm = ({ category }: { category: Category }) => {
  return (
    <AccssibleDialogForm
      trigger={
        <button className="flex justify-between items-center w-full">
          حذف صنف <Trash2Icon className="h-4 w-4" />
        </button>
      }
      action={deleteCategoryAction}
      title={`هل أنت متأكد من حذف ${category.title}`}
    >
      <Input type={"hidden"} name="id" value={category.id} />
      <SubmitButton>حذف</SubmitButton>
    </AccssibleDialogForm>
  );
};

export const NewBrandForm = ({ data }: { data: Category[] }) => {
  return (
    <AccssibleDialogForm
      success="تم الإنشاء بنجاح"
      trigger={
        <Button className="mr-2">
          براند جديد <TbCategoryPlus className="ml-2 h-4 w-4" />
        </Button>
      }
      dontReplace={true}
      stopClosing
      action={newBrandAction}
      title="براند جديد"
    >
      <div className="grid gap-2 px-2 py-10">
        <ImageDropzone
          className="sm:w-full"
          name="image"
          title="صورة البراند"
        />
        <div>
          <Label htmlFor="title">اسم البراند</Label>
          <Input
            type="text"
            name="title"
            placeholder="ادخل اسم البراند"
            required
          />
        </div>
        <CheckCategories data={data} />
      </div>
      <SubmitButton>حفظ</SubmitButton>
    </AccssibleDialogForm>
  );
};

export function CheckCategories({
  data,
  defalutCategories = [],
}: {
  data: Category[];
  defalutCategories?: string[];
}) {
  const [categories, setCategories] =
    React.useState<string[]>(defalutCategories);
  const checkCategory = (id: string): boolean => {
    if (categories.includes(id)) {
      return true;
    }
    return false;
  };
  const toggleCategory = (id: string) => {
    checkCategory(id) === true
      ? setCategories((prev) => prev.filter((p) => p !== id))
      : setCategories([...categories, id]);
  };
  useEffect(() => {
    console.log(categories);
  }, [categories]);

  return (
    <>
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="outline">الأصناف</Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent className="w-56">
          <DropdownMenuLabel>
            اختر الاصناف المرتطبة بالبراند الجديد
          </DropdownMenuLabel>
          <DropdownMenuSeparator />
          <ScrollArea dir="rtl" className="h-72 w-full rounded-md m-0 p-0 ">
            {data.map((c, i) => {
              return (
                <DropdownMenuCheckboxItem
                  key={i}
                  className="justify-start"
                  checked={checkCategory(c.id)}
                  onCheckedChange={() => toggleCategory(c.id)}
                >
                  {c.title}
                </DropdownMenuCheckboxItem>
              );
            })}
          </ScrollArea>
        </DropdownMenuContent>
      </DropdownMenu>
      <input type="hidden" name="ids" value={categories.toString()} />
    </>
  );
}

export const DeleteBrandForm = ({ brand }: { brand: Brand }) => {
  return (
    <AccssibleDialogForm
      trigger={
        <Button
          variant={"outline"}
          className="flex justify-between items-center w-full"
        >
          حذف براند <Trash2Icon className="h-4 w-4" />
        </Button>
      }
      stopClosing={false}
      action={deleteBrandAction}
      title={`هل أنت متأكد من حذف ${brand.title}`}
    >
      <Input type={"hidden"} name="id" value={brand.id} />
      <SubmitButton>حذف</SubmitButton>
    </AccssibleDialogForm>
  );
};

export const UpdateBrandForm = ({ brand }: { brand: Brand }) => {
  const [categories, _] = useLocalStorage<Category[]>("categories", []);
  return (
    <AccssibleDialogForm
      success="تم الإنشاء بنجاح"
      trigger={
        <Button
          variant={"outline"}
          className="flex justify-between items-center w-full"
        >
          تحديث البراند <TbCategoryPlus className="ml-2 h-4 w-4" />
        </Button>
      }
      dontReplace={true}
      stopClosing
      action={newBrandAction}
      title="تحديث البراند"
    >
      <div className="grid gap-2 px-2 py-10">
        <ImageDropzone
          className="sm:w-full"
          name="image"
          defautlImage={brand.image}
          title="صورة البراند"
        />
        <div>
          <Label htmlFor="title">اسم البراند</Label>
          <Input
            type="text"
            name="title"
            placeholder="ادخل اسم البراند"
            required
            defaultValue={brand.title}
          />
        </div>
        <CheckCategories
          defalutCategories={brand.categoryIDs}
          data={categories}
        />
      </div>
      <SubmitButton>حفظ</SubmitButton>
    </AccssibleDialogForm>
  );
};
