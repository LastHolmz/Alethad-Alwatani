import prisma from "../../prisma/db";

const generateUniqueBarcodeForProduct = async (): Promise<string> => {
  let barcode: string;
  let existingProduct: any;

  do {
    // Generate a random barcode or use any other logic to generate a unique code
    barcode = Math.random().toString().substring(2, 12);

    // Check if the barcode already exists in the database
    existingProduct = await prisma.product.findUnique({
      where: { barcode },
    });

    // Continue generating a new barcode if the current one already exists
  } while (existingProduct);

  return barcode;
};

export { generateUniqueBarcodeForProduct };
