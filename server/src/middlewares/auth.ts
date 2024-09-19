import { Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { UserRole as Role, UserStatus } from "@prisma/client";
import { AuthenticatedRequest, JwtUser } from "../../types";
import responseHelper from "./response.helper";

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
  (requiredRole: Role) =>
  (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    const userRole = req.user?.role;
    if (!userRole || userRole !== requiredRole) {
      return responseHelper.error("Unauthorized", 403);
    }
    next();
  };

export { authenticate, authorize };
