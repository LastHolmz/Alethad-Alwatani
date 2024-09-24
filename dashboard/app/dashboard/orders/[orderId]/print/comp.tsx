"use client";
import { useRef, useState } from "react";
import { PrintBill } from "../../components/print-order";
import { useReactToPrint } from "react-to-print";
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { FaPrint } from "react-icons/fa";
import DashboardHeader from "@/app/dashboard/components/dashboard-header";
import { CustomLink } from "@/components/ui/custom-link";
import { IoMdArrowBack } from "react-icons/io";

const PrintComponent = ({ order }: { order: Order }) => {
  const [showPrintButton, setShowPrintButton] = useState(true);
  const printRef = useRef<HTMLDivElement>(null);

  const handlePrint = async () => {
    await setShowPrintButton(false);
    printPart();
    setShowPrintButton(true);
  };

  const printPart = useReactToPrint({
    content: () => printRef.current,
  });

  return (
    <main>
      {showPrintButton && (
        <>
          <DashboardHeader>
            <Breadcrumb className="my-2" dir="rtl">
              <BreadcrumbList>
                <BreadcrumbItem>
                  <BreadcrumbLink asChild>
                    <Link href={`/`}>الرئيسية</Link>
                  </BreadcrumbLink>
                </BreadcrumbItem>
                <BreadcrumbSeparator />
                <BreadcrumbItem>
                  <BreadcrumbLink asChild>
                    <Link href={`/dashboard`}>لوحة التحكم</Link>
                  </BreadcrumbLink>
                </BreadcrumbItem>
                <BreadcrumbSeparator />
                <BreadcrumbItem>
                  <BreadcrumbLink asChild>
                    <Link href={`/dashboard/orders`}>الفواتير</Link>
                  </BreadcrumbLink>
                </BreadcrumbItem>
                <BreadcrumbSeparator />
                <BreadcrumbItem>
                  <BreadcrumbLink asChild>
                    <Link href={`/dashboard/orders/${order.id}`}>
                      {order.barcode}{" "}
                    </Link>
                  </BreadcrumbLink>
                </BreadcrumbItem>
                <BreadcrumbSeparator />
                <BreadcrumbItem>
                  <BreadcrumbPage>{"طباعة"}</BreadcrumbPage>
                </BreadcrumbItem>
              </BreadcrumbList>
            </Breadcrumb>
          </DashboardHeader>
          <div className=" container my-4 flex justify-center items-center gap-3">
            <Button onClick={handlePrint}>
              <FaPrint className="ml-2 w-4 h-4" />
              طباعة
            </Button>
            <CustomLink href={`/dashboard/orders/${order.id}`}>
              <IoMdArrowBack className="ml-2 w-4 h-4 rotate-180" />
              العودة
            </CustomLink>
          </div>
        </>
      )}
      <div ref={printRef}>
        <PrintBill user={order.user} order={order} />
      </div>
    </main>
  );
};

export default PrintComponent;
