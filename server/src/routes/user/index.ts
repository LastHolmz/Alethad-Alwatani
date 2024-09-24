import { Router } from "express";
import { createUser, getUsers, updateUser } from "../../controllers/user";

const router = Router();
router.route("/").get(getUsers).post(createUser);
router.route("/:id").put(updateUser);

export default router;
