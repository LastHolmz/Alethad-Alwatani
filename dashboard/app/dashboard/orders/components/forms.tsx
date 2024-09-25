"use client";

import { Input } from "@/components/ui/input";
import SubmitButton from "@/app/dashboard/components/custom-submit-btn";
import { FcAcceptDatabase, FcCancel } from "react-icons/fc";
import AccessibleDialogForm from "../../components/accible-dialog-form";
import { updateOrderAction, updateOrderMoneyAction } from "../actions";
import { Button } from "@/components/ui/button";
import { PiKeyReturnBold } from "react-icons/pi";
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Label } from "@/components/ui/label";
import { useState } from "react";
import { Pencil } from "lucide-react";
export const ReturnOrderForm = ({
  order,
  table = false,
}: {
  order: Order;
  table?: boolean;
}) => {
  return (
    <AccessibleDialogForm
      trigger={
        table ? (
          <button
            className="flex justify-between items-center w-full"
            type="button"
          >
            ارجاع الفاتورة
            <PiKeyReturnBold className="mr-2 w-4 h-4" />
          </button>
        ) : (
          <Button className="mx-1" variant={"outline"} type="button">
            ارجاع الفاتورة
            <PiKeyReturnBold className="mr-2 w-4 h-4" />
          </Button>
        )
      }
      action={updateOrderAction}
      dontReplace
      stopClosing={false}
      className="mt-4 mb-2"
      title={`ارجاع الفاتورة ${order.barcode}`}
    >
      <Input type="hidden" name="id" value={order.id} />
      <Input type="hidden" name="to" value={"return"} />
      <Input type="hidden" name="status" value={order.status} />
      <SubmitButton
        className="w-full md:w-1/4 mt-2"
        type={"submit"}
        variant={"secondary"}
      >
        ارجاع
        <PiKeyReturnBold className="mr-2 w-4 h-4" />
      </SubmitButton>
    </AccessibleDialogForm>
  );
};
export const AcceptOrderForm = ({
  order,
  table = false,
}: {
  order: Order;
  table?: boolean;
}) => {
  return (
    <AccessibleDialogForm
      trigger={
        table ? (
          <button
            className="flex justify-between items-center w-full"
            type="button"
          >
            قبول الفاتورة
            <FcAcceptDatabase className="mr-2 w-4 h-4" />
          </button>
        ) : (
          <Button className="mx-1" variant={"outline"} type="button">
            قبول الفاتورة
            <FcAcceptDatabase className="mr-2 w-4 h-4" />
          </Button>
        )
      }
      action={updateOrderAction}
      dontReplace
      stopClosing={false}
      className="mt-4 mb-2"
      title={`قبول الفاتورة ${order.barcode}`}
    >
      <Input type="hidden" name="id" value={order.id} />
      <Input type="hidden" name="to" value={"accept"} />
      <div className="flex-between-row my-2">
        <Label htmlFor="status">{"تعديل حالة الفاتورة"}</Label>
        <Select defaultValue={"inProgress"} name="status">
          <SelectTrigger dir="rtl" className="w-[180px]" id="status">
            <SelectValue placeholder="تعديل حالة الفاتورة" />
          </SelectTrigger>
          <SelectContent dir="rtl">
            <SelectGroup>
              <SelectLabel>الحالات</SelectLabel>
              <SelectItem value="inProgress">تحت الإجراء</SelectItem>
              <SelectItem value="done">مكتملة</SelectItem>
            </SelectGroup>
          </SelectContent>
        </Select>
      </div>
      {/* <Input type="hidden" name="status" value={order.status} /> */}
      <SubmitButton className="w-full md:w-1/4 mt-2" type={"submit"}>
        قبول
        <FcAcceptDatabase className="mr-2 w-4 h-4" />
      </SubmitButton>
    </AccessibleDialogForm>
  );
};
export const RejectOrderForm = ({
  order,
  table = false,
}: {
  order: Order;
  table?: boolean;
}) => {
  return (
    <AccessibleDialogForm
      trigger={
        table ? (
          <button
            className="flex justify-between items-center w-full"
            type="button"
          >
            رفض الفاتورة
            <FcCancel className="mr-2 w-4 h-4" />
          </button>
        ) : (
          <Button className="mx-1" variant={"outline"} type="button">
            رفض الفاتورة
            <FcCancel className="mr-2 w-4 h-4" />
          </Button>
        )
      }
      action={updateOrderAction}
      dontReplace
      stopClosing={false}
      className="mt-4 mb-2"
      title={`رفض الفاتورة ${order.barcode}`}
    >
      <Input type="hidden" name="id" value={order.id} />
      <Input type="hidden" name="to" value={"cancel"} />
      <Input type="hidden" name="status" value={"rejected"} />
      <SubmitButton className="w-full md:w-1/4 mt-2" type={"submit"}>
        رفض
        <FcCancel className="mr-2 w-4 h-4" />
      </SubmitButton>
    </AccessibleDialogForm>
  );
};
export const UpdateOrderMoenyForm = ({
  order,
  table = false,
}: {
  order: Order;
  table?: boolean;
}) => {
  const [totalPrice, setTotalPrice] = useState(order.totalPrice);
  const [rest, setRest] = useState(order.rest);
  return (
    <AccessibleDialogForm
      trigger={
        table ? (
          <button
            className="flex justify-between items-center w-full"
            type="button"
          >
            تعديل قيمة الفاتورة
            <Pencil className="mr-2 w-4 h-4" />
          </button>
        ) : (
          <Button className="mx-1" variant={"outline"} type="button">
            تعديل قيمة الفاتورة
            <Pencil className="mr-2 w-4 h-4" />
          </Button>
        )
      }
      action={updateOrderMoneyAction}
      dontReplace
      stopClosing={false}
      className="mt-4 mb-2"
      title={`تعديل قيمة الفاتورة ${order.barcode}`}
    >
      <Input type="hidden" name="id" value={order.id} />
      <div>
        <Label htmlFor="totalPrice">السعر الكلي</Label>
        <Input
          id="totalPrice"
          required
          type={"number"}
          value={totalPrice}
          onChange={(e) => setTotalPrice(Number(e.target.value))}
          name="totalPrice"
          placeholder="ادخل السعر الكلي"
        />
      </div>
      <div>
        <Label htmlFor="rest">المتبقي</Label>
        <Input
          id="rest"
          required
          type={"number"}
          value={rest}
          onChange={(e) => setRest(Number(e.target.value))}
          name="rest"
          placeholder="ادخل المتبقي"
        />
      </div>
      <SubmitButton className="w-full md:w-1/4 mt-2" type={"submit"}>
        تعديل
        <Pencil className="mr-2 w-4 h-4" />
      </SubmitButton>
    </AccessibleDialogForm>
  );
};
