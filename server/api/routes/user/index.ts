import { Router } from "express";
import {
  createUser,
  getUserById,
  getUsers,
  updateUser,
} from "../../controllers/user";

const router = Router();
router.route("/").get(getUsers).post(createUser);
router.route("/:id").put(updateUser).get(getUserById);

export default router;
