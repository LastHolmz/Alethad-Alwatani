/**
 * Validates a Libyan phone number based on specific prefixes and length.
 *
 * @param {string} phoneNumber - The phone number to validate.
 * @returns {boolean} `true` if the phone number is valid, `false` otherwise.
 */
const validatePhoneNumber = (phoneNumber: number): boolean => {
  let phone = String(phoneNumber);
  const phoneRegExp = /^(092|93|94|093|091|92)\d{7}$/;
  return phoneRegExp.test(phone);
};

/**
 * Validates a full name ensuring it is at least 10 characters long.
 *
 * @param {string} fullName - The full name to validate.
 * @returns {boolean} `true` if the full name is valid, `false` otherwise.
 */
const validateFullName = (fullName: string): boolean => {
  const nameRegExp = /^.{10,}$/; // At least 10 characters
  return nameRegExp.test(fullName);
};

/**
 * Validates a password ensuring it is at least 8 characters long.
 *
 * @param {string} password - The password to validate.
 * @returns {boolean} `true` if the password is valid, `false` otherwise.
 */
const validatePassword = (password: string): boolean => {
  const passwordRegExp = /^.{8,}$/; // At least 8 characters
  return passwordRegExp.test(password);
};

export { validateFullName, validatePassword, validatePhoneNumber };
