import 'package:e_commerce/common/widgets/date.dart';
import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/models/orderItem.dart';
import 'package:e_commerce/providers/orders_provider.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/screens/orders/new_order/new_order.dart';
import 'package:e_commerce/screens/orders/orders_screen.dart';
import 'package:e_commerce/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, this.id});
  final String? id;
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late String? id;
  Order? order = null;
  OrderService _orderService = OrderService();
  bool _isLoading = false;

  @override
  void initState() {
    id = widget.id;
    fetchOrder();
    super.initState();
  }

  void fetchOrder() async {
    _isLoading = true;
    final result = await _orderService.getOrder(id);
    order = result;
    _isLoading = false;
    setState(() {});
  }

  void cancleOrder() async {
    _isLoading = true;
    await _orderService.cancleOrder(id, context);
    _isLoading = false;

    setState(() {});

    fetchOrder();

    fetchOrders();

    context.pop();
  }

  void fetchOrders([String? barcode]) async {
    final order = context.read<OrdersProvider>();
    final user = context.read<UserProvider>();
    await order.fetchOrders(
      'userId=${user.user?.id}&${barcode != null ? 'barcode=$barcode' : ''}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: SelectableText(
              order == null ? "جاري التحميل ..." : "${order!.barcode}",
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  // cancleOrder();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'الغاء الفاتورة',
                          textAlign: TextAlign.end,
                        ),
                        content: const Text(
                          "لن تتمكن من استرجاع هذه الفاتورة ثانية",
                          textAlign: TextAlign.end,
                        ),
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  cancleOrder();
                                  context.pop();
                                },
                                child: const Text("نعم"),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text("لا"),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete,
                ),
              )
            ],
          ),
          body: order == null
              ? _isLoading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Center(
                      child: Column(
                      children: [
                        const Text("هذا الطلب لم يعد متاح"),
                        TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text("العودة"))
                      ],
                    ))
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "معلومات الفاتورة",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      CustomTableItem(
                        isLoading: _isLoading,
                        Key: "الحالة",
                        widget: OrderStatusWidget(status: order!.status),
                      ),
                      TableItem(
                        isLoading: _isLoading,
                        Key: "السعر",
                        Value: '${order!.totalPrice} د',
                        ValueStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TableItem(
                        isLoading: _isLoading,
                        Key: "القيمة المدفوعة",
                        Value: '${order!.totalPrice - order!.rest} د',
                      ),
                      TableItem(
                        isLoading: _isLoading,
                        Key: "المتبقي",
                        Value: '${order!.rest} د',
                      ),
                      TableItem(
                        isLoading: _isLoading,
                        Key: "تاريخ الإنشاء",
                        Value: formatDate(order!.createdAt),
                        divivder: true,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _isLoading ? 10 : order!.orderItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (_isLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Skeleton(
                                  width: 60,
                                  height: 80,
                                ),
                                title: Skeleton(height: 10),
                                subtitle: Skeleton(
                                  height: 8,
                                ),
                              ),
                            );
                          } else {
                            final OrderItem orderItem =
                                order!.orderItems[index];
                            return OrderItemCard(orderItem: orderItem);
                          }
                        },
                      ),
                    ],
                  ),
                ),
        ));
  }
}
