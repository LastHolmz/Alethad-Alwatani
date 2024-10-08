import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export const convertToHex = (color: string): string => {
  // If the color is already in HEX format, return it
  if (color.startsWith("#")) {
    return color.toUpperCase();
  }

  // If the color is in RGB format (e.g., rgb(255, 0, 0)), convert it to HEX
  if (color.startsWith("rgb")) {
    const rgbValues = color
      .replace(/[^\d,]/g, "") // Remove non-digit and non-comma characters
      .split(",")
      .map((val) => Number(val.trim())); // Convert each value to a number

    if (rgbValues.length !== 3) return "#000000"; // Invalid RGB

    const hex = rgbValues
      .map((value) => {
        const hexValue = value.toString(16); // Convert to hex
        return hexValue.length === 1 ? "0" + hexValue : hexValue; // Ensure 2 digits
      })
      .join("");

    return `#${hex.toUpperCase()}`;
  }

  // If the color is in HSL format (e.g., hsl(120, 100%, 50%)), convert it to HEX
  if (color.startsWith("hsl")) {
    const hslValues = color
      .replace(/[^\d,.]/g, "") // Remove non-digit, non-dot, and non-comma characters
      .split(",")
      .map((val) => Number(val.trim()));

    if (hslValues.length !== 3) return "#000000"; // Invalid HSL

    const [h, s, l] = hslValues;

    const hslToRgb = (
      h: number,
      s: number,
      l: number
    ): [number, number, number] => {
      s /= 100;
      l /= 100;

      const k = (n: number) => (n + h / 30) % 12;
      const a = s * Math.min(l, 1 - l);
      const f = (n: number) =>
        l - a * Math.max(-1, Math.min(k(n) - 3, Math.min(9 - k(n), 1)));

      return [
        Math.round(f(0) * 255),
        Math.round(f(8) * 255),
        Math.round(f(4) * 255),
      ];
    };

    const rgb = hslToRgb(h, s, l);
    const hex = rgb
      .map((value) => {
        const hexValue = value.toString(16);
        return hexValue.length === 1 ? "0" + hexValue : hexValue;
      })
      .join("");

    return `#${hex.toUpperCase()}`;
  }

  // If it's not HEX, RGB, or HSL, return null
  return "#000000";
};

export const orderStatusToArabic = (status: OrderStatus): string => {
  const translations: Record<OrderStatus, string> = {
    pending: "قيد الانتظار",
    inProgress: "قيد التنفيذ",
    done: "منجز",
    rejected: "مرفوض",
    refused: "مرفوض",
  };

  return translations[status];
};

export interface FocusElementProps<T extends HTMLElement> {
  elementRef: React.RefObject<T>;
}

/**
 * Focuses on the element referenced by the provided ref.
 *
 * @param elementRef - A ref object pointing to the HTML element to focus on.
 */
export const focusTo = <T extends HTMLElement>({
  elementRef,
}: FocusElementProps<T>) => {
  if (elementRef.current) {
    elementRef.current?.focus();
  }
};

/**
 * Validates a phone number to ensure it starts with one of the specified prefixes
 * (092, 091, 094, or 093) and is exactly 10 digits long.
 *
 * @param {string} phoneNumber - The phone number to validate.
 * @returns {boolean} `true` if the phone number is valid, `false` otherwise.
 *
 * @example
 * // Returns true
 * isValidPhoneNumber('0921234567');
 *
 * @example
 * // Returns false
 * isValidPhoneNumber('0891234567');
 */
export function isValidPhoneNumber(phoneNumber: string): boolean {
  const pattern = /^(092|091|094|093|92|91|94|93)\d{7}$/;
  return pattern.test(phoneNumber);
}
