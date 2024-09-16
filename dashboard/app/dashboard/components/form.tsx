"use client";
import { toast } from "@/components/ui/use-toast";
import { ReactNode, useEffect } from "react";
import { useFormState } from "react-dom";
import { cn } from "@/lib/utils";
import { useRouter } from "next/navigation";

const initMessage: { message: string } = {
  message: "",
};

type action = (
  prevState: { message: string },
  formData: FormData
) => Promise<{ message: string }>;

interface Props {
  action: action;
  className?: string;
  children: ReactNode;
  sucess?: string;
  replaceLink?: string;
  dir?: "ltr" | "rtl";
  onSuccessEvent?: () => void;
  stopReplacing?: boolean;
}
/**
 * @param {replaceLink} replaceLink is string will be redirected to, the default is "/" home page
 * {sucess} sucess is string msg that will be displayed when the action is successful
 */
const Form = ({
  className,
  action,
  children,
  replaceLink = "/",
  sucess = "تمت العملية بنجاح",
  dir = "rtl",
  stopReplacing = false,
  onSuccessEvent,
}: Props) => {
  const router = useRouter();
  const [msg, dispatch] = useFormState(action, initMessage);
  useEffect(() => {
    if (!msg.message || msg.message.length === 0) {
      return;
    } else {
      toast({
        title: msg.message,
      });
      if (sucess) {
        if (msg.message === sucess) {
          if (onSuccessEvent) {
            onSuccessEvent();
          }
          if (stopReplacing) return;
          router.replace(replaceLink);
        }
      } else {
        if (msg.message === "تمت العملية بنجاح") {
          if (onSuccessEvent) {
            onSuccessEvent();
          }

          if (stopReplacing) return;
          router.replace(replaceLink);
        }
      }
    }
  }, [msg, router]);
  return (
    <form dir={dir} action={dispatch} className={cn(className)}>
      {children}
    </form>
  );
};

export default Form;
