"use client";

import { Input } from "@/components/ui/input";
import SubmitButton from "@/app/dashboard/components/custom-submit-btn";

import AccessibleDialogForm from "../../components/accible-dialog-form";
import { updateOrderAction } from "../new/actions";
import { Button } from "@/components/ui/button";
import { PiKeyReturnBold } from "react-icons/pi";

export const ReturnOrderForm = ({ order }: { order: Order }) => {
  return (
    <AccessibleDialogForm
      trigger={<Button type="button">ارجاع الفاتورة</Button>}
      action={updateOrderAction}
      dontReplace
      stopClosing={false}
      className="mt-4 mb-2"
      title={`ارجاع الفاتورة ${order.barcode}`}
    >
      <Input type="hidden" name="id" value={order.id} />
      <Input type="hidden" name="to" value={"cancel"} />
      <Input type="hidden" name="status" value={order.status} />
      <SubmitButton
        className="w-full sm:w-1/4 mt-2"
        type={"submit"}
        variant={"secondary"}
      >
        ارجاع
        <PiKeyReturnBold className=" w-4 h-4" />
      </SubmitButton>
    </AccessibleDialogForm>
  );
};
