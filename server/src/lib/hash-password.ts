import bcrypt from "bcrypt";

/**
 * Hashes a given password using bcrypt.
 *
 * @param {Object} params - The parameters for hashing.
 * @param {string} params.password - The password to be hashed.
 * @returns {string} The hashed password.
 */
const hashPassword = ({ password }: { password: string }): string => {
  const saltRounds = 10;
  const salt = bcrypt.genSaltSync(saltRounds);
  const hash = bcrypt.hashSync(password, salt);
  return hash;
};

/**
 * Compares a plain password with a hashed password using bcrypt.
 *
 * @param {Object} params - The parameters for comparison.
 * @param {string} params.password - The plain password to compare.
 * @param {string} params.hashedPassword - The hashed password to compare against.
 * @returns {boolean} `true` if the passwords match, `false` otherwise.
 */
const comparePassword = ({
  hashedPassword,
  password,
}: {
  password: string;
  hashedPassword: string;
}): boolean => {
  return bcrypt.compareSync(password, hashedPassword);
};

export { hashPassword, comparePassword };
