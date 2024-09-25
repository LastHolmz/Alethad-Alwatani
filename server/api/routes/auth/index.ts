import { Router } from "express";
import { checkToken, login, register } from "../../controllers/auth";

const router = Router();

router.route("/register").post(register);
router.route("/login").post(login);
router.route("/check-token/:token").get(checkToken);

export default router;
