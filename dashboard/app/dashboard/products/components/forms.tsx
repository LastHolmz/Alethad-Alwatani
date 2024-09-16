"use client";

import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useEffect, useState } from "react";
import Form from "@/app/dashboard/components/form";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import SubmitButton from "@/app/dashboard/components/custom-submit-btn";
import { ImageDropzone } from "../../components/dropzone";
import { newProductAction } from "../new/actions";
import { ScrollArea } from "@/components/ui/scroll-area";

export const CheckCategories = ({
  data,
  defalutCategories = [],
}: {
  data: Category[];
  defalutCategories?: string[];
}) => {
  const [categories, setCategories] = useState<string[]>(defalutCategories);
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
          <Button
            className="text-right justify-start opacity-70 shadow"
            variant="secondary"
            id="categories"
          >
            الأصناف
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent id="categories" className="w-56">
          <DropdownMenuLabel>
            اختر الاصناف المرتطبة بالمنتج الجديد
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
      <input type="hidden" name="categoryIDs" value={categories.toString()} />
    </>
  );
};

export const CheckBrands = ({
  data,
  defalutBrands = [],
}: {
  data: Brand[];
  defalutBrands?: string[];
}) => {
  const [brands, setBrands] = useState<string[]>(defalutBrands);
  const checkBrand = (id: string): boolean => {
    if (brands.includes(id)) {
      return true;
    }
    return false;
  };
  const toggleBrand = (id: string) => {
    checkBrand(id) === true
      ? setBrands((prev) => prev.filter((p) => p !== id))
      : setBrands([...brands, id]);
  };
  useEffect(() => {
    console.log(brands);
  }, [brands]);

  return (
    <>
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button
            className="text-right justify-start opacity-70 shadow"
            variant="secondary"
            id="brands"
          >
            البراندات
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent id="brands" className="w-56">
          <DropdownMenuLabel>
            اختر البراندات الخاصة بالمنتج الجديد
          </DropdownMenuLabel>
          <DropdownMenuSeparator />
          <ScrollArea dir="rtl" className="h-72 w-full rounded-md m-0 p-0 ">
            {data.map((c, i) => {
              return (
                <DropdownMenuCheckboxItem
                  key={i}
                  className="justify-start"
                  checked={checkBrand(c.id)}
                  onCheckedChange={() => toggleBrand(c.id)}
                >
                  {c.title}
                </DropdownMenuCheckboxItem>
              );
            })}
          </ScrollArea>
        </DropdownMenuContent>
      </DropdownMenu>
      <input type="hidden" name="brandIDs" value={brands.toString()} />
    </>
  );
};

export const CreatOrderForm = ({
  brands,
  categories,
}: {
  brands: Brand[];
  categories: Category[];
}) => {
  return (
    <Form
      action={newProductAction}
      sucess="تمت العملية بنجاح"
      replaceLink="/dashboard/offers"
      className="mt-4 mb-2"
    >
      <div className="grid gap-1 sm:gap-3 sm:grid-cols-2">
        <div>
          <Label htmlFor="title">اسم المنتج</Label>
          <Input
            id="title"
            required
            type={"text"}
            name="title"
            placeholder="ادخل اسم المنتج"
          />
        </div>
        <div>
          <Label htmlFor="price">السعر</Label>
          <Input
            id="price"
            required
            type={"number"}
            name="price"
            placeholder="ادخل سعر المنتج"
          />
        </div>
        <div>
          <Label htmlFor="barcode">الباركود</Label>
          <Input
            id="barcode"
            required
            type={"text"}
            name="barcode"
            placeholder="ادخل باركود المنتج"
          />
        </div>
        <div>
          <Label htmlFor="originalPrice">السعر الأصلي</Label>
          <Input
            id="originalPrice"
            required
            type={"number"}
            name="originalPrice"
            placeholder="ادخل سعر المنتج الأصلي"
          />
        </div>
        <div>
          <Label htmlFor="description">الوصف</Label>
          <Input
            id="description"
            required
            type={"text"}
            name="description"
            placeholder="ادخل وصف المنتج"
          />
        </div>
        <div className="grid gap-2">
          <Label htmlFor="categories">اختيار الأصناف</Label>
          <CheckCategories data={categories} />
        </div>
        <div className="grid gap-2">
          <Label htmlFor="brands">اختيار البراندات</Label>
          <CheckBrands data={brands} />
        </div>

        {/* نوع المنتج
        <div>
          <Label htmlFor="type">نوع المنتج</Label>
          <Select dir="rtl" name="type" defaultValue="main">
            <SelectTrigger id="type" className="">
              <SelectValue placeholder="اختر نوع المنتج" />
            </SelectTrigger>
            <SelectContent>
              <SelectGroup>
                <SelectLabel>الأنواع</SelectLabel>
                <SelectItem value="main">أساسية</SelectItem>
                <SelectItem value="offer">عرض محدود</SelectItem>
              </SelectGroup>
            </SelectContent>
          </Select>
        </div> */}
        {/* توصية
        <div>
          <Label htmlFor="recommended">توصية</Label>
          <Select dir="rtl" name="recommended" defaultValue="false">
            <SelectTrigger id="recommended" className="">
              <SelectValue placeholder="توصية" />
            </SelectTrigger>
            <SelectContent>
              <SelectGroup>
                <SelectLabel>هل تريد توصيته للمستخدمين</SelectLabel>
                <SelectItem value="true">نعم</SelectItem>
                <SelectItem value="false">لا</SelectItem>
              </SelectGroup>
            </SelectContent>
          </Select>
        </div> */}

        {/* features
        <div>
          <div>
            <Label htmlFor="features">مميزات المنتج</Label>
            <Input
              ref={inputRef}
              id="features"
              type={"text"}
              placeholder="ادخل مميزات المنتج"
              value={feature}
              onChange={(e) => setFeature(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  addFeature(feature);
                  e.preventDefault();
                }
              }}
            />
          </div>
          <div className="flex min-h-20 my-2 justify-start bg-background border rounded-lg px-4 py-2 items-center flex-wrap">
            {features?.map((feature, index) => (
              <Feature
                removeFeature={removeFeature}
                value={feature}
                key={index}
              />
            ))}
          </div>
        </div> */}
      </div>
      <div>
        <ImageDropzone name="image" title="صورة المنتج"></ImageDropzone>
      </div>
      <SubmitButton className="w-full sm:w-1/4 mt-2" type={"submit"}>
        حفظ
      </SubmitButton>
    </Form>
  );
};
