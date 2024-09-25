import { Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { UserRole as Role, UserStatus } from "@prisma/client";
import { AuthenticatedRequest, JwtUser } from "../../types";
import ResponseHelper from "./response.helper";

const authenticate = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Invalid token format" });
  }
  const token = authHeader.split(" ")[1];
  if (!token) {
    return res.status(401).json({ message: "No token provided" });
  }
  jwt.verify(token, process.env.JWT_PRIVATE_KEY as string, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: "Invalid token" });
    }
    req.user = decoded as JwtUser;
    next();
  });
};

const authorize =
  (allowedRoles?: Role[], allowedStatus?: UserStatus[]) =>
  (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    const userRole = req.user?.role;
    const userStatus = req.user?.status;
    // console.log(req.user);
    // console.log("userRole: " + userRole);
    // console.log("allowedRoles: " + allowedRoles);

    const responseHelper = new ResponseHelper(res);
    if (!userRole || !userStatus) {
      return responseHelper.error("Unauthorized", 403);
    }

    if (!allowedRoles || allowedRoles.length === 0) {
      return next(); // No role restrictions
    }
    if (!allowedStatus || allowedStatus.length === 0) {
      return next(); // No role restrictions
    }

    // Check if the user's role is in the allowed roles
    if (!allowedStatus.includes(userStatus)) {
      return responseHelper.error("status doesn't match", 403);
    }
    if (!allowedRoles.includes(userRole)) {
      return responseHelper.error("role doesn't match", 403);
    }

    next();
  };

export { authenticate, authorize };
