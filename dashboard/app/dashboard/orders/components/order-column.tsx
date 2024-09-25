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
import ReusableRow from "../../components/reusable-row";
// import { UpdateUserStatusForm } from "./forms";
import { cn, orderStatusToArabic } from "@/lib/utils";
import Link from "next/link";
import {
  AcceptOrderForm,
  RejectOrderForm,
  ReturnOrderForm,
  UpdateOrderMoenyForm,
} from "./forms";
import { IoIosInformationCircleOutline } from "react-icons/io";
import { FaPrint, FaRegCopy } from "react-icons/fa6";
import ExportButton from "./extract-as-exel";
import { CustomLink } from "@/components/ui/custom-link";

export const orderColumn: ColumnDef<Order>[] = [
  {
    accessorKey: "الباركود",
    header: "الباركود",
    cell: ({ row }) => {
      const barcode = row.original.barcode;

      return (
        <ReusableRow row={row}>
          <div>{barcode}</div>{" "}
        </ReusableRow>
      );
    },
  },

  {
    accessorKey: "رقم الهاتف",
    header: "رقم الهاتف",
    cell: ({ row }) => {
      const mobile = row.original?.user.mobile;
      return <ReusableRow row={row}>{mobile ?? "لا يوجد"}</ReusableRow>;
    },
  },
  {
    accessorKey: "السعر الكلي",
    header: "السعر الكلي",
    cell: ({ row }) => {
      const totalPrice = row.original.totalPrice;
      return <ReusableRow row={row}>{totalPrice} د</ReusableRow>;
    },
  },

  {
    accessorKey: "المتبقي",
    header: "المتبقي",
    cell: ({ row }) => {
      const rest = row.original.rest;
      return <ReusableRow row={row}>{rest} د</ReusableRow>;
    },
  },

  {
    accessorKey: "الحالة",
    header: "الحالة",
    cell: ({ row }) => {
      const status = row.original.status;
      return (
        <ReusableRow row={row}>
          <OrderStatusCard status={status} />
        </ReusableRow>
      );
    },
  },

  {
    id: "actions",
    header: "الأحداث",
    enableHiding: false,
    cell: ({ row }) => {
      const order = row.original;
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
              className="flex justify-between items-center w-full"
              onClick={() => {
                navigator.clipboard.writeText(String(order.barcode));
                toast({
                  className: "bg-primary text-white",
                  description: "تم نسخ الباركود بنجاح",
                });
              }}
            >
              نسح الباركود
              <FaRegCopy />
            </DropdownMenuItem>

            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <Link
                className="flex justify-between items-center w-full"
                href={`/dashboard/orders/${order.id}`}
              >
                معلومات
                <IoIosInformationCircleOutline />
              </Link>
            </DropdownMenuItem>
            <DropdownMenuSeparator />

            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <AcceptOrderForm order={order} table />
            </DropdownMenuItem>
            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <ReturnOrderForm order={order} table />
            </DropdownMenuItem>
            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <RejectOrderForm order={order} table />{" "}
            </DropdownMenuItem>

            <DropdownMenuSeparator />
            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <UpdateOrderMoenyForm table order={order} />
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <Link
                className="flex justify-between items-center w-full"
                href={`/dashboard/orders/${order.id}/print`}
              >
                طباعة
                <FaPrint className=" text-blue-500" />
              </Link>
            </DropdownMenuItem>

            <DropdownMenuItem>
              <ExportButton table order={order} user={order.user} />
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      );
    },
  },
];

const statusBgColors: Record<OrderStatus, string> = {
  pending: "bg-orange-300", // orange background for pending
  inProgress: "bg-blue-300", // Blue background for inProgress
  done: "bg-green-300", // Green background for done
  rejected: "bg-red-300", // Red background for rejected
  refused: "bg-gray-300", // Gray background for refused
};
const statusTextColors: Record<OrderStatus, string> = {
  pending: "text-orange-700", // orange background for pending
  inProgress: "text-blue-700", // Blue background for inProgress
  done: "text-green-700", // Green background for done
  rejected: "text-red-700", // Red background for rejected
  refused: "text-gray-700", // Gray background for refused
};

export const OrderStatusCard: React.FC<{
  status: OrderStatus;
  className?: string;
}> = ({ status, className }) => {
  // Get the Tailwind class based on the status
  const backgroundColorClass = statusBgColors[status];
  const TextColorClass = statusTextColors[status];

  return (
    <div
      className={cn(
        "px-2 py-0.5 rounded text-center w-fit",
        backgroundColorClass,
        TextColorClass,
        className
      )}
    >
      {orderStatusToArabic(status)}
    </div>
  );
};
