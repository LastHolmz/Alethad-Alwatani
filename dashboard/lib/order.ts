export const getOrderQty = (order: Order) => {
  let qty = 0;
  if (order.orderItems == null || !order.orderItems) {
    return qty;
  }
  for (let index = 0; index < order.orderItems.length; index++) {
    const orderItem = order.orderItems[index];
    qty += orderItem.qty;
  }
  return qty;
};
