import { Request, Response } from "express";
import prisma from "../../../prisma/db";
import { OrderItem, OrderStatus } from "@prisma/client";
import { generateUniqueBarcodeForOrder } from "../../lib/barcode";
import { BadRequestError } from "../../errors";
import { AuthenticatedRequest } from "../../../types";
import ResponseHelper from "../../middlewares/response.helper";
import updateSkuQuantities from "../../lib/order-utility";

/**
 * Retrieves a list of orders based on the provided query parameters.
 *
 * @param {Request} req - The request object containing query parameters.
 * @param {Response} res - The response object used to send the result back to the client.
 * @returns {Promise<Response>} The list of orders matching the query parameters.
 */
export const getOrders = async (req: Request, res: Response) => {
  console.log("getOrders is called ...");
  try {
    const { userId, barcode }: { userId?: string; barcode?: string } =
      req.query;

    console.log("استدعاء getCategories ...");
    const orders = await prisma.order.findMany({
      where: {
        userId,
        barcode: {
          contains: barcode,
        },
      },
      include: {
        orderItems: true,
        user: true,
      },
      orderBy: {
        createdAt: "desc",
      },
    });
    if (!orders) return res.json({ data: [] });
    return res.json({ data: orders });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي", data: [] });
  }
};

/**
 * Creates a new order with the specified details.
 *
 * @param {Request} req - The request object containing the order details in the body.
 * @param {Response} res - The response object used to send the result back to the client.
 * @returns {Promise<Response>} The created order.
 */
