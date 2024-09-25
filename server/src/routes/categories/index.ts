import express from "express";

import {
  createCategory,
  deleteCategory,
  getCategories,
  getCategoryById,
  updateCategory,
} from "../../controllers/categories";
import { authorize } from "../../middlewares/auth";

const router = express.Router();

router
  .route("/")
  .get(getCategories)
  .post(authorize(["admin"], ["active"]), createCategory);
router
  .route("/:id")
  .put(authorize(["admin"], ["active"]), updateCategory)
  .delete(authorize(["admin"], ["active"]), deleteCategory)
  .get(getCategoryById);

export default router;
