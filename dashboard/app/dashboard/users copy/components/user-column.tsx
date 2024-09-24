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
import { CiUser } from "react-icons/ci";
import ReusableRow from "../../components/reusable-row";
import { UpdateUserStatusForm } from "./forms";
import Link from "next/link";
import { MdOutlineAdminPanelSettings } from "react-icons/md";

export const usersColumn: ColumnDef<User>[] = [
  {
    accessorKey: "اسم المستخدم",
    header: "اسم المستخدم",
    cell: ({ row }) => {
      const fullName = row.original.fullName;
      if (!fullName) {
        return <NotFoundTable />;
      }
      return (
        <ReusableRow row={row}>
          <div>{fullName}</div>{" "}
        </ReusableRow>
      );
    },
  },
  {
    accessorKey: "الجنس",
    header: "الجنس",
    cell: ({ row }) => {
      const gender = row.original.gender;
      return (
        <ReusableRow row={row}>
          <div>{gender}</div>
        </ReusableRow>
      );
    },
  },
  {
    accessorKey: "اسم الشركة",
    header: "اسم الشركة",
    cell: ({ row }) => {
      const companyTitle = row.original.companyTitle;
      return <ReusableRow row={row}>{companyTitle}</ReusableRow>;
    },
  },

  {
    accessorKey: "رقم الهاتف",
    header: "رقم الهاتف",
    cell: ({ row }) => {
      const mobile = row.original.mobile;
      return <ReusableRow row={row}>{mobile}</ReusableRow>;
    },
  },
  {
    accessorKey: "رقم الشركة",
    header: "رقم الشركة",
    cell: ({ row }) => {
      const mobile = row.original.componeyMobile;
      return <ReusableRow row={row}>{mobile}</ReusableRow>;
    },
  },
  {
    accessorKey: "الرتبة",
    header: "الرتبة",
    cell: ({ row }) => {
      const role = row.original.role;
      return (
        <ReusableRow row={row}>
          <UserRoleCard role={role} />
        </ReusableRow>
      );
    },
  },
  {
    accessorKey: "الحالة",
    header: "الحالة",
    cell: ({ row }) => {
      const status = row.original.status;
      return (
        <ReusableRow row={row}>
          <UserStatusCard status={status} />
        </ReusableRow>
      );
    },
  },

  {
    id: "actions",
    header: "الأحداث",
    enableHiding: false,
    cell: ({ row }) => {
      const user = row.original;
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
                navigator.clipboard.writeText(String(user.mobile));
                toast({
                  className: "bg-primary text-white",
                  description: "تم نسخ رقم الهاتف بنجاح",
                });
              }}
            >
              نسح رقم الهاتف
            </DropdownMenuItem>

            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <UpdateUserStatusForm user={user} />
            </DropdownMenuItem>
            <DropdownMenuSeparator />
          </DropdownMenuContent>
        </DropdownMenu>
      );
    },
  },
];

const UserRoleCard = ({ role }: { role: UserRole }) => {
  if (role === "admin") {
    return (
      <div className=" rounded flex gap-1 justify-center items-center px-2 py-0.5 text-white bg-sky-400">
        <span>مشرف</span>
        <MdOutlineAdminPanelSettings />
      </div>
    );
  }
  return (
    <div className=" rounded gap-2 flex justify-center items-center px-2 py-0.5 text-white bg-yellow-400">
      <span>مستخدم</span>
      <CiUser />
    </div>
  );
};
const UserStatusCard = ({ status }: { status: UserStatus }) => {
  switch (status) {
    case "pending":
      return (
        <div className=" rounded flex gap-1 justify-center items-center px-2 py-0.5 text-white bg-orange-400">
          <span>معلق</span>
        </div>
      );
    case "active":
      return (
        <div className=" rounded flex gap-1 justify-center items-center px-2 py-0.5 text-white bg-green-400">
          <span>مفعل</span>
        </div>
      );
    case "inactive":
      return (
        <div className=" rounded flex gap-1 justify-center items-center px-2 py-0.5 text-white bg-red-400">
          <span>معطل</span>
        </div>
      );
    default:
      return (
        <div className=" rounded flex gap-1 justify-center items-center px-2 py-0.5 text-white bg-red-400">
          <span>معطل</span>
        </div>
      );
  }
};