export const createOrder = async (req: Request, res: Response) => {
  try {
    console.log("استدعاء createProducts ...");
    const {
      userId,
      totalPrice,
      rest,
      orderItems,
      status,
      barcode,
    }: {
      userId?: string; // Optional ID of the associated user
      totalPrice: number; // Total price of the order
      rest?: number; // Remaining amount for the order
      orderItems?: OrderItem[]; // Array of order items associated with the order
      status?: OrderStatus;
      barcode?: string;
    } = req.body;

    if (!userId || !orderItems || !totalPrice) {
      return res
        .status(400)
        .json({ message: "لا يمكن انشاء طلب هناك نقص في البيانات" });
    }

    // Generate a unique barcode for the new order.
    let newBarcode = barcode;
    if (!newBarcode || newBarcode.length === 0) {
      newBarcode = await generateUniqueBarcodeForOrder();
    }
    const newOrder = await prisma.order.create({
      data: {
        orderItems: {
          createMany: {
            data: orderItems.map((orderItem) => ({
              productId: orderItem.productId,
              skuId: orderItem.skuId,
              barcode: orderItem.barcode,
              qty: orderItem.qty,
              title: orderItem.title,
              image: orderItem.image,
              skuImage: orderItem.skuImage,
              hashedColor: orderItem.hashedColor,
              price: orderItem.price,
              nameOfColor: orderItem.nameOfColor,
            })),
          },
        },
        barcode: newBarcode,
        rest,
        status,
        user: {
          connect: {
            id: userId,
          },
        },
        totalPrice,
      },
      include: {
        orderItems: true,
      },
    });

    if (!newOrder)
      return res.status(400).json({ message: "فشل إنشاء الطلبية" });

    return res.json({ data: newOrder, message: "تم الإنشاء بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Retrieves a specific order by its ID.
 *
 * @param {Request} req - The request object containing the order ID in the params.
 * @param {Response} res - The response object used to send the result back to the client.
 * @returns {Promise<Response>} The requested order.
 */
export const getOrderById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const order = await prisma.order.findUnique({
      where: { id },
      include: {
        orderItems: true,
        user: true,
      },
    });

    if (!order) {
      return res.status(404).json({ message: "الطلبية غير موجود" });
    }

    return res.json({ data: order });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Updates an existing order with the specified details.
 *
 * @param {Request} req - The request object containing the updated order details in the body.
 * @param {Response} res - The response object used to send the result back to the client.
 * @returns {Promise<Response>} The updated order.
 */
export const updateOrder = async (req: Request, res: Response) => {
  try {
    console.log("استدعاء createProducts ...");
    const {
      totalPrice,
      rest,
      orderItems,
      status,
    }: {
      totalPrice: number; // Total price of the order
      rest?: number; // Remaining amount for the order
      orderItems?: OrderItem[]; // Array of order items associated with the order
      status?: OrderStatus;
    } = req.body;
    const { id } = req.params;

    if (!id || !totalPrice) {
      return res
        .status(400)
        .json({ message: "لا يمكن انشاء طلب هناك نقص في البيانات" });
    }
    let newOrder;
    if (orderItems) {
      newOrder = await prisma.order.update({
        where: {
          id,
        },
        data: {
          orderItems: {
            deleteMany: {}, // Delete all existing order items before creating new ones.
            createMany: {
              data: orderItems
                ? orderItems.map((orderItem) => ({
                    productId: orderItem.productId,
                    skuId: orderItem.skuId,
                    barcode: orderItem.barcode,
                    qty: orderItem.qty,
                    title: orderItem.title,
                    image: orderItem.image,
                    skuImage: orderItem.skuImage,
                    hashedColor: orderItem.hashedColor,
                    price: orderItem.price,
                    nameOfColor: orderItem.nameOfColor,
                  }))
                : [],
            },
          },
          rest,
          status,
          totalPrice,
        },
      });
    } else {
      newOrder = await prisma.order.update({
        where: {
          id,
        },
        data: {
          rest,
          status,
          totalPrice,
        },
      });
    }

    if (!newOrder)
      return res.status(400).json({ message: "فشل إنشاء الطلبية" });
    return res.json({ data: newOrder, message: "تم الإنشاء بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Cancels an order based on the provided order ID and status.
 *
 * @param {Request} req - The request object containing the order ID in the params and status in the body.
 * @param {Response} res - The response object used to send the result back to the client.
 * @returns {Promise<Response>} The updated order with the cancellation status.
 */
export const cancelOrder = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { status }: { status: OrderStatus } = req.body;
    if (!status) {
      return res.json({ message: "يجب توفير الحالة" }).status(400);
    }
    const order = await prisma.order.update({
      where: { id },
      data: {
        status,
      },
    });
    if (!order) return new BadRequestError("فشلت العملية");
    const resMsg = status === "refused" ? "تم رفض الطلبية" : "تم الغاء الطلبية";
    return res.json({ data: order, message: resMsg });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Accepts an order, updates its status, and adjusts SKU quantities accordingly.
 *
 * @param {AuthenticatedRequest} req - The request object containing the authenticated user and order ID in the params.
 * @param {Response} res - The response object used to send the result back to the client.
 * @returns {Promise<Response>} The result of the operation and updated order status.
 */
export const acceptOrder = async (req: AuthenticatedRequest, res: Response) => {
  const responseHelper = new ResponseHelper(res);

  try {
    const { id } = req.params;
    const { status }: { status: OrderStatus } = req.body;

    if (!id) {
      return responseHelper.error("يجب توفير الايدي", 400);
    }
    const order = await prisma.order.findUnique({
      where: { id },
      include: { orderItems: true },
    });
    if (!order) {
      return responseHelper.error("لم يتم ايجاد الطلبية", 404);
    }
    const updatedOrder = await prisma.order.update({
      where: { id },
      data: { status: status ?? "in" },
    });

    const orderItems = order.orderItems;
    if (!orderItems) {
      return responseHelper.success(updatedOrder, "تم قبول الطلبية");
    }

    await updateSkuQuantities(orderItems, "accepte");
    return responseHelper.success(updatedOrder, "تم قبول الطلبية");
  } catch (error) {
    console.log(error);
    return responseHelper.error("حدث خطأ داخلي", 500);
  }
};

/**
 * Handles the return of an order by updating its status and adjusting SKU quantities.
 * If the status indicates a pending, rejected, or refused order, it responds with a success message.
 * Otherwise, it decreases the SKU quantities based on the returned order items.
 *
 * @param {AuthenticatedRequest} req - The Express request object, extended with authentication details.
 * @param {Response} res - The Express response object.
 * @returns {Promise<Response>} The response object with the operation result.
 */
export const returnOrder = async (req: AuthenticatedRequest, res: Response) => {
  const responseHelper = new ResponseHelper(res);
  try {
    const { id } = req.params;
    const { status }: { status: OrderStatus } = req.body;

    if (!status) {
      return res.json({ message: "يجب توفير الحالة" }).status(400);
    }
    if (!id) {
      return responseHelper.error("يجب توفير الايدي", 400);
    }

    const order = await prisma.order.findUnique({
      where: { id },
      include: { orderItems: true },
    });

    if (!order) {
      return responseHelper.error("لم يتم ايجاد الطلبية", 404);
    }

    const updatedOrder = await prisma.order.update({
      where: {
        id,
      },
      data: {
        status,
      },
      include: {
        orderItems: true,
      },
    });

    if (!updatedOrder) {
      return responseHelper.error("فشل تحديث المنتج");
    }

    if (status === "pending" || status === "rejected" || status === "refused") {
      return responseHelper.success("تمت العملية بنجاح");
    }

    const result = await updateSkuQuantities(order.orderItems, "refuse");
    if (!result.success) {
      return responseHelper.error(result.message, 400);
    }

    return res.json({ message: result.message });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

export const deleteOrder = async (req: AuthenticatedRequest, res: Response) => {
  const responseHelper = new ResponseHelper(res);
  try {
    const { id } = req.params;

    if (!id) {
      return responseHelper.error("يجب توفير الايدي", 400);
    }

    const order = await prisma.order.delete({
      where: { id },
    });

    if (!order) {
      return responseHelper.error("لم يتم ايجاد الطلبية", 404);
    }

    return res.json({ message: "تم الحذف بنجاح" }).status(201);
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};
