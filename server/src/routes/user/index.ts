import { Router } from "express";
import { getUsers, updateUser } from "../../controllers/user";

const router = Router();
router.route("/").get(getUsers);
router.route("/:id").put(updateUser);

export default router;
