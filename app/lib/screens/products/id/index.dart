import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/widgets/circle_color.dart';
import 'package:e_commerce/common/widgets/image_slider.dart';
import 'package:e_commerce/common/widgets/utils.dart';
import 'package:e_commerce/models/cartItem.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/models/sku.dart';
import 'package:e_commerce/providers/cart/index.dart';
import 'package:e_commerce/services/products/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.id});
  final String? id;
  static const String name = "home";
  static const String path = "/";

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Product? product;
  final ProductService productService = ProductService();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    if (widget.id != null && widget.id!.isNotEmpty) {
      setState(() {
        loading = true;
      });

      final result = await productService.getProductById(widget.id!);
      setState(() {
        product = result;
        loading = false;
      });
    }
  }

  List<String> _setImages(List<Sku>? skus, String image) {
    List<String> images = [];
    if (skus != null) {
      for (final sku in skus) {
        if (sku.image != null) {
          images.add(sku.image!);
        }
      }
    }
    images.add(image);
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator.adaptive(
        onRefresh: () async => _fetchProduct(),
        child: Scaffold(
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FilledButton(
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: false,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => product != null
                      ? buildAddToCartSheet(context: context, product: product!)
                      : Container(), // Prevent showing bottom sheet if product is null
                );
              },
              child: const Text("اضف إلى السلة"),
            ),
          ),
          appBar: AppBar(
            title: loading
                ? const Text("تحميل ... ")
                : Text(product?.title ?? "لا يوجد منتج"),
            centerTitle: true,
          ),
          body: product == null && !loading
              ? const Center(
                  child: Text('يرجى التأكد من اتصالك بالإنترنت'),
                )
              : loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverList.list(
                          children: [
                            ImageSlider(
                              images: _setImages(
                                product?.skus,
                                product?.image ?? "",
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 220,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    product?.title ?? "",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'الألوان المتوفرة',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing:
                                        8.0, // Adjust spacing between items
                                    runSpacing:
                                        4.0, // Adjust spacing between lines
                                    children: product?.skus
                                            ?.map((sku) => ColorCircle(
                                                  width: 24,
                                                  height: 24,
                                                  color: getColorFromHex(
                                                      sku.hashedColor),
                                                ))
                                            .toList() ??
                                        [],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(product?.description ?? ""),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'صور المنتج',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GridView.builder(
                                    addAutomaticKeepAlives: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemCount: _setImages(
                                      product?.skus,
                                      product?.image ?? "",
                                    ).length,
                                    itemBuilder: (context, index) {
                                      final String image = _setImages(
                                        product?.skus,
                                        product?.image ?? "",
                                      )[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 8,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.error,
                                            ),
                                            imageUrl: image,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

Widget makeDismissible(
        {required Widget child, required BuildContext context}) =>
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pop(),
      child: GestureDetector(
        onTap: () => {},
        child: child,
      ),
    );

Widget buildAddToCartSheet(
        {required BuildContext context, required Product product}) =>
    makeDismissible(
      context: context,
      child: skusSheetContent(
        product: product,
      ),
    );

class skusSheetContent extends StatefulWidget {
  const skusSheetContent({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  State<skusSheetContent> createState() => _skusSheetContentState();
}

class _skusSheetContentState extends State<skusSheetContent> {
  List<CartItem> createCartItemsForProduct(List<Sku>? skus) {
    List<CartItem> cart = [];
    if (skus == null || skus.isEmpty) {
      return cart;
    }
    for (final sku in skus) {
      final CartItem cartItem = CartItem(
        productId: widget.product.id,
        skuId: sku.id,
        qty: 0,
        barcode: widget.product.barcode,
        title: widget.product.title,
        image: widget.product.image,
        price: widget.product.price,
        maxQty: sku.qty,
        nameOfColor: sku.nameOfColor,
        hashedColor: sku.hashedColor,
        skuImage: sku.image,
      );
      cart.add(cartItem);
    }
    return cart;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 1,
      minChildSize: 0.5,
      snapAnimationDuration: const Duration(microseconds: 100),
      builder: (_, controller) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Consumer<CartProvider>(
          builder: (context, value, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('إضافة إلى السلة'),
                  centerTitle: true,
                  leading: null,
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: createCartItemsForProduct(widget.product.skus)
                            .isEmpty
                        ? const Center(
                            child: Text('لا توجد منتجات'),
                          )
                        : ListView.builder(
                            controller: controller,
                            shrinkWrap: true,
                            itemCount:
                                createCartItemsForProduct(widget.product.skus)
                                    .length,
                            itemBuilder: (context, index) {
                              final cartItem = createCartItemsForProduct(
                                  widget.product.skus)[index];

                              return Consumer<CartProvider>(
                                builder: (context, value, child) {
                                  final cart = value;
                                  final currentCartItem = cart
                                      .returnCurrentCartItem(cartItem.skuId);
                                  return ListTile(
                                    isThreeLine: true,
                                    contentPadding: const EdgeInsets.all(0),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          'المتوفر: ${cartItem.qty} |  ${cartItem.nameOfColor} | ',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: ColorCircle(
                                            color: getColorFromHex(
                                              cartItem.hashedColor,
                                            ),
                                            width: 18,
                                            height: 18,
                                            radius: 2,
                                          ),
                                        )
                                      ],
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            cartItem.skuImage ?? cartItem.image,
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 80,
                                      ),
                                    ),
                                    titleAlignment:
                                        ListTileTitleAlignment.threeLine,
                                    title: Text(cartItem.title),
                                    trailing: ControllProductQty(
                                      cartItem: cartItem,
                                      cart: cart,
                                      currentCartItem: currentCartItem,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
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

class ControllProductQty extends StatelessWidget {
  const ControllProductQty({
    super.key,
    required this.cartItem,
    required this.cart,
    required this.currentCartItem,
  });

  final CartItem cartItem;
  final CartProvider cart;
  final CartItem? currentCartItem;

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
      child: currentCartItem == null
          ? FilledButton(
              onPressed: () {
                cartItem.incrementQty(cartItem.maxQty);
                cart.addNewToCart(cartItem);
              },
              child: const Text("أضف"))
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: cartItem.qty >= cartItem.maxQty || cartItem.overQty
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
                    "${currentCartItem?.qty}",
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    cart.removeOne(cartItem.skuId, null);
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
