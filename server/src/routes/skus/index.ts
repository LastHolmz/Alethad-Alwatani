import express from "express";
import {
  checkCart,
  createNewSku,
  deleteSku,
  getSkuById,
  getSkus,
  updateSku,
} from "../../controllers/skus";
import { authorize } from "../../middlewares/auth";

const router = express.Router();

router.post("/:productId", authorize(["admin"]), createNewSku);
router
  .route("/:skuId")
  .put(authorize(["admin"]), updateSku)
  .delete(authorize(["admin"]), deleteSku)
  .get(authorize(["admin"]), getSkuById);
router.route("/").get(getSkus);
router.route("/cart/verify").post(authorize([], ["active"]), checkCart);

export default router;
