"use client";

import * as XLSX from "xlsx";
import { saveAs } from "file-saver";
import { Button } from "@/components/ui/button";
import { BsFiletypeExe } from "react-icons/bs";

export const exportUserOrdersToExcel = (
  user: User,
  order: Order,
  fileName: string
) => {
  const userData = {
    "اخر تعديل": new Date(user.updatedAt).toISOString(),
    "تاريخ الإنشاء": new Date(user.createdAt).toISOString(),
    "موقع الشركة": user.location || "N/A",
    "رقم هاتف الشركة": user.componeyMobile,
    "اسم الشركة": user.companyTitle,
    الحالة: user.status,
    الجنس: user.gender,
    الوظيفة: user.role,
    "رقم الهاتف": user.mobile,
    "الاسم الثلاثي": user.fullName,
  };

  const orderDate = {
    "اخر تعديل": new Date(user.updatedAt).toISOString(),
    "تاريخ الإنشاء": new Date(user.createdAt).toISOString(),
    "User ID": user.id,
    المتبقي: order.rest,
    "السعر الكلي": order.totalPrice,
    // "Order Status": order.status,
    الباركود: order.barcode,
  };

  const orderItemsData = order.orderItems.map((item) => ({
    "اسم اللون": item.nameOfColor || "N/A",
    الإجمالي: item.qty * item.price,
    الكمية: item.qty,
    السعر: item.price,
    الباركود: order.barcode,
    "اسم المنتج": item.title,
  }));

  const workbook = XLSX.utils.book_new();
  const userSheet = XLSX.utils.json_to_sheet([userData]);
  const ordersSheet = XLSX.utils.json_to_sheet([orderDate]);
  const orderItemsSheet = XLSX.utils.json_to_sheet(orderItemsData);

  XLSX.utils.book_append_sheet(workbook, userSheet, "التاجر");
  XLSX.utils.book_append_sheet(workbook, ordersSheet, "الفاتورة");
  XLSX.utils.book_append_sheet(workbook, orderItemsSheet, "المنتجات");

  const excelBuffer = XLSX.write(workbook, { bookType: "xlsx", type: "array" });
  const blob = new Blob([excelBuffer], { type: "application/octet-stream" });
  saveAs(blob, `${fileName}.xlsx`);
};

const ExportButton = ({
  user,
  order,
  table = false,
}: {
  user: User;
  order: Order;
  table?: boolean;
}) => {
  // Example data

  const handleExport = () => {
    exportUserOrdersToExcel(user, order, `فاتورة ${order.barcode}`);
  };

  return table ? (
    <button
      onClick={handleExport}
      className="flex justify-between items-center w-full"
    >
      تحميل
      <BsFiletypeExe className="mr-2 w-4 h-4" />
    </button>
  ) : (
    <Button variant={"outline"} onClick={handleExport} className="mx-1">
      تحميل
      <BsFiletypeExe className="mr-2 w-4 h-4" />
    </Button>
  );
};

export default ExportButton;
