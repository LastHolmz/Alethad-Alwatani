import { Request, Response } from "express";
import prisma from "../../../prisma/db";
import {
  comparePassword,
  hashPassword,
  isValidPhoneNumber,
  validateFullName,
  validatePassword,
} from "../../lib";
import { Gender } from "@prisma/client";
import { decodedJwtToken, generateJwtToken } from "../../lib/jwt";
import ResponseHelper from "../../middlewares/response.helper";

/**
 * Registers a new user.
 *
 * @param {Request} req - The request object.
 * @param {Response} res - The response object.
 * @throws {BadRequestError} If any required fields are missing or validation fails.
 * @throws {DuplicatedError} If a user with the provided phone number already exists.
 * @returns {Promise<Response>} The response object with the registration status.
 */
const login = async (req: Request, res: Response) => {
  console.log("calling login function...");
  const responseHelper = new ResponseHelper(res);
  try {
    const {
      password,
      mobile,
    }: {
      mobile: number;
      password: string;
    } = req.body;
    // console.log(req.body);

    // Validate required fields
    if (!mobile || !password) {
      return responseHelper.error("يجب ملء كل الحقول", 400);
    }
    const isValidPhone = isValidPhoneNumber(mobile);
    if (!isValidPhone) {
      return responseHelper.error("يجب ادخال رقم هاتف صحيح");
    }

    // Validate full name length
    // if (!validateFullName(fullName)) {
    //   throw new BadRequestError("يجب أن يكون الاسم الكامل على الأقل 10 أحرف");
    // }

    // Validate password length
    // if (!validatePassword(password)) {
    //   throw new BadRequestError("يجب أن يكون طول كلمة المرور 8 أحرف على الأقل");
    // }

    // Validate phone number format
    // if (!validatePhoneNumber(mobile)) {
    //   throw new BadRequestError(
    //     "رقم الهاتف غير صالح، يجب أن يبدأ بـ 092 أو 93 أو 94 أو 093 أو 091 أو 92 ويتبعه 7 أرقام"
    //   );
    // }
    // // Validate phone number format
    // if (!validatePhoneNumber(componeyMobile)) {
    //   throw new BadRequestError(
    //     "رقم الهاتف غير صالح، يجب أن يبدأ بـ 092 أو 93 أو 94 أو 093 أو 091 أو 92 ويتبعه 7 أرقام"
    //   );
    // }

    // Check if user already exists
    const user = await prisma.user.findUnique({
      where: {
        mobile,
      },
    });

    if (!user) {
      return responseHelper.error("هذا المستخدم غير موجود ", 404);
    }

    const comparePassowrd = comparePassword({
      hashedPassword: user.password,
      password,
    });

    if (!comparePassowrd) {
      return responseHelper.error("كلمة المرور غير متطابقة", 403);
    }

    const token = generateJwtToken({
      fullName: user.fullName,
      role: user.role,
      status: user.status,
      userId: user.id,
    });
    return res.status(200).json({
      message: "تم تسجيل الدخول",
      data: {
        ...user,
        token,
      },
    });
  } catch (error) {
    console.error(error); // Use console.error for error logging
    return res.status(500).json({ message: "INTERNAL_SERVER_ERROR" });
  }
};

const register = async (req: Request, res: Response) => {
  const responseHelper = new ResponseHelper(res);
  try {
    const {
      fullName,
      password,
      mobile,
      companyTitle,
      componeyMobile,
      gender,
      location,
    }: {
      mobile: number;
      fullName: string;
      password: string;
      gender: Gender;
      companyTitle: string;
      location?: string;
      componeyMobile: number;
    } = req.body;

    // Validate required fields
    if (
      !mobile ||
      !fullName ||
      !password ||
      !companyTitle ||
      !gender ||
      !password ||
      !componeyMobile
    ) {
      return responseHelper.error("يجب ملء كل الحقول", 400);
    }

    const isValidPhone = isValidPhoneNumber(mobile);
    const isValidCompanyPhone = isValidPhoneNumber(mobile);
    if (!isValidPhone) {
      return responseHelper.error("يجب ادخال رقم هاتف صحيح");
    }
    if (!isValidCompanyPhone) {
      return responseHelper.error("يجب ان يكون رقم هاتف الشركة صحيح");
    }

    // Validate full name length
    if (!validateFullName(fullName)) {
      return responseHelper.error(
        "يجب أن يكون الاسم الكامل على الأقل 10 أحرف",
        400
      );
    }

    // Validate password length
    if (!validatePassword(password)) {
      return responseHelper.error(
        "يجب أن يكون طول كلمة المرور 8 أحرف على الأقل",
        400
      );
    }

    // Validate phone number format
    // if (!validatePhoneNumber(mobile)) {
    //   throw new BadRequestError(
    //     "رقم الهاتف غير صالح، يجب أن يبدأ بـ 092 أو 93 أو 94 أو 093 أو 091 أو 92 ويتبعه 7 أرقام"
    //   );
    // }
    // // Validate phone number format
    // if (!validatePhoneNumber(componeyMobile)) {
    //   throw new BadRequestError(
    //     "رقم الهاتف غير صالح، يجب أن يبدأ بـ 092 أو 93 أو 94 أو 093 أو 091 أو 92 ويتبعه 7 أرقام"
    //   );
    // }

    // Check if user already exists
    const existedUser = await prisma.user.findUnique({
      where: {
        mobile,
      },
    });

    if (existedUser) {
      return responseHelper.error("هذا المستخدم موجود مسبقاً", 409);
    }

    // Hash the password
    const hashedPassword = hashPassword({ password });

    // Create the new user
    const user = await prisma.user.create({
      data: {
        fullName,
        password: hashedPassword,
        companyTitle,
        componeyMobile,
        mobile,
        gender,
        location,
      },
    });

    if (!user) {
      return responseHelper.error("فشل إنشاء المستخدم", 400);
    }

    const token = generateJwtToken({
      fullName: user.fullName,
      role: user.role,
      status: user.status,
      userId: user.id,
    });
    return res.status(201).json({
      message: "تم الإنشاء بنجاح",
      data: {
        ...user,
        token,
      },
    });
  } catch (error) {
    console.error(error); // Use console.error for error logging
    return res.status(500).json({ message: "INTERNAL_SERVER_ERROR" });
  }
};

const checkToken = async (req: Request, res: Response) => {
  const responseHelper = new ResponseHelper(res);

  try {
    // req.
    const { token } = req.params as { token: string };
    if (!token) {
      return responseHelper.error("must to provide token", 400);
    }
    const decodedToken = decodedJwtToken(token);
    console.log(decodedToken);

    if (!decodedToken) {
      return responseHelper.error("must to provide a proper token", 400);
    }
    // console.log(decodedToken);

    const user = await prisma.user.findUnique({
      where: { id: decodedToken.userId },
    });
    if (!user) {
      return responseHelper.error("the user isn't available anymore", 400);
    }
    if (user.status === "inactive") {
      return res
        .status(403)
        .json({ data: null, message: "تم الغاء تفعيل هذا الحساب" });
    }
    return responseHelper.success(
      {
        ...user,
        token,
      },
      "تم تسجيل الدخول بنجاح",
      200
    );
  } catch (error) {
    console.error(error);
    return responseHelper.error("حدث خطأ في الخادم", 500);
  }
};

export { register, checkToken, login };
