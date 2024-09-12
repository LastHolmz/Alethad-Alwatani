import express from "express";
import {
  createNewSku,
  deleteSku,
  getSkus,
  updateSku,
} from "../../controllers/skus";

const router = express.Router();

router.post("/:productId", createNewSku);
router.route("/:skuId").put(updateSku).delete(deleteSku);
router.route("/").get(getSkus);

export default router;
