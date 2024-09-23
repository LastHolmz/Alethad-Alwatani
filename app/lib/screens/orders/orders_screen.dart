import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/common/widgets/utils.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/providers/orders_provider.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/utility/clip_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const String name = "orders";
  static const String path = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async => fetchOrders());
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
      child: RefreshIndicator.adaptive(
        onRefresh: () async => fetchOrders(),
        child: Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                key: const PageStorageKey("/orders"),
                title: const Text(
                  "الفواتير",
                  style: TextStyle(color: Colors.white),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CupertinoSearchTextField(
                      onSubmitted: (value) async {
                        if (value == " ") {
                          return;
                        }
                        fetchOrders(value);
                      },
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            12,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      suffixMode: OverlayVisibilityMode.always,
                      suffixIcon: const Icon(
                        CupertinoIcons.search,
                        color: Colors.white,
                      ),
                      prefixIcon: const SizedBox.shrink(),
                      placeholder: 'ابحث هنا',
                      placeholderStyle: const TextStyle(color: Colors.white),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                floating: true,
                toolbarHeight: 60,
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                sliver: Consumer<OrdersProvider>(
                  builder: (context, value, child) {
                    final orders = value.orders;
                    final isLoading = value.isLoading;
                    return orders.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: TextButton(
                                child: const Text("لا يوجد"),
                                onPressed: () async => fetchOrders(),
                              ),
                            ),
                          )
                        : SliverList.builder(
                            itemCount: isLoading ? 10 : orders.length,
                            itemBuilder: (context, index) {
                              if (isLoading) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Skeleton(height: 60),
                                );
                              } else {
                                final order = orders[index];
                                return OrderCard(order: order);
                              }
                            },
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: InkWell(
        onTap: () {
          context.push('/orders/${order.id}');
        },
        onLongPress: () {
          copyToClipboard(order.barcode);
          showSnackBar(context, "تم نسخ الباركود");
        },
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          title: Text(order.barcode),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Debt(debt: order.rest)),
              const SizedBox(height: 8),
              Flexible(child: OrderStatusWidget(status: order.status)),
            ],
          ),
          subtitle: Text(
            '${order.totalPrice} دينار',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class Debt extends StatelessWidget {
  const Debt({super.key, required this.debt});
  final double debt;

  @override
  Widget build(BuildContext context) {
    if (debt > 0) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          width: 90,
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "غير خالص", // Display status in Arabic
            style: TextStyle(
              color: Colors.red.shade900, // Text color
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      width: 90,
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "خالص", // Display status in Arabic
        style: TextStyle(
          color: Colors.green.shade900, // Text color
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Helper function to map OrderStatus to Arabic text
String getOrderStatusInArabic(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'قيد الانتظار';
    case OrderStatus.inProgress:
      return 'قيد التنفيذ';
    case OrderStatus.done:
      return 'مكتملة';
    case OrderStatus.rejected:
      return 'تم الإلغاء';
    case OrderStatus.refused:
      return 'تم الرفض';
    default:
      return 'غير معروف';
  }
}

// Helper function to determine background color based on OrderStatus
Color getOrderStatusBgColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Colors.orangeAccent.shade100; // Light orange for pending
    case OrderStatus.inProgress:
      return Colors.blueAccent.shade100; // Light blue for in progress
    case OrderStatus.done:
      return Colors.greenAccent.shade100; // Light green for done
    case OrderStatus.rejected:
      return Colors.redAccent.shade100; // Light red for rejected
    case OrderStatus.refused:
      return Colors.red.shade300; // Darker red for refused
    default:
      return Colors.grey.shade300; // Fallback grey for unknown status
  }
}

Color getOrderStatusTextColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Colors.orangeAccent.shade700; // Light orange for pending
    case OrderStatus.inProgress:
      return Colors.blueAccent.shade700; // Light blue for in progress
    case OrderStatus.done:
      return Colors.greenAccent.shade700; // Light green for done
    case OrderStatus.rejected:
      return Colors.redAccent.shade700; // Light red for rejected
    case OrderStatus.refused:
      return Colors.red.shade900; // Darker red for refused
    default:
      return Colors.grey.shade500; // Fallback grey for unknown status
  }
}

// Widget to display the status with background and color
class OrderStatusWidget extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusWidget({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      width: 90,
      decoration: BoxDecoration(
        color: getOrderStatusBgColor(
          status,
        ), // Get background color based on status
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        getOrderStatusInArabic(status), // Display status in Arabic
        style: TextStyle(
          color: getOrderStatusTextColor(status), // Text color
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
