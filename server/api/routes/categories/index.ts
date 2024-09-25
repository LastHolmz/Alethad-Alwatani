import express from "express";

import {
  createCategory,
  deleteCategory,
  getCategories,
  getCategoryById,
  updateCategory,
} from "../../controllers/categories";
import { authenticate, authorize } from "../../middlewares/auth";

const router = express.Router();

router
  .route("/")
  .get(getCategories)
  .post(authenticate, authorize(["admin"], ["active"]), createCategory);
router
  .route("/:id")
  .put(authenticate, authorize(["admin"], ["active"]), updateCategory)
  .delete(authenticate, authorize(["admin"], ["active"]), deleteCategory)
  .get(getCategoryById);

export default router;
