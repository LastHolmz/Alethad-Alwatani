import { parseDateTime } from "@/lib/date";
import Image from "next/image";
import React from "react";

interface PrintBillProps {
  user: User;
  order: Order;
}

export const PrintBill: React.FC<PrintBillProps> = ({ user, order }) => {
  return (
    <div
      dir="rtl"
      className="p-4 w-full h-full mx-auto bg-white border rounded shadow"
    >
      <div className=" h-20 w-20  mb-2  mx-auto overflow-hidden">
        <Image
          src={"/logo.png"}
          alt="logo"
          width={100}
          height={100}
          priority
          className="object-cover w-full h-full"
        ></Image>
      </div>
      <h1 className="font-extrabold text-3xl text-center mb-5">
        الإتحاد الوطني
      </h1>
      <div className="flex justify-between items-start">
        {" "}
        <h2 className="text-center text-lg font-bold mb-4">
          فاتورة رقم {order.barcode}
        </h2>
        <div>{parseDateTime({ dateTime: new Date(Date.now()) })}</div>
      </div>
      <p>
        <strong>التاجر:</strong> {user.fullName} <br />
        <strong>رقم الهاتف:</strong> {user.mobile}
      </p>
      <hr className="my-5" />
      <h3 className="text-md mb-2  font-semibold">معلومات الطلب</h3>
      <p>
        <strong>السسعر الكلي:</strong> ${order.totalPrice.toFixed(2)} <br />
        <strong>المتبقي:</strong> ${order.rest.toFixed(2)} <br />
        <strong>تاريخ الإنشاء:</strong>{" "}
        {parseDateTime({ dateTime: new Date(order.createdAt) })}
      </p>
      <hr className="my-5" />
      <h3 className="text-md   my-2 font-semibold">المنتجات</h3>
      <table className="min-w-full text-left text-sm">
        <thead>
          <tr>
            <th className="border px-2 py-1 text-right">اسم المنتج</th>
            <th className="border px-2 py-1 text-right">الباركود</th>
            <th className=" text-center border px-2 py-1">الكمية</th>
            <th className=" text-center border px-2 py-1">السعر</th>
            <th className=" text-center border px-2 py-1">الإجمالي</th>
          </tr>
        </thead>
        <tbody>
          {order.orderItems.map((item) => (
            <tr key={item.id}>
              <td className="border px-2 py-1 text-right">{item.title}</td>
              <td className="border px-2 py-1 text-right">{item.barcode}</td>
              <td className=" border px-2 py-1 text-center">{item.qty}</td>
              <td className=" text-center border px-2 py-1">
                {item.price.toFixed(2)} د
              </td>
              <td className=" text-center border px-2 py-1">
                {(item.qty * item.price).toFixed(2)} د
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <div className="text-right font-semibold mt-2">
        <p>الإجمالي: {order.rest.toFixed(2)} دينار</p>
      </div>
    </div>
  );
};
