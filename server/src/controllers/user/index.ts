import { Request, Response } from "express";
import prisma from "../../../prisma/db";
import { User } from "@prisma/client";
import ResponseHelper from "../../middlewares/response.helper";

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

  try {
    const users = await prisma.user.findMany({});
    if (!users) {
      return res.json({ data: [] }).status(404);
    }
    return res.json({ data: users }).status(200);
  } catch (error) {
    console.error(error); // Use console.error for error logging
    return res.status(500).json({ message: "INTERNAL_SERVER_ERROR" });
  }
};

export { updateUser, getUsers };
