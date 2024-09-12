import express from "express";
import {
  getProducts,
  createProduct,
  updateProduct,
  deleteProduct,
  getProductById,
} from "../../controllers/products";

const router = express.Router();

router.route("/").get(getProducts).post(createProduct);
router
  .route("/:id")
  .put(updateProduct)
  .delete(deleteProduct)
  .get(getProductById);

export default router;
