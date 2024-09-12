import { Request, Response } from "express";
import { BadRequestError } from "../../errors";
import prisma from "../../../prisma/db";
import { generateUniqueBarcodeForProduct } from "../../lib/barcode";
import { Sku } from "@prisma/client";

/**
 * Get all products.
 * @route GET /api/v1/products
 * @group Products - Operations about products
 * @returns {object} 200 - An array of products
 * @returns {Error} 500 - Internal server error
 */
export const getProducts = async (req: Request, res: Response) => {
  try {
    console.log("استدعاء getProducts ...");
    const products = await prisma.product.findMany({
      include: {
        brands: true,
        categories: true,
        skus: true,
      },
    });
    if (!products) return res.json({ data: [] });
    return res.json({ data: products });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Create a new product.
 * @route POST /api/v1/products
 * @group Products - Operations about products
 * @param {object} product.body - Product details
 * @returns {object} 200 - The created product
 * @returns {Error} 400 - Bad request
 * @returns {Error} 500 - Internal server error
 */
export const createProduct = async (req: Request, res: Response) => {
  try {
    console.log("استدعاء createProducts ...");
    const {
      price,
      title,
      description,
      originalPrice,
      skus,
      brands,
      categories,
    }: {
      price: number;
      originalPrice?: number;
      title: string;
      description?: string;
      skus: Sku[];
      brands?: string[];
      categories?: string[];
    } = req.body;

    if (!title || !price || !skus) {
      return res.status(400).json({ message: "يجب ملء كل الحقول" });
    }

    const barcode = await generateUniqueBarcodeForProduct();
    const product = await prisma.product.create({
      data: {
        barcode,
        price,
        title,
        description,
        originalPrice,
        image:
          "https://images.unsplash.com/photo-1720048169970-9c651cf17ccd?q=80&w=1914&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        skus: {
          createMany: {
            data: skus,
          },
        },
        brands: {
          connect: brands?.map((brand) => ({ id: brand })),
        },
        categories: {
          connect: categories?.map((category) => ({ id: category })),
        },
      },
      include: {
        skus: true,
        brands: true,
        categories: true,
      },
    });

    if (!product) return res.status(400).json({ message: "فشل إنشاء المنتج" });
    return res.json({ data: product, message: "تم الإنشاء بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Get a product by its ID.
 * @route GET /api/v1/products/{id}
 * @param {string} id.path.required - The ID of the product
 * @group Products - Operations about products
 * @returns {object} 200 - The product details
 * @returns {Error} 404 - Product not found
 * @returns {Error} 500 - Internal server error
 */
export const getProductById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    // Find the product by ID and include related SKUs, brands, and categories
    const product = await prisma.product.findUnique({
      where: { id },
      include: {
        skus: true,
        brands: true,
        categories: true,
      },
    });

    if (!product) {
      return res.status(404).json({ message: "المنتج غير موجود" });
    }

    return res.json({ data: product });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Update a product by ID.
 * @route PUT /api/v1/products/{id}
 * @group Products - Operations about products
 * @param {string} id.path.required - Product ID
 * @param {object} product.body - Updated product details
 * @returns {object} 200 - The updated product
 * @returns {Error} 400 - Bad request
 * @returns {Error} 404 - Product not found
 * @returns {Error} 500 - Internal server error
 */
export const updateProduct = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const {
      price,
      title,
      description,
      originalPrice,
      skus,
      brands,
      categories,
    }: {
      price?: number;
      title?: string;
      description?: string;
      originalPrice?: number;
      skus?: Sku[];
      brands?: string[];
      categories?: string[];
    } = req.body;

    const product = await prisma.product.update({
      where: { id },
      data: {
        price,
        title,
        description,
        originalPrice,
        skus: {
          deleteMany: {}, // Delete all existing SKUs (modify as needed)
          createMany: {
            data: skus || [],
          },
        },
        brands: {
          set: brands?.map((brand) => ({ id: brand })) || [],
        },
        categories: {
          set: categories?.map((category) => ({ id: category })) || [],
        },
      },
      include: {
        skus: true,
        brands: true,
        categories: true,
      },
    });

    if (!product) return res.status(404).json({ message: "المنتج غير موجود" });

    return res.json({ data: product, message: "تم التحديث بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

/**
 * Delete a product by ID.
 * @route DELETE /api/v1/products/{id}
 * @group Products - Operations about products
 * @param {string} id.path.required - Product ID
 * @returns {object} 200 - Confirmation of deletion
 * @returns {Error} 404 - Product not found
 * @returns {Error} 500 - Internal server error
 */
export const deleteProduct = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const product = await prisma.product.delete({
      where: { id },
    });

    return res.json({ data: product, message: "تم الحذف بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};
