import express from "express";
import {
  checkCart,
  createNewSku,
  deleteSku,
  getSkuById,
  getSkus,
  updateSku,
} from "../../controllers/skus";
import { authenticate, authorize } from "../../middlewares/auth";

const router = express.Router();

router.post("/:productId", authenticate, authorize(["admin"]), createNewSku);
router
  .route("/:skuId")
  .put(authenticate, authorize(["admin"]), updateSku)
  .delete(authenticate, authorize(["admin"]), deleteSku)
  .get(authenticate, authorize(["admin"]), getSkuById);
router.route("/").get(getSkus);
router
  .route("/cart/verify")
  .post(authenticate, authorize([], ["active"]), checkCart);

export default router;
