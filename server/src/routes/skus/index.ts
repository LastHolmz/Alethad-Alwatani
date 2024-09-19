import express from "express";
import {
  checkCart,
  createNewSku,
  deleteSku,
  getSkuById,
  getSkus,
  updateSku,
} from "../../controllers/skus";

const router = express.Router();

router.post("/:productId", createNewSku);
router.route("/:skuId").put(updateSku).delete(deleteSku).get(getSkuById);
router.route("/").get(getSkus);
router.route("/cart/verify").post(checkCart);

export default router;
