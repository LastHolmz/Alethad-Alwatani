import express from "express";
import {
  getProducts,
  createProduct,
  updateProduct,
  deleteProduct,
  getProductById,
} from "../../controllers/products";
import { authenticate, authorize } from "../../middlewares/auth";

const router = express.Router();

router
  .route("/")
  .get(getProducts)
  .post(authenticate, authorize(["admin"]), createProduct);
router
  .route("/:id")
  .put(authenticate, authorize(["admin"]), updateProduct)
  .delete(authenticate, authorize(["admin"]), deleteProduct)
  .get(getProductById);

export default router;
