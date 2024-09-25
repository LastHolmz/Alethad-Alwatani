/**
 * Validates a phone number to ensure it starts with one of the specified prefixes
 * (092, 091, 094, or 093) and is exactly 10 digits long.
 *
 * @param {number} phoneNumber - The phone number to validate.
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
export function isValidPhoneNumber(phoneNumber: number): boolean {
  const pattern = /^(092|091|094|093|92|91|94|93)\d{7}$/;
  return pattern.test(phoneNumber.toString());
}
