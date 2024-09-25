import express from "express";
import {
  acceptOrder,
  cancelOrder,
  createOrder,
  deleteOrder,
  getOrderById,
  getOrders,
  returnOrder,
  updateOrder,
  updateOrderMoney,
} from "../../controllers/order";
import { authorize } from "../../middlewares/auth";

const router = express.Router();

router.route("/").get(getOrders).post(createOrder);
router.route("/:id").get(getOrderById).put(updateOrder).delete(deleteOrder);
router.route("/:id/cancel").put(cancelOrder);
router.route("/:id/accept").put(authorize(["admin"], ["active"]), acceptOrder);
router.route("/:id/return").put(authorize(["admin"], ["active"]), returnOrder);
router
  .route("/:id/update-money")
  .put(authorize(["admin"], ["active"]), updateOrderMoney);

export default router;
