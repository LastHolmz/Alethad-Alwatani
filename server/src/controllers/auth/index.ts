import { Request, Response } from "express";
import { BadRequestError } from "../../errors";
import prisma from "../../../prisma/db";
import DuplicatedError from "../../errors/duplicated-request";
import {
  hashPassword,
  validateFullName,
  validatePassword,
  validatePhoneNumber,
} from "../../lib";

/**
 * Registers a new user.
 *
 * @param {Request} req - The request object.
 * @param {Response} res - The response object.
 * @throws {BadRequestError} If any required fields are missing or validation fails.
 * @throws {DuplicatedError} If a user with the provided phone number already exists.
 * @returns {Promise<Response>} The response object with the registration status.
 */
const register = async (req: Request, res: Response): Promise<Response> => {
  try {
    const {
      fullName,
      password,
      phone,
    }: { phone: number; fullName: string; password: string } = req.body;

    // Validate required fields
    if (!phone || !fullName || !password) {
      throw new BadRequestError("يجب ملء كل الحقول");
    }

    // Validate full name length
    if (!validateFullName(fullName)) {
      throw new BadRequestError("يجب أن يكون الاسم الكامل على الأقل 10 أحرف");
    }

    // Validate password length
    if (!validatePassword(password)) {
      throw new BadRequestError("يجب أن يكون طول كلمة المرور 8 أحرف على الأقل");
    }

    // Validate phone number format
    if (!validatePhoneNumber(phone)) {
      throw new BadRequestError(
        "رقم الهاتف غير صالح، يجب أن يبدأ بـ 092 أو 93 أو 94 أو 093 أو 091 أو 92 ويتبعه 7 أرقام"
      );
    }

    // Check if user already exists
    const existedUser = await prisma.user.findUnique({
      where: {
        phone,
      },
    });

    if (existedUser) {
      throw new DuplicatedError("هذا المستخدم موجود مسبقاً");
    }

    // Hash the password
    const hashedPassword = hashPassword({ password });

    // Create the new user
    const user = await prisma.user.create({
      data: {
        fullName,
        password: hashedPassword,
        phone,
      },
    });

    if (!user) {
      throw new BadRequestError("فشل إنشاء المستخدم");
    }

    return res.status(201).json({ message: "تم الإنشاء بنجاح", user });
  } catch (error) {
    console.error(error); // Use console.error for error logging
    return res.status(500).json({ message: "INTERNAL_SERVER_ERROR" });
  }
};

export { register };
