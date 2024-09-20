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
} from "../../controllers/order";

const router = express.Router();

router.route("/").get(getOrders).post(createOrder);
router.route("/:id").get(getOrderById).put(updateOrder).delete(deleteOrder);
router.route("/:id/cancel").put(cancelOrder);
router.route("/:id/accept").put(acceptOrder);
router.route("/:id/return").put(returnOrder);

export default router;
