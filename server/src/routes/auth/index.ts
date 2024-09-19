import { Router } from "express";
import { checkToken, register } from "../../controllers/auth";

const router = Router();

router.route("/register").post(register);
router.route("/check-token/:token").get(checkToken);

export default router;
