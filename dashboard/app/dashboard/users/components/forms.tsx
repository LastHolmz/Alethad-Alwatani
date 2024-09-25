"use client";

import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import SubmitButton from "@/app/dashboard/components/custom-submit-btn";
import { newUserAction, updateUserStatusAction } from "../actions";

import AccessibleDialogForm from "../../components/accible-dialog-form";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

export const CreateUserForm = () => {
  return (
    <AccessibleDialogForm
      trigger={<Button type="button">مشرف جديد</Button>}
      action={newUserAction}
      dontReplace
      success="تم انشاء المستخدم بنجاح"
      className="mt-4 mb-2"
    >
      <div className="grid gap-1 md:grid-cols-2">
        <div>
          <Label htmlFor="fullName">اسم المشرف</Label>
          <Input
            id="fullName"
            required
            type={"text"}
            name="fullName"
            placeholder="ادخل اسم المشرف"
          />
        </div>
        <div>
          <Label htmlFor="mobile">رقم الهاتف</Label>
          <Input
            id="mobile"
            required
            type={"tel"}
            name="mobile"
            placeholder="ادخل رقم الهاتف"
          />
        </div>
        <div>
          <Label htmlFor="password">كلمة السر</Label>
          <Input
            id="password"
            required
            type={"password"}
            name="password"
            placeholder="ادخل كلمة السر"
          />
        </div>
        <div>
          <Label htmlFor="gender">الجنس</Label>

          <Select name="gender" defaultValue="man">
            <SelectTrigger id="gender" className="sm:w-[180px] w-full">
              <SelectValue placeholder="الجنس" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="man">ذكر</SelectItem>
              <SelectItem value="woman">أنثى</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>
      <SubmitButton className="w-full sm:w-1/4 mt-2" type={"submit"}>
        انشاء
      </SubmitButton>
    </AccessibleDialogForm>
  );
};

export const UpdateUserStatusForm = ({ user }: { user: User }) => {
  return (
    <AccessibleDialogForm
      trigger={<button type="button">تحديث الحالة</button>}
      action={updateUserStatusAction}
      success="تم تحديث المستخدم"
      dontReplace
      className="mt-4 mb-2"
      title={`تحديث حالة المستخدم ${user.fullName}`}
    >
      <Select name="status" defaultValue={user.status}>
        <SelectTrigger className="w-[180px]">
          <SelectValue placeholder="الحالة" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="pending">معلق</SelectItem>
          <SelectItem value="active">مفعل</SelectItem>
          <SelectItem value="inactive">معطل</SelectItem>
        </SelectContent>
      </Select>

      <Input type="hidden" name="id" value={user.id} />
      <SubmitButton
        className="w-full sm:w-1/4 mt-2"
        type={"submit"}
        variant={"secondary"}
      >
        تحديث
      </SubmitButton>
    </AccessibleDialogForm>
  );
};
