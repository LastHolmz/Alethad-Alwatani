import { Request, Response } from "express";
import prisma from "../../../prisma/db";
import { User } from "@prisma/client";
import ResponseHelper from "../../middlewares/response.helper";
import { AuthenticatedRequest } from "../../../types";
import { hashPassword } from "../../lib";

const updateUser = async (req: Request, res: Response) => {
  const responseHelper = new ResponseHelper(res);

  try {
    const { id } = req.params;
    const {
      companyTitle,
      componeyMobile,
      fullName,
      gender,
      location,
      mobile,
      password,
      role,
      status,
    } = req.body as User;
    if (!id) {
      return responseHelper.error(`cannot find the id`);
    }
    const user = await prisma.user.update({
      where: {
        id,
      },
      data: {
        status,
      },
    });
    responseHelper.success(user, "تم تحديث المستخدم");
  } catch (error) {
    console.error(error); // Use console.error for error logging
    return res.status(500).json({ message: "INTERNAL_SERVER_ERROR" });
  }
};
const getUsers = async (req: Request, res: Response) => {
  const responseHelper = new ResponseHelper(res);
  const { name } = req.query;
  let fullName: any;
  if (name) {
    fullName = {
      contains: name,
    };
  }
  try {
    const users = await prisma.user.findMany({
      where: {
        fullName,
      },
      orderBy: {
        createdAt: "desc",
      },
    });
    if (!users) {
      return res.json({ data: [] }).status(404);
    }
    return res.json({ data: users }).status(200);
  } catch (error) {
    console.error(error); // Use console.error for error logging
    return res.status(500).json({ message: "INTERNAL_SERVER_ERROR" });
  }
};
const createUser = async (req: AuthenticatedRequest, res: Response) => {
  const responseHelper = new ResponseHelper(res);

  try {
    const {
      companyTitle,
      componeyMobile,
      fullName,
      gender,
      location,
      mobile,
      password,
      role,
      status,
    } = req.body as Omit<User, "updatedAt" | "createdAt" | "id">;
    if (
      !companyTitle ||
      !componeyMobile ||
      !fullName ||
      !gender ||
      !location ||
      !mobile ||
      !password ||
      !role ||
      !status
    ) {
      return responseHelper.error("يجب ملء كل الحقول", 400);
    }
    const hashedpassword = hashPassword({ password });
    const user = await prisma.user.create({
      data: {
        companyTitle,
        componeyMobile,
        fullName,
        gender,
        location,
        mobile,
        password: hashedpassword,
        role,
        status,
      },
    });

    if (!user) {
      return res
        .json({ data: undefined, message: "فشل انشاء السمتخدم" })
        .status(400);
    }
    return res
      .json({ data: user, message: "تم انشاء المستخدم بنجاح" })
      .status(200);
  } catch (error) {
    console.error(error); // Use console.error for error logging
    return res
      .status(500)
      .json({ message: "INTERNAL_SERVER_ERROR", data: undefined });
  }
};

export { updateUser, getUsers, createUser };
