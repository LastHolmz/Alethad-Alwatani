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
import { cn } from "@/lib/utils";
import Image from "next/image";
import NotFoundTable from "../../components/not-found-table";
import ReusableRow from "../../components/reusable-row";
import {
  DeleteBrandForm,
  DeleteCategoryForm,
  UpdateBrandForm,
  UpdateCategoryForm,
} from "./forms";
// import BrandsSheet from "./brands-sheet";

const brandColumn: ColumnDef<Brand>[] = [
  {
    accessorKey: "صورة البراند",
    header: "صورة البراند",
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
    accessorKey: "اسم البراند",
    header: "اسم البراند",
    cell: ({ row }) => {
      const title = row.original.title;
      return (
        <ReusableRow row={row}>
          <div>{title}</div>
        </ReusableRow>
      );
    },
  },
  // {
  //   accessorKey: "رئيسي؟",
  //   header: "رئيسي؟",
  //   cell: ({ row }) => {
  //     const main = row.original.main;
  //     return (
  //       <ReusableRow row={row}>
  //         <div
  //           className={cn(
  //             "rounded px-2 py-0.5  text-center mx-right w-10",
  //             main ? "text-blue-700 bg-blue-200" : "text-red-700 bg-red-200"
  //           )}
  //         >
  //           {main ? "نعم" : "لا"}
  //         </div>
  //       </ReusableRow>
  //     );
  //   },
  // },

  {
    id: "actions",
    header: "الأحداث",
    enableHiding: false,
    cell: ({ row }) => {
      const brand = row.original;
      return (
        <DropdownMenu dir="rtl">
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="h-8 w-8 p-0 text-left">
              <span className="sr-only">افتح الأحداث</span>
              <MoreHorizontal className="h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>الأحداث</DropdownMenuLabel>
            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <DeleteBrandForm brand={brand} />{" "}
            </DropdownMenuItem>
            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <UpdateBrandForm brand={brand} />
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      );
    },
  },
];
// const brandColumn: ColumnDef<Brand>[] = [
//   {
//     accessorKey: "صورة البراند",
//     header: "صورة البراند",
//     cell: ({ row }) => {
//       const image = row.original.image;
//       if (!image) {
//         return <NotFoundTable />;
//       }
//       return (
//         <ReusableRow row={row}>
//           <div className="overflow-hidden rounded-md h-12 w-12 aspect-square">
//             <Image
//               src={image}
//               alt={row.original.title}
//               width={100}
//               height={100}
//               className=" w-full h-full object-cover"
//             />
//           </div>
//         </ReusableRow>
//       );
//     },
//   },

//   {
//     accessorKey: "اسم البراند",
//     header: "اسم البراند",
//     cell: ({ row }) => {
//       const title = row.original.title;
//       return (
//         <ReusableRow row={row}>
//           <div>{title}</div>
//         </ReusableRow>
//       );
//     },
//   },

//   {
//     id: "actions",
//     header: "الأحداث",
//     enableHiding: false,
//     cell: ({ row }) => {
//       const categroy = row.original;
//       return (
//         <DropdownMenu dir="rtl">
//           <DropdownMenuTrigger asChild>
//             <Button variant="ghost" className="h-8 w-8 p-0 text-left">
//               <span className="sr-only">افتح الأحداث</span>
//               <MoreHorizontal className="h-4 w-4" />
//             </Button>
//           </DropdownMenuTrigger>
//           <DropdownMenuContent align="end">
//             <DropdownMenuLabel>الأحداث</DropdownMenuLabel>
//             {/* <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
//               <UpdateCategoryForm category={categroy} />
//             </DropdownMenuItem>
//             <DropdownMenuSeparator />
//             <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
//               <DeleteCategoryForm category={categroy} />
//             </DropdownMenuItem> */}
//           </DropdownMenuContent>
//         </DropdownMenu>
//       );
//     },
//   },
// ];

export default brandColumn;
