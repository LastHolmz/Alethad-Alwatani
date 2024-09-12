import jwt, { SignOptions, JwtPayload } from "jsonwebtoken";
import { UnauthenticatedError } from "../errors";

/**
 * Signs a JWT token with the provided payload.
 *
 * @template T - The type of the payload.
 * @param {T} payload - The data to encode in the token.
 * @param {string} secret - The secret key to sign the token.
 * @param {SignOptions} [options] - Additional options for the token (e.g., expiresIn).
 * @returns {string} The signed JWT token.
 *
 * @example
 * ```typescript
 * interface UserPayload {
 *   userId: string;
 *   email: string;
 * }
 *
 * const secretKey = 'your_secret_key';
 * const userPayload: UserPayload = { userId: '12345', email: 'user@example.com' };
 * const token = signToken<UserPayload>(userPayload, secretKey, { expiresIn: '1h' });
 * console.log('Signed Token:', token);
 * ```
 */
const signToken = <T extends object>(
  payload: T,
  secret: string,
  options: SignOptions = {}
): string => {
  return jwt.sign(payload, secret, options);
};

/**
 * Verifies a JWT token and decodes it.
 *
 * @template T - The expected type of the decoded payload.
 * @param {string} token - The JWT token to verify.
 * @param {string} secret - The secret key to verify the token.
 * @returns {T & JwtPayload} The decoded payload if verification is successful.
 * @throws {Error} If the token is invalid or expired.
 *
 * @example
 * ```typescript
 * interface UserPayload {
 *   userId: string;
 *   email: string;
 * }
 *
 * const secretKey = 'your_secret_key';
 * const token = 'received_jwt_token_here';
 *
 * try {
 *   const decoded = verifyToken<UserPayload>(token, secretKey);
 *   console.log('Decoded Payload:', decoded);
 * } catch (error) {
 *   console.error('Token verification failed:', error.message);
 * }
 * ```
 */
const verifyToken = <T extends object>(
  token: string,
  secret: string
): T & JwtPayload => {
  try {
    return jwt.verify(token, secret) as T & JwtPayload;
  } catch (error) {
    throw new UnauthenticatedError("Unauthenticated");
  }
};

export { signToken, verifyToken };
