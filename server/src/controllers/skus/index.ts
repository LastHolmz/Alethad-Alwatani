import { Request, Response } from "express";
import prisma from "../../../prisma/db";

/**
 * Create a new SKU for a product.
 * @route POST /api/v1/products/{productId}/sku
 * @group Products - Operations about products
 * @param {string} productId.path.required - Product ID
 * @param {object} sku.body - SKU details
 * @returns {object} 200 - The created SKU
 * @returns {Error} 400 - Bad request
 * @returns {Error} 500 - Internal server error
 */
export const createNewSku = async (req: Request, res: Response) => {
  try {
    const { productId } = req.params;
    const {
      qty,
      hashedColor,
      nameOfColor,
      size,
      image,
    }: {
      qty: number;
      hashedColor?: string;
      nameOfColor?: string;
      size: string;
      image?: string;
    } = req.body;

    const sku = await prisma.sku.create({
      data: {
        qty,
        hashedColor,
        nameOfColor,
        size,
        image,
        Product: {
          connect: { id: productId },
        },
      },
    });

    return res.json({ data: sku, message: "تم إنشاء SKU بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Update an SKU by ID.
 * @route PUT /api/v1/sku/{skuId}
 * @group Products - Operations about products
 * @param {string} skuId.path.required - SKU ID
 * @param {object} sku.body - Updated SKU details
 * @returns {object} 200 - The updated SKU
 * @returns {Error} 400 - Bad request
 * @returns {Error} 404 - SKU not found
 * @returns {Error} 500 - Internal server error
 */
export const updateSku = async (req: Request, res: Response) => {
  try {
    const { skuId } = req.params;
    const {
      qty,
      hashedColor,
      nameOfColor,
      size,
      image,
    }: {
      qty?: number;
      hashedColor?: string;
      nameOfColor?: string;
      size?: string;
      image?: string;
    } = req.body;

    const sku = await prisma.sku.update({
      where: { id: skuId },
      data: {
        qty,
        hashedColor,
        nameOfColor,
        size,
        image,
      },
    });

    if (!sku) return res.status(404).json({ message: "SKU غير موجود" });

    return res.json({ data: sku, message: "تم التحديث بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Delete an SKU by ID.
 * @route DELETE /api/v1/sku/{skuId}
 * @group Products - Operations about products
 * @param {string} skuId.path.required - SKU ID
 * @returns {object} 200 - Confirmation of deletion
 * @returns {Error} 404 - SKU not found
 * @returns {Error} 500 - Internal server error
 */
export const deleteSku = async (req: Request, res: Response) => {
  try {
    const { skuId } = req.params;

    const sku = await prisma.sku.delete({
      where: { id: skuId },
    });

    return res.json({ data: sku, message: "تم الحذف بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Get all SKUs.
 * @route GET /api/v1/skus
 * @group SKUs - Operations about SKUs
 * @returns {object} 200 - An array of SKUs
 * @returns {Error} 500 - Internal server error
 */
export const getSkus = async (req: Request, res: Response) => {
  try {
    console.log("استدعاء getSkus ...");
    const skus = await prisma.sku.findMany();
    if (!skus) return res.json({ data: [] });
    return res.json({ data: skus });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};
