import express from "express";
import {
  createBrand,
  deleteBrand,
  getBrandById,
  getBrands,
  updateBrand,
} from "../../controllers/brands";
import { authenticate, authorize } from "../../middlewares/auth";

const router = express.Router();

router
  .route("/")
  .get(getBrands)
  .post(authenticate, authorize(["admin"], ["active"]), createBrand);
router
  .route("/:id")
  .put(authenticate, authorize(["admin"], ["active"]), updateBrand)
  .delete(authenticate, authorize(["admin"], ["active"]), deleteBrand)
  .get(getBrandById);

export default router;
