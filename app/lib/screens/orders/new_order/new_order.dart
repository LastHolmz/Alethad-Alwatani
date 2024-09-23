import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/widgets/circle_color.dart';
import 'package:e_commerce/common/widgets/date.dart';
import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/common/widgets/utils.dart';
import 'package:e_commerce/models/cartItem.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/models/orderItem.dart';
import 'package:e_commerce/providers/cart_provider.dart';
import 'package:e_commerce/providers/orders_provider.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});
  static const String name = "new_order";
  static const String path = "/new_order";

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  late Order order;
  bool _isLoading = false;
  @override
  void initState() {
    convertCartToOrder();
    super.initState();
  }

  void convertCartToOrder() {
    setState(() {
      _isLoading = true;
    });
    final cart = context.read<CartProvider>();
    final user = context.read<UserProvider>();
    order = Order(
      id: '',
      totalPrice: cart.pureTotalPrice,
      rest: cart.pureTotalPrice,
      orderItems: returnOrderItemsFromCart(cart.cart),
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      barcode: '',
      userId: user.user?.id,
    );
    setState(() {
      _isLoading = false;
    });
  }

  List<OrderItem> returnOrderItemsFromCart(List<CartItem> cartItems) {
    List<OrderItem> _orderItems = [];
    for (final cartItem in cartItems) {
      _orderItems.add(OrderItem(
        id: '',
        productId: cartItem.productId,
        skuId: cartItem.skuId,
        barcode: cartItem.barcode,
        qty: cartItem.qty,
        title: cartItem.title,
        image: cartItem.image,
        price: cartItem.price,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        hashedColor: cartItem.hashedColor,
        nameOfColor: cartItem.nameOfColor,
        skuImage: cartItem.skuImage,
      ));
    }
    return _orderItems;
  }

  Future<void> crateOrder() async {
    final cart = context.read<CartProvider>();

    setState(() {
      _isLoading = true;
    });
    OrderService orderService = OrderService();
    final newOrder = await orderService.createOrder(order, context);
    setState(() {
      _isLoading = false;
    });

    if (newOrder != null) {
      context.pop();
      cart.clearCart();
      fetchOrders();
    }
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
        onRefresh: () async => convertCartToOrder(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "طلبية جديدة",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 20,
            ),
            child: FilledButton(
              onPressed: () async {
                await crateOrder();
              },
              child: const Text('إنشاء الفاتورة'),
            ),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "معلومات الفاتورة",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TableItem(
                  isLoading: _isLoading,
                  Key: "السعر",
                  Value: '${order.totalPrice} د',
                  ValueStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TableItem(
                  isLoading: _isLoading,
                  Key: "القيمة المدفوعة",
                  Value: '0 د',
                ),
                TableItem(
                  isLoading: _isLoading,
                  Key: "المتبقي",
                  Value: '${order.totalPrice} د',
                ),
                TableItem(
                  isLoading: _isLoading,
                  Key: "تاريخ الإنشاء",
                  Value: formatDate(order.createdAt),
                  divivder: true,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _isLoading ? 10 : order.orderItems.length,
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
                      final OrderItem orderItem = order.orderItems[index];
                      return OrderItemCard(orderItem: orderItem);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TableItem extends StatelessWidget {
  const TableItem({
    super.key,
    required this.Key,
    required this.Value,
    required this.isLoading,
    this.KeyStyle = const TextStyle(),
    this.ValueStyle = const TextStyle(),
    this.divivder = false,
  });
  final String Key;
  final String Value;
  final TextStyle KeyStyle;
  final TextStyle ValueStyle;
  final bool divivder;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                Key,
                style: KeyStyle,
              ),
              isLoading
                  ? const Skeleton(height: 10)
                  : Text(
                      Value,
                      style: ValueStyle,
                      textAlign: TextAlign.right,
                    ),
            ],
          ),
          divivder ? const Divider() : const SizedBox.shrink()
        ],
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({super.key, required this.orderItem});
  final OrderItem orderItem;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: orderItem.skuImage ?? orderItem.image,
          fit: BoxFit.cover,
          width: 60,
          height: 80,
        ),
      ),
      titleAlignment: ListTileTitleAlignment.threeLine,
      title: Text(orderItem.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${orderItem.nameOfColor} | ',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: ColorCircle(
                  color: getColorFromHex(
                    orderItem.hashedColor,
                  ),
                  width: 18,
                  height: 18,
                  radius: 2,
                ),
              )
            ],
          ),
          Text(
            '${orderItem.qty}x',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          )
        ],
      ),
      trailing: Text(
        '${orderItem.calcPrice()} د',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      isThreeLine: true,
    );
  }
}

class CustomTableItem extends StatelessWidget {
  const CustomTableItem({
    super.key,
    required this.Key,
    required this.isLoading,
    this.KeyStyle = const TextStyle(),
    this.divivder = false,
    required this.widget,
  });
  final String Key;
  final TextStyle KeyStyle;
  final bool divivder;
  final bool isLoading;

  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                Key,
                style: KeyStyle,
              ),
              isLoading ? const Skeleton(height: 10) : widget,
            ],
          ),
          divivder ? const Divider() : const SizedBox.shrink()
        ],
      ),
    );
  }
}
