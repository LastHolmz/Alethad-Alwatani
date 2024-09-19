import { UserRole, UserStatus } from "@prisma/client";
import { Request } from "express";
declare interface AuthenticatedRequest extends Request {
  user?: JwtUser;
  payLoad?: string;
}

declare type JwtUser = {
  userId: string;
  fullName: string;
  role: UserRole;
  status: UserStatus;
};
