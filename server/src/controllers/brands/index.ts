import { Request, Response } from "express";
import prisma from "../../../prisma/db";

export const getBrands = async (req: Request, res: Response) => {
  try {
    console.log("استدعاء getBrands ...");
    const { categoryId }: { categoryId?: string } = req.query;
    let brands;
    if (categoryId) {
      brands = await prisma.brand.findMany({
        where: {
          categoryIDs: {
            has: categoryId,
          },
        },
      });
    } else {
      brands = await prisma.brand.findMany({});
    }
    if (!brands) return res.json({ data: [] });
    return res.json({ data: brands });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

export const createBrand = async (req: Request, res: Response) => {
  try {
    console.log("استدعاء createBrand ...");
    const {
      title,
      image,
      categoryIDs,
    }: {
      title: string;
      image?: string;
      categoryIDs?: string[];
    } = req.body;
    if (!title) {
      return res.status(400).json({ message: "يجب ملء كل الحقول" });
    }
    const brand = await prisma.brand.create({
      data: {
        title,
        image,
        categories: {
          connect: categoryIDs?.map((id) => ({ id: id })),
        },
      },
    });
    if (!brand) return res.status(400).json({ message: "فشل إنشاء البراند" });
    return res.json({ data: brand, message: "تم الإنشاء بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

export const getBrandById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const brand = await prisma.brand.findUnique({
      where: { id },
    });

    if (!brand) {
      return res.status(404).json({ message: "البراند غير موجود" });
    }
    return res.json({ data: brand });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

export const updateBrand = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const {
      title,
      image,
    }: {
      title?: string;
      image?: string;
    } = req.body;

    const category = await prisma.brand.update({
      where: { id },
      data: {
        title,
        image,
      },
    });

    if (!category)
      return res.status(404).json({ message: "البراند غير موجود" });

    return res.json({ data: category, message: "تم التحديث بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};

export const deleteBrand = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const brand = await prisma.brand.delete({
      where: { id },
    });

    return res.json({ data: brand, message: "تم الحذف بنجاح" });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error, message: "حدث خطأ داخلي" });
  }
};
