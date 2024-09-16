import express from "express";

import {
  createCategory,
  deleteCategory,
  getCategories,
  getCategoryById,
  updateCategory,
} from "../../controllers/categories";

const router = express.Router();

router.route("/").get(getCategories).post(createCategory);
router
  .route("/:id")
  .put(updateCategory)
  .delete(deleteCategory)
  .get(getCategoryById);

export default router;
