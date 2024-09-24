import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/common/widgets/utils.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/providers/orders_provider.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/utility/calc_bills.dart';
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
      child: Scaffold(
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            fetchOrders();
          },
          child: CustomScrollView(
            // physics: const BouncingScrollPhysics(),
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
              Consumer<OrdersProvider>(
                builder: (context, value, child) {
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    sliver: SliverList.list(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            infoCard(
                              bgColor: Colors.blue.shade300,
                              icon: Icon(
                                Icons.account_balance_outlined,
                                size: 36,
                                color: Colors.white,
                              ),
                              price: getSumOfOrderPrices(value.orders),
                              lable: "جميع المعاملات",
                            ),
                            SizedBox(width: 20),
                            infoCard(
                              bgColor: Colors.red.shade300,
                              icon: Icon(
                                Icons.money_off_outlined,
                                size: 36,
                                color: Colors.white,
                              ),
                              price: getDebt(value.orders),
                              lable: "قيمة المديونية",
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        // Divider(),
                        Text(
                          'عدد الفواتير: ${value.orders.length} فاتورة',
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  );
                },
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

class infoCard extends StatelessWidget {
  const infoCard({
    super.key,
    required this.price,
    required this.bgColor,
    required this.icon,
    required this.lable,
  });
  final double price;
  final Color bgColor;
  final Icon icon;
  final String lable;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            // height: 86,
            // width: 86,
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Text(
                  "$price د",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
            lable,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Card.outlined(
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
            color: Colors.redAccent.shade400,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "غير خالص", // Display status in Arabic
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      width: 90,
      decoration: BoxDecoration(
        color: Colors.green.shade400,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "خالص", // Display status in Arabic
        style: TextStyle(
          color: Colors.white, // Text color
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
Color getOrderStatusTextColor(OrderStatus status) {
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

Color getOrderStatusBgColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Colors.orangeAccent.shade400; // Light orange for pending
    case OrderStatus.inProgress:
      return Colors.blueAccent.shade400; // Light blue for in progress
    case OrderStatus.done:
      return Colors.greenAccent.shade400; // Light green for done
    case OrderStatus.rejected:
      return Colors.redAccent.shade400; // Light red for rejected
    case OrderStatus.refused:
      return Colors.red.shade500; // Darker red for refused
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
          color: Colors.white, // Text color
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
