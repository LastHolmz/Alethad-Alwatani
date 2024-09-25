import express from "express";
import {
  getProducts,
  createProduct,
  updateProduct,
  deleteProduct,
  getProductById,
} from "../../controllers/products";
import { authorize } from "../../middlewares/auth";

const router = express.Router();

router
  .route("/")
  .get(getProducts)
  .post(authorize(["admin"]), createProduct);
router
  .route("/:id")
  .put(authorize(["admin"]), updateProduct)
  .delete(authorize(["admin"]), deleteProduct)
  .get(getProductById);

export default router;
