"use client";
import { toast } from "@/components/ui/use-toast";
import { ReactNode, useEffect, useState } from "react";
import { useFormState } from "react-dom";
import { cn } from "@/lib/utils";
import { useRouter } from "next/navigation";

const initMessage: { message: string } = {
  message: "",
};

type Action = (
  prevState: { message: string },
  formData: FormData
) => Promise<{ message: string }>;

interface Props {
  action: Action;
  className?: string;
  children: ReactNode;
  success?: string;
  replaceLink?: string;
  dontReplace?: boolean;
  stopClosing?: boolean;
}

/**
 * Accessible form component with custom dialog, actions, and success handling.
 *
 * @param {Action} action - The async function to be called on form submission.
 * @param {string} [className] - Optional class names for the form.
 * @param {ReactNode} children - The form elements.
 * @param {string} [success] - Message to display on successful action.
 * @param {string} [replaceLink] - URL to navigate to after success. Defaults to "/".
 * @param {boolean} [dontReplace=false] - Whether to prevent navigation on success.
 * @param {boolean} [stopClosing=false] - Whether to prevent the dialog from closing automatically.
 */
const Form = ({
  action,
  className,
  children,
  success,
  replaceLink = "/",

  dontReplace = false,
  stopClosing = false,
}: Props) => {
  const router = useRouter();
  const [msg, dispatch] = useFormState(action, { message: "" });
  const [open, setOpen] = useState<boolean>(false);

  const toggleOpen = () => {
    if (!stopClosing) setOpen((prev) => !prev);
  };

  useEffect(() => {
    if (!msg.message) return;

    toast({ title: msg.message });

    if (msg.message === (success || "تمت العملية بنجاح")) {
      if (!dontReplace) router.replace(replaceLink);
      toggleOpen();
    }
  }, [msg, success, replaceLink, dontReplace, router]);

  return (
    <form dir={"rtl"} action={dispatch} className={cn(className)}>
      {children}
    </form>
  );
};

export default Form;
