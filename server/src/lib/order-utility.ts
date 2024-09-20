import { OrderItem, Prisma } from "@prisma/client";
import prisma from "../../prisma/db";

/**
 * Updates the quantity of SKUs based on the provided order items and mode.
 * If the mode is "refuse", the quantities will be increased.
 * If the mode is "accepte", the quantities will be decreased.
 * If any update fails, all changes are reverted to their original quantities.
 *
 * @param {OrderItem[]} items - An array of order items containing SKU information and quantities.
 * @param {"accepte" | "refuse"} mode - The mode of operation. "accepte" will decrement SKU quantities, "refuse" will increment them.
 * @returns {Promise<{ success: boolean, message: string }>} A promise resolving to an object indicating the operation status.
 */
const updateSkuQuantitiesWithUndo = async (
  items: OrderItem[],
  mode: "accepte" | "refuse"
): Promise<{ success: boolean; message: string }> => {
  const originalQuantities: Record<string, number> = {}; // Store original quantities to revert on failure

  try {
    // Begin transaction
    await prisma.$transaction(async (prisma) => {
      for (const item of items) {
        const sku = await prisma.sku.findUnique({
          where: { id: item.skuId },
          select: { qty: true }, // Fetch current quantity
        });

        if (!sku) {
          throw new Error(`SKU with id ${item.skuId} not found.`);
        }

        // Store the original quantity
        originalQuantities[item.skuId] = sku.qty;

        // Check condition for decrement mode
        if (mode === "accepte" && sku.qty < item.qty) {
          throw new Error(
            `Insufficient quantity for SKU with id ${item.skuId}.`
          );
        }

        // Update SKU based on mode
        if (mode === "refuse") {
          await prisma.sku.update({
            where: { id: item.skuId },
            data: {
              qty: {
                increment: item.qty, // Increase SKU quantity
              },
            },
          });
        } else if (mode === "accepte") {
          await prisma.sku.update({
            where: { id: item.skuId },
            data: {
              qty: {
                decrement: item.qty, // Decrease SKU quantity
              },
            },
          });
        }
      }
    });

    // Return success message if all updates are successful
    return {
      success: true,
      message: "All SKUs updated successfully.",
    };
  } catch (error) {
    console.error("Update failed: ", error);

    // Undo all changes if there's an error
    for (const item of items) {
      try {
        await prisma.sku.update({
          where: { id: item.skuId },
          data: {
            qty: {
              set: originalQuantities[item.skuId], // Revert to original quantity
            },
          },
        });
      } catch (undoError) {
        console.error(`Failed to revert SKU ${item.skuId}: `, undoError);
      }
    }

    return {
      success: false,
      message:
        "An error occurred during SKU update. All changes have been reverted.",
    };
  }
};

export default updateSkuQuantitiesWithUndo;
