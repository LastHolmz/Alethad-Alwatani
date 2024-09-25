import express from "express";
import {
  createBrand,
  deleteBrand,
  getBrandById,
  getBrands,
  updateBrand,
} from "../../controllers/brands";
import { authorize } from "../../middlewares/auth";

const router = express.Router();

router
  .route("/")
  .get(getBrands)
  .post(authorize(["admin"], ["active"]), createBrand);
router
  .route("/:id")
  .put(updateBrand)
  .delete(authorize(["admin"], ["active"]), deleteBrand)
  .get(getBrandById);

export default router;
