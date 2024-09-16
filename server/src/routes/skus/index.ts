import express from "express";
import {
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

export default router;
