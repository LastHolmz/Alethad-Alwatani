// import { cn } from "@/lib/utils";
// import { OrderStatus, OrderType } from "@prisma/client";

// export const ParseOrderType = ({ content }: { content: OrderType }) => {
//   return (
//     <div
//       className={cn(
//         "rounded-lg px-4 py-1 w-fit flex-center text-white",
//         content === "clinic" ? " bg-pink-500" : " bg-sky-500"
//       )}
//     >
//       {exportOrderType({ content })}
//     </div>
//   );
// };
// export const ParseOrderStatus = ({ content }: { content: OrderStatus }) => {
//   return (
//     <div
//       className={cn(
//         "rounded-lg px-4 py-1 w-fit flex-center text-white",
//         content === "accepted" && "bg-sky-500",
//         content === "done" && "bg-green-500",
//         content === "pending" && "bg-orange-300",
//         content === "rejected" && "bg-red-500",
//         content === "processing" && "bg-orange-500"
//       )}
//     >
//       {exportOrderStatus({ content })}
//     </div>
//   );
// };

// export const exportOrderType = ({ content }: { content: OrderType }) => {
//   return content === "clinic" ? "طبي" : "رياضي";
// };
// export const exportOrderStatus = ({ content }: { content: OrderStatus }) => {
//   switch (content) {
//     case "accepted":
//       return "تم القبول";
//     case "done":
//       return "تم";
//     case "pending":
//       return "معلقة";
//     case "processing":
//       return "تحت المعالجة";
//     case "rejected":
//       return "مرفوضة";
//     default:
//       return "معلقة";
//   }
// };
