import express from "express";
import {
  createBrand,
  deleteBrand,
  getBrandById,
  getBrands,
  updateBrand,
} from "../../controllers/brands";

const router = express.Router();

router.route("/").get(getBrands).post(createBrand);
router.route("/:id").put(updateBrand).delete(deleteBrand).get(getBrandById);

export default router;
