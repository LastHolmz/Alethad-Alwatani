import 'package:e_commerce/common/widgets/circle_color.dart';
import 'package:e_commerce/common/widgets/product_helpers.dart';
import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/common/widgets/utils.dart';
import 'package:e_commerce/models/cartItem.dart';
import 'package:e_commerce/models/user.dart';
import 'package:e_commerce/providers/cart_provider.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/screens/orders/new_order/new_order.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:go_router/go_router.dart';
// import 'package:kraken_app/common/widgets/ship_to_btn.dart';
// import 'package:kraken_app/common/widgets/skeleton.dart';
// import 'package:kraken_app/features/cart/screens/payment.dart';
// import 'package:kraken_app/models/cartItem.dart';
// import 'package:kraken_app/models/sku.dart';
// import 'package:kraken_app/provider/location_provider.dart';
import 'package:provider/provider.dart';

// import 'package:kraken_app/provider/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const String path = '/cart';
  static const String name = 'cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      compareCart();
    });
  }

  void compareCart() async {
    await context.read<CartProvider>().compareCart();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'السلة',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          // centerTitle: true,
        ),
        body: Consumer<CartProvider>(
          builder: (context, cartValues, _) {
            final List<CartItem?> cart = cartValues.cart;
            final bool isloading = cartValues.isloading;
            return isloading
                ? ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return const ProductSkeleton();
                    },
                  )
                : cart.isEmpty
                    ? SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                context.push(
                                  '/products',
                                );
                              },
                              child: Icon(
                                CupertinoIcons.cart_badge_plus,
                                size: 96,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Text(
                              'السلة فارغة',
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              child: const Text('تصفح المنتجات'),
                              onPressed: () {
                                context.push(
                                  '/products',
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        height: MediaQuery.of(context).size.height,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ListView.builder(
                              itemCount: cartValues.cart.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(4),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final cartItem = cartValues.cart[index];
                                double price = cartItem.price * cartItem.qty;
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: CustomCartItemListTile(
                                        cartItem: cartItem,
                                        price: price,
                                        cart: cartValues,
                                      ),
                                    ),
                                    // const Divider(),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            Column(
                              children: [
                                const Text(
                                  "الإجمالي",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text("${cartValues.pureTotalPrice} دينار",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      );
          },
        ),
        bottomNavigationBar: Consumer<CartProvider>(
          builder: (context, cartValues, _) {
            final bool valid = cartValues.isCartValid;
            final List<CartItem> cart = cartValues.cart;

            return cart.isEmpty
                ? const Text('')
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 20),
                    child: Consumer<UserProvider>(
                      builder: (context, value, child) =>
                          value.user?.status == UserStatus.active
                              ? FilledButton(
                                  onPressed: !valid
                                      ? null
                                      : () {
                                          // context.push('/login');

                                          if (!valid) {
                                            return;
                                          }
                                          cartValues.compareCart();
                                          if (!valid) {
                                            return;
                                          }

                                          context.push(NewOrderScreen.path);
                                        },
                                  child: const Text('إكمال الطلب'),
                                )
                              : const FilledButton(
                                  onPressed: null,
                                  child: Text(
                                    'إكمال الطلب',
                                  ),
                                ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class CustomCartItemListTile extends StatelessWidget {
  const CustomCartItemListTile({
    required this.cartItem,
    required this.price,
    required this.cart,
    super.key,
  });
  final CartItem cartItem;
  final CartProvider cart;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: cartItem.skuImage ?? cartItem.image,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(cartItem.nameOfColor ?? ""),
                      const Text(' / '),
                      ColorCircle(
                        color: getColorFromHex(cartItem.hashedColor),
                        width: 18,
                        height: 18,
                        radius: 2,
                      ),
                    ],
                  ),
                  //  width: MediaQuery.of(context).size.width / 3,
                  const SizedBox(height: 10),
                  ProductQtyController(cartItem: cartItem, cart: cart)
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$price د',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cart.deleteCompletely(cartItem.skuId, null);
                  },
                  icon: const Icon(Icons.delete),
                )
              ],
            ),
          ],
        ),
        cartItem.overQty
            ? Text(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
                "تجاوزت الحد الأقصى للكمية المسموح بها. الرجاء تقليل الكمية.",
              )
            : const SizedBox(),
        cartItem.notVaildAnyMore
            ? Text(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
                "هذا المنتج لم يعد متاحا. الرجاء حذف المنتج",
              )
            : const SizedBox(),
      ],
    );
  }
}

class CartItemListTileSkeleton extends StatelessWidget {
  const CartItemListTileSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Skeleton(
        width: 70,
        height: 150,
        borederRadius: 8,
      ),
      title:
          Skeleton(height: 10, width: MediaQuery.of(context).size.width / 1.5),
      subtitle: Column(
        children: [
          Row(
            children: [
              Skeleton(
                height: 10,
                width: MediaQuery.of(context).size.width / 4,
              ),
              const Text(' / '),
              Skeleton(
                height: 10,
                width: MediaQuery.of(context).size.width / 4,
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.replay,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Skeleton(
                height: 10,
                width: MediaQuery.of(context).size.width / 5,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.replay,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
      isThreeLine: true,
    );
  }
}

class OrderInfo extends StatelessWidget {
  const OrderInfo({
    super.key,
    required this.cart,
  });

  final CartProvider cart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'الإجمالي',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 10),
        Text('${cart.qty} قطعة'),
        const Divider(),
        // const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'سعر جميع القطع',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 20,
              ),
            ),
            Text(
              '${cart.pureTotalPrice} د',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        // const SizedBox(height: 10),
        const Divider(),
        //
        // Consumer<CityProvider>(builder: ((context, value, child) {
        //   final city = value.getCityById(
        //     context.watch<LocationsProvider>().location?.cityId ?? "",
        //   );

        //   return Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       const Text(
        //         'سعر التوصيل',
        //         style: TextStyle(
        //           fontWeight: FontWeight.w300,
        //           fontSize: 20,
        //         ),
        //       ),
        //       if (city == null)
        //         const Text("المدينة لم تعد متاحة")
        //       else
        //         Text(
        //           '${city.price} د',
        //           style: const TextStyle(fontSize: 18),
        //         )
        //     ],
        //   );
        // })),

        const Divider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'سعر الفاتورة',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 20,
                fontFamily: 'Arabic',
              ),
            ),
            /*   Consumer<CityProvider>(builder: ((context, value, child) {
              final city = value.getCityById(
                context.watch<LocationsProvider>().location?.cityId ?? "",
              );

              return city == null
                  ? Text(
                      '${cart.totalPrice} + المدينة غير متوفرة',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    )
                  : Text(
                      '${cart.totalPrice + city.price} د',
                      style: const TextStyle(fontSize: 18),
                    );
            })),
         */
          ],
        ),
      ],
    );
  }
}

class ProductQtyController extends StatelessWidget {
  const ProductQtyController({
    super.key,
    required this.cartItem,
    required this.cart,
  });

  final CartItem cartItem;
  final CartProvider cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: !cart.isCartValid
                ? null
                : cartItem.qty >= cartItem.maxQty || cartItem.overQty
                    ? null
                    : () {
                        cart.addQtyToExistedCartItem(
                          cartItem.skuId,
                          null,
                          context,
                        );
                      },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary.withOpacity(
                    cartItem.qty >= cartItem.maxQty || cartItem.overQty
                        ? 0.4
                        : 1,
                  ),
            ),
          ),
          Center(
            child: Text(
              cartItem.qty.toString(),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              cart.removeOne(cartItem.skuId, cartItem.maxQty);
            },
            icon: Icon(
              Icons.remove,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
