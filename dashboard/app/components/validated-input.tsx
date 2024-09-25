import React, {
  InputHTMLAttributes,
  useState,
  ForwardedRef,
  forwardRef,
} from "react";
import { Input } from "@/components/ui/input";
import { isValidPhoneNumber } from "@/lib/utils";

interface Props extends InputHTMLAttributes<HTMLInputElement> {
  className?: string;
  setError?: React.Dispatch<React.SetStateAction<boolean>>;
  error?: boolean;
}

// Use forwardRef to handle the ref properly
const InputValidator = forwardRef<HTMLInputElement, Props>(
  (
    { className, error = false, setError, ...props },
    ref: ForwardedRef<HTMLInputElement>
  ) => {
    const [phoneNumber, setPhoneNumber] = useState<string>("");
    const [errorMsg, setErrorMsg] = useState<string | null>(null);

    const handlePhoneNumberChange = (
      event: React.ChangeEvent<HTMLInputElement>
    ) => {
      const value = event.target.value;
      setPhoneNumber(value);

      if (isValidPhoneNumber(value)) {
        if (setError) {
          setError(false);
        }
        setErrorMsg(null);
      } else {
        setPhoneNumber(value);

        setErrorMsg("يجب ادخال رقم هاتفك الحقيقي");
        if (setError) {
          setError(true);
        }
      }
    };

    return (
      <div>
        <Input
          ref={ref}
          {...props}
          value={phoneNumber}
          onChange={handlePhoneNumberChange}
        />
        {errorMsg && <p className="text-red-600 text-xs my-2">{errorMsg}</p>}
      </div>
    );
  }
);
InputValidator.displayName = "InputValidator";

export default InputValidator;
