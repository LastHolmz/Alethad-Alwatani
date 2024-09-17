import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/widgets/product_helpers.dart';
import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/models/category.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/providers/products/index.dart';
import 'package:e_commerce/services/products/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/common/widgets/image_slider.dart';
import 'package:e_commerce/constants/global_variables.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const List<String> images = [
    'https://images.unsplash.com/photo-1713105227378-91e790dfe4f0?q=80&w=1376&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1713042451651-42cecb8a2e19?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1713148312902-bd3105e11b2a?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ];
  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static const String name = "home";
  static const String path = "/";
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  // bool _isGrid = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  int currentPageIndex = 0;
  final ProductService productServices = ProductService();
  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
    Future.microtask(
      () => context.read<ProductsProvider>().fetchProducts(),
    );
    Future.microtask(
      () => context.read<CategoriesProvider>().fetchCategories(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final content = [
      const SizedBox(height: 20),
      ImageSlider(
        images: HomeScreen.images,
        width: MediaQuery.of(context).size.width,
        height: 120,
      ),
      const SizedBox(height: 10),
      const Label(title: 'الأصناف'),
      const SizedBox(height: 10),
      Consumer<CategoriesProvider>(
        builder: (context, value, child) {
          final categories = value.categories;
          final _loading = value.isLoading;

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: _loading ? 4 : categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final Category category = categories[index];
              return Padding(
                padding: const EdgeInsets.all(8),
                child: CategoryCard(
                  loading: _loading,
                  category: category,
                ),
              );
            },
          );
        },
      ),
      const SizedBox(height: 10),
      const Label(
        title: "افضل مبيعاتنا",
      ),
      const SizedBox(height: 10),
      ProductsGrid()
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          Future.microtask(
            () => context.read<ProductsProvider>().fetchProducts(),
          );
          Future.microtask(
            () => context.read<CategoriesProvider>().fetchCategories(),
          );
        },
        child: Scaffold(
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            // indicatorColor: Colors.amber,
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'الرئيسية',
              ),
              NavigationDestination(
                icon: Badge(child: Icon(Icons.description_outlined)),
                label: 'الفواتير',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person),
                icon: Icon(Icons.person_3_outlined),
                label: 'البروفايل',
              ),
              NavigationDestination(
                icon: Badge(
                  label: Text('2'),
                  child: Icon(Icons.shopping_cart_outlined),
                ),
                label: 'السلة',
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                key: const PageStorageKey("/home"),
                actions: [
                  Image.asset(
                    'assets/logo.png',
                    alignment: Alignment.centerLeft,
                    width: 200,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                ],
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "اهلا, محمد",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text('عن ماذا تبحث اليوم ؟', style: TextStyle(fontSize: 16))
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CupertinoSearchTextField(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _controller.clear();
                      },
                      suffixMode: OverlayVisibilityMode.always,
                      suffixIcon: const Icon(CupertinoIcons.search),
                      prefixIcon: _controller.value.text.isEmpty
                          ? const Text('')
                          : const Icon(CupertinoIcons.xmark_circle_fill),
                      controller: _controller,
                      placeholder: 'ابحث هنا',
                    ),
                  ),
                ),
                // onStretchTrigger: () async => print('object'),
                floating: true,
                toolbarHeight: 60,
                // pinned: true,
              ),
              SliverList.builder(
                addAutomaticKeepAlives: true,
                itemCount: content.length,
                itemBuilder: (context, index) => content[index],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Label extends StatelessWidget {
  const Label({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final double width;
  final double height;
  final double radius;
  final bool loading;
  const CategoryCard({
    super.key,
    required this.category,
    this.width = 150, // You can set default width
    this.height = 150,
    this.radius = 20,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: loading
            ? const Skeleton()
            : InkWell(
                onTap: () => {},
                child: Stack(
                  children: [
                    // Cached background image
                    CachedNetworkImage(
                      imageUrl: category.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    // Black overlay with opacity
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black
                          .withOpacity(0.60), // Black with 60% opacity
                    ),
                    // Title on top of the black overlay
                    Center(
                      child: Text(
                        category.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Material(
                      color: Colors
                          .transparent, // Transparent so you see underlying layers
                      child: InkWell(
                        onTap: () {}, // Trigger callback on tap
                        splashColor:
                            Colors.white.withOpacity(0.3), // Ripple color
                        highlightColor:
                            Colors.white.withOpacity(0.1), // Highlight on tap
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.longPressEvent = false,
  });

  final Product product;
  final bool longPressEvent;

  IconData? get add_circle_outline_outlined => null;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onLongPress: () {
          // if (!longPressEvent) return;
          // context.push('${StoresPage.path}/${product.storeId}');
        },
        borderRadius: BorderRadius.circular(
          GlobalVariables.defaultPadding,
        ),
        onTap: () {
          context.push(
            '/products/${product.id}',
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  GlobalVariables.defaultPadding,
                ),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // const SizedBox(height: 6),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${product.price} د',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_outlined,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, value, child) {
        final bool onEnd = value.onEnd;
        final bool isLoading = value.isLoading;
        final List<Product> products = value.products;
        final int listLength = _calculateListLength(isLoading, products.length);

        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: listLength,
              itemBuilder: (BuildContext context, int index) {
                return _buildGridItem(
                  context,
                  index,
                  products,
                  listLength,
                  isLoading,
                  onEnd,
                  value,
                );
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildFooter(context, onEnd, value))
          ],
        );
      },
    );
  }

  // Helper method to calculate the total length of the GridView list
  int _calculateListLength(bool isLoading, int productCount) {
    return isLoading ? productCount + 25 : productCount;
  }

  // Helper method to build individual grid items
  Widget _buildGridItem(
    BuildContext context,
    int index,
    List<Product> products,
    int listLength,
    bool isLoading,
    bool onEnd,
    ProductsProvider value,
  ) {
    if (!isLoading || products.isNotEmpty) {
      final Product product = products[index];
      if (index < products.length) {
        return _buildProductCard(product);
      } else if (isLoading) {
        return const ProductSkeleton();
      } else {
        return const ProductSkeleton();
      }
      // } else {
      //   return const ProductSkeleton();
      // }
      // } else if (index < listLength - 1) {
      //   return const ProductSkeleton();
      // } else {
      // return Text("all produ")
      // return _buildFooter(context, onEnd, value);
      // }
    } else {
      return const ProductSkeleton();
    }
  }

  // Helper method to build product cards
  Widget _buildProductCard(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ProductCard(product: product),
    );
  }

  // Helper method to build footer buttons
  Widget _buildFooter(
      BuildContext context, bool onEnd, ProductsProvider value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: onEnd
          ? _buildBackToStoresButton(context)
          : _buildLoadMoreButton(value),
    );
  }

  // Back to stores button
  Widget _buildBackToStoresButton(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FilledButton.icon(
        onPressed: () {
          // context.go(StoresPage.path); // Uncomment and implement navigation logic here
        },
        icon: const Icon(Icons.arrow_back),
        label: const Text('المتاجر'),
      ),
    );
  }

  // Load more products button
  Widget _buildLoadMoreButton(ProductsProvider value) {
    return FilledButton(
      onPressed: () {
        value.fetchProductsOnScroll('teke=2');
      },
      child: const Text('اكثر'),
    );
  }
}
