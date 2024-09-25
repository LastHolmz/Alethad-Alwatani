"use client";

import { cn } from "@/lib/utils";
import React, { useState } from "react";
import { loginAction } from "@/lib/auth";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";

import Link from "next/link";
import { buttonVariants } from "@/lib/constant";
import InputValidator from "@/app/components/validated-input";
import SubmitButton from "@/app/dashboard/components/custom-submit-btn";
import Form from "@/app/dashboard/components/form";
import { toast } from "@/components/ui/use-toast";

const SignInForm = ({
  className,
  redirectTo,
}: {
  className?: string;
  redirectTo?: string;
}) => {
  const [error, setError] = useState<boolean>(false);

  return (
    <div className={cn(className)}>
      <Form
        className="w-full"
        action={loginAction}
        success="تم تسجيل الدخول بنجاح"
        replaceLink={redirectTo ?? "/"}
      >
        <div className="grid gap-1 sm:w-1/2 mx-auto sm:gap-3 ">
          <div>
            <Label className="" htmlFor="mobile">
              رقم الهاتف
            </Label>
            <InputValidator
              id="mobile"
              required
              type={"tel"}
              name="mobile"
              dir="rtl"
              error={error}
              setError={setError}
              placeholder="ادخل رقم هاتفك"
            />
          </div>

          <div>
            <Label className="" htmlFor="password">
              كلمة المرور
            </Label>
            <Input
              id="password"
              required
              type={"password"}
              name="password"
              placeholder="ادخل كلمة سر خاصة بك"
            />
          </div>
          <SubmitButton
            onClick={() => {
              if (error) {
                toast({
                  title: "يجب ادخال البيانات بطريقة صحيحة",
                });
              }
            }}
            className="w-full mx-auto sm:w-1/4 mt-4"
            type={error ? "button" : "submit"}
          >
            تسجيل الدخول
          </SubmitButton>
        </div>
      </Form>
    </div>
  );
};

export { SignInForm };
