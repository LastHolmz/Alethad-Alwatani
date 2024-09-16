"use client";
import * as React from "react";
import { ColumnDef } from "@tanstack/react-table";
import { MoreHorizontal } from "lucide-react";

import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { toast } from "@/components/ui/use-toast";
import NotFoundTable from "../../components/not-found-table";
import Image from "next/image";
import ReusableRow from "../../components/reusable-row";
import { DeleteProductForm, UpdateProductForm } from "./forms";
import { CustomLink } from "@/components/ui/custom-link";
import Link from "next/link";

export const productColumn: ColumnDef<Product>[] = [
  {
    accessorKey: "صورة المنتج",
    header: "صورة المنتج",
    cell: ({ row }) => {
      const image = row.original.image;
      if (!image) {
        return <NotFoundTable />;
      }
      return (
        <ReusableRow row={row}>
          <div className="overflow-hidden rounded-md h-12 w-12 aspect-square">
            <Image
              src={image}
              alt={row.original.title}
              width={100}
              height={100}
              className=" w-full h-full object-cover"
            />
          </div>
        </ReusableRow>
      );
    },
  },
  {
    accessorKey: "اسم المنتج",
    header: "اسم المنتج",
    cell: ({ row }) => {
      if (row) {
        const title = row.original?.title;
        return <div>{title}</div>;
      } else {
        <div>لايوجد</div>;
      }
    },
  },
  {
    accessorKey: "باركود",
    header: "باركود",
    cell: ({ row }) => {
      if (row) {
        const barcode = row.original?.barcode;
        return <div>{barcode}</div>;
      } else {
        <div>لايوجد</div>;
      }
    },
  },

  {
    accessorKey: "السعر الأصلي",
    header: "السعر الأصلي",
    cell: ({ row }) => {
      if (row) {
        const price = row.original?.originalPrice;
        return <div>{price}</div>;
      } else {
        <div>لايوجد</div>;
      }
    },
  },
  {
    accessorKey: "السعر",
    header: "السعر",
    cell: ({ row }) => {
      if (row) {
        const price = row.original?.price;
        return <div>{price}</div>;
      } else {
        <div>لايوجد</div>;
      }
    },
  },

  {
    id: "actions",
    header: "الأحداث",
    enableHiding: false,
    cell: ({ row }) => {
      const product = row.original;
      return (
        <DropdownMenu dir="rtl">
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="h-8 w-8 p-0">
              <span className="sr-only">افتح الأحداث</span>
              <MoreHorizontal className="h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>الأحداث</DropdownMenuLabel>
            <DropdownMenuItem
              onClick={() => {
                navigator.clipboard.writeText(String(product.barcode));
                toast({
                  className: "bg-primary text-white",
                  description: "تم نسخ الباركود بنجاح",
                });
              }}
            >
              نسح الباركود
            </DropdownMenuItem>
            <DropdownMenuItem>
              <Link
                // variant={"ghost"}
                className="w-full justify-around"
                // size={"sm"}
                href={`/dashboard/products/${product.id}/update`}
              >
                تحديث
              </Link>
            </DropdownMenuItem>
            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <DeleteProductForm product={product} />
            </DropdownMenuItem>
            <DropdownMenuSeparator />
          </DropdownMenuContent>
        </DropdownMenu>
      );
    },
  },
];
