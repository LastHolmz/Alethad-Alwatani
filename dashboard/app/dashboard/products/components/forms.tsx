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
import {
  ControlledImageDropzone,
  ImageDropzone,
} from "../../components/dropzone";
import { newProductAction } from "../new/actions";
import { ScrollArea } from "@/components/ui/scroll-area";
import { ResponsiveDialogWithCustomOpenFuncionality } from "../../components/responsive-dialog";
import { PlusCircle, Trash2Icon } from "lucide-react";
import { convertToHex } from "@/lib/utils";
import { Separator } from "@/components/ui/separator";
import {
  HoverCard,
  HoverCardContent,
  HoverCardTrigger,
} from "@/components/ui/hover-card";
import { Pencil1Icon } from "@radix-ui/react-icons";

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
        <Colors />
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

export const Colors = ({
  defaultSkus = [],
}: {
  defaultSkus?: Omit<ColorDetails, "id" | "productId">[];
}) => {
  const [skus, setSkus] =
    useState<Omit<ColorDetails, "id" | "productId">[]>(defaultSkus);
  const [poster, setPoster] = useState("");
  const [currentColor, setCurrentColor] = useState<
    Omit<ColorDetails, "id" | "productId">
  >({
    hashedColor: "#ff5733",
    nameOfColor: "",
    qty: 0,
    image: poster,
  });
  const [hexColor, setHexColor] = useState<string>("#ff5733");
  const [newOpen, setNewOpen] = useState<boolean>(false);
  const [updateOpen, setUpdateOpen] = useState<boolean>(false);
  const [deleteOpen, setDeleteOpen] = useState<boolean>(false);
  const handleColorChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const colorValue = e.target.value;
    const convertedHex = convertToHex(colorValue);
    if (convertedHex) {
      setHexColor(convertedHex);
      setCurrentColor((prev) => ({ ...prev, hashedColor: convertedHex }));
    } else {
      console.error("Invalid color format");
    }
  };

  const handleNameChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setCurrentColor((prev) => ({ ...prev, nameOfColor: e.target.value }));
  };

  const handleQtyChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setCurrentColor((prev) => ({ ...prev, qty: Number(e.target.value) }));
  };
  const handleImageChange = (val: string) => {
    console.log(val);
    setCurrentColor((prev) => ({ ...prev, image: val }));
  };

  const toggleSkus = () => {
    const existingSkuIndex = skus.findIndex(
      (sku) =>
        sku.hashedColor === currentColor.hashedColor &&
        sku.nameOfColor === currentColor.nameOfColor
    );

    if (existingSkuIndex > -1) {
      setSkus((prev) => prev.filter((_, index) => index !== existingSkuIndex));
    } else {
      setSkus((prev) => [...prev, currentColor]);
    }
    setNewOpen(!newOpen);
  };
  const updateSku = (
    oldSku: Omit<ColorDetails, "id" | "productId">,
    newSku: Omit<ColorDetails, "id" | "productId">
  ): void => {
    setSkus((prev) =>
      prev.map((item) =>
        item.hashedColor === oldSku.hashedColor &&
        item.nameOfColor === oldSku.nameOfColor
          ? { ...item, ...newSku }
          : item
      )
    );
    setUpdateOpen(!updateOpen);
  };

  const deleteSku = (
    skuToDelete: Omit<ColorDetails, "id" | "productId">
  ): void => {
    setSkus((prev) =>
      prev.filter(
        (sku) =>
          !(
            sku.hashedColor === skuToDelete.hashedColor &&
            sku.nameOfColor === skuToDelete.nameOfColor
          )
      )
    );
    setDeleteOpen(!deleteOpen);
  };

  useEffect(() => {
    handleImageChange(poster);
    console.log(skus);
  }, [poster, skus]);

  return (
    <div className="my-2">
      <div className="flex justify-between items-center my-2">
        <Label htmlFor="color">الألوان و الكميات</Label>
        <ResponsiveDialogWithCustomOpenFuncionality
          open={newOpen}
          setOpen={setNewOpen}
          trigger={
            <Button type="button" size={"icon"}>
              <PlusCircle />
            </Button>
          }
          title="إضافة لون جديد مع كميته"
        >
          <div className="grid gap-1 sm:gap-3">
            <div className="grid grid-cols-2 gap-2">
              <div>
                <Label htmlFor="nameOfColor">اسم اللون</Label>
                <Input
                  id="nameOfColor"
                  required
                  type="text"
                  name="nameOfColor"
                  placeholder="ادخل اسم اللون"
                  value={currentColor.nameOfColor}
                  onChange={handleNameChange}
                />
              </div>
              <div>
                <Label htmlFor="hashedColor">اختيار اللون</Label>
                <Input
                  id="hashedColor"
                  required
                  type="color"
                  name="hashedColor"
                  value={hexColor}
                  onChange={handleColorChange}
                  placeholder="اختر اللون"
                />
              </div>
            </div>
            <Separator />
            <div>
              <Label htmlFor="qty">الكمية</Label>
              <Input
                id="qty"
                required
                type="number"
                name="qty"
                placeholder="ادخل الكمية"
                value={currentColor.qty}
                onChange={handleQtyChange}
              />
            </div>
            <div>
              <ControlledImageDropzone
                setPoster={setPoster}
                poster={poster}
                name="image"
                className="sm:w-full"
                title="صورة المنتج باللون المعين"
              />
            </div>
            <Button onClick={toggleSkus} type="button">
              إضافة
            </Button>
          </div>
        </ResponsiveDialogWithCustomOpenFuncionality>
      </div>
      <div
        id="color"
        className="w-full min-h-[200px] rounded border px-2 flex justify-start items-center flex-wrap gap-1"
      >
        {skus.map((sku, i) => (
          <HoverCard key={i}>
            <HoverCardTrigger>
              {" "}
              <div className="flex transition-all flex-col items-center shadow px-4 py-1 rounded-md hover:bg-secondary cursor-pointer hover:shadow-md">
                <div
                  className="rounded-full w-10 h-10"
                  style={{
                    backgroundColor: sku.hashedColor,
                  }}
                ></div>
                <span>{sku.nameOfColor}</span>
                <span>{sku.qty}</span>
              </div>
            </HoverCardTrigger>
            <HoverCardContent className=" flex w-fit gap-1 items-center px-2 py-1 rounded-md">
              <ResponsiveDialogWithCustomOpenFuncionality
                open={updateOpen}
                setOpen={setUpdateOpen}
                trigger={
                  <Button
                    variant={"secondary"}
                    onClick={() => {
                      // Set current color and update hexColor
                      setPoster(sku.image ?? poster);
                      setCurrentColor({
                        hashedColor: sku.hashedColor,
                        nameOfColor: sku.nameOfColor,
                        qty: sku.qty,
                        image: sku.image,
                      });
                      setHexColor(sku.hashedColor ?? "");
                    }}
                    type="button"
                    size={"icon"}
                  >
                    <Pencil1Icon />
                  </Button>
                }
                title={`تعديل اللون: ${sku?.nameOfColor}`}
              >
                <div className="grid gap-1 sm:gap-3">
                  <div className="grid grid-cols-2 gap-2">
                    <div>
                      <Label htmlFor="nameOfColor">اسم اللون</Label>
                      <Input
                        id="nameOfColor"
                        required
                        type="text"
                        name="nameOfColor"
                        placeholder="ادخل اسم اللون"
                        value={currentColor.nameOfColor}
                        onChange={handleNameChange}
                      />
                    </div>
                    <div>
                      <Label htmlFor="hashedColor">اختيار اللون</Label>
                      <Input
                        id="hashedColor"
                        required
                        type="color"
                        name="hashedColor"
                        value={hexColor}
                        onChange={handleColorChange}
                        placeholder="اختر اللون"
                      />
                    </div>
                  </div>
                  <Separator />
                  <div>
                    <Label htmlFor="qty">الكمية</Label>
                    <Input
                      id="qty"
                      required
                      type="number"
                      name="qty"
                      placeholder="ادخل الكمية"
                      value={currentColor.qty}
                      onChange={handleQtyChange}
                    />
                  </div>
                  <div>
                    <ControlledImageDropzone
                      setPoster={setPoster}
                      poster={poster}
                      name="image"
                      className="sm:w-full"
                      title="صورة المنتج باللون المعين"
                    />
                  </div>
                  <Button
                    onClick={() => {
                      updateSku(sku, currentColor);
                    }}
                    type="button"
                  >
                    تحديث{" "}
                  </Button>
                </div>
              </ResponsiveDialogWithCustomOpenFuncionality>
              <ResponsiveDialogWithCustomOpenFuncionality
                open={deleteOpen}
                setOpen={setDeleteOpen}
                trigger={
                  <Button variant={"secondary"} type="button" size={"icon"}>
                    <Trash2Icon className="w-4 h-4" />
                  </Button>
                }
                title={`حذف اللون: ${sku?.nameOfColor}`}
              >
                <Button
                  onClick={() => {
                    deleteSku(sku);
                  }}
                  type={"button"}
                >
                  حذف
                </Button>
              </ResponsiveDialogWithCustomOpenFuncionality>
            </HoverCardContent>
          </HoverCard>
        ))}
      </div>
      <Input type="hidden" name="skus" value={JSON.stringify(skus)} />
    </div>
  );
};
