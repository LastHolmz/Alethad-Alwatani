"use client";
import * as React from "react";
import { ColumnDef } from "@tanstack/react-table";
import Image from "next/image";
import ReusableRow from "../../components/reusable-row";
import { cn } from "@/lib/utils";

export const cartColumn: ColumnDef<OrderItem>[] = [
  {
    accessorKey: "صورة المنتج",
    header: "صورة المنتج",
    cell: ({ row }) => {
      return (
        <ReusableRow row={row}>
          <div className="overflow-hidden rounded-md h-12 w-12 aspect-square">
            <Image
              src={row.original?.skuImage ?? row.original.image}
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
      const title = row.original.title;
      return (
        <ReusableRow row={row}>
          <div>{title}</div>
        </ReusableRow>
      );
    },
  },
  {
    accessorKey: "باركود",
    header: "باركود",
    cell: ({ row }) => {
      const barcode = row.original.barcode;
      return (
        <ReusableRow row={row}>
          <div>{barcode}</div>
        </ReusableRow>
      );
    },
  },

  {
    accessorKey: "السعر",
    header: "السعر",
    cell: ({ row }) => {
      const price = row.original.price;
      return (
        <ReusableRow row={row}>
          <div>{price}</div>
        </ReusableRow>
      );
    },
  },
  {
    accessorKey: "الكمية",
    header: "الكمية",
    cell: ({ row }) => {
      const qty = row.original.qty;
      return (
        <ReusableRow row={row}>
          <div>{qty}</div>
        </ReusableRow>
      );
    },
  },
  {
    accessorKey: "اللون",
    header: "اللون",
    cell: ({ row }) => {
      const nameOfColor = row.original?.nameOfColor;
      const hashedColor = row.original?.hashedColor;
      return (
        <ReusableRow row={row}>
          <div className="flex justify-center items-center gap-2">
            <div>{nameOfColor ? nameOfColor : "بلا"}</div>
            <div
              style={{
                backgroundColor: hashedColor,
              }}
              className={cn("w-10 h-10 rounded-full")}
            ></div>
          </div>
        </ReusableRow>
      );
    },
  },
];
