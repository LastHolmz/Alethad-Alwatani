import { Request, Response } from "express";
import prisma from "../../../prisma/db";

export const getCategories = async (req: Request, res: Response) => {
  try {
    const { brands }: { brands: boolean } = req.body;

    console.log("استدعاء getCategories ...");
    const categories = await prisma.category.findMany({
      include: {
        brands,
      },
    });
    if (!categories) return res.json({ data: [] });
    return res.json({ data: categories });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

export const createCategory = async (req: Request, res: Response) => {
  try {
    console.log("استدعاء createProducts ...");
    const {
      title,
      main,
      image,
    }: {
      title: string;
      image?: string;
      main?: boolean;
    } = req.body;
    console.log(req.body);
    if (!title) {
      return res.status(400).json({ message: "يجب ملء كل الحقول" });
    }
    const category = await prisma.category.create({
      data: {
        title,
        main,
        image,
      },
    });

    if (!category) return res.status(400).json({ message: "فشل إنشاء الصنف" });
    return res.json({ data: category, message: "تم الإنشاء بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

export const getCategoryById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const category = await prisma.category.findUnique({
      where: { id },
      include: {
        brands: true,
      },
    });

    if (!category) {
      return res.status(404).json({ message: "الصنف غير موجود" });
    }

    return res.json({ data: category });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

export const updateCategory = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const {
      main,
      title,
      image,
    }: {
      title?: string;
      image?: string;
      main?: boolean;
    } = req.body;

    const category = await prisma.category.update({
      where: { id },
      data: {
        title,
        main,
        image,
      },
    });

    if (!category) return res.status(404).json({ message: "الصنف غير موجود" });

    return res.json({ data: category, message: "تم التحديث بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

export const deleteCategory = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const product = await prisma.category.delete({
      where: { id },
    });

    return res.json({ data: product, message: "تم الحذف بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};
