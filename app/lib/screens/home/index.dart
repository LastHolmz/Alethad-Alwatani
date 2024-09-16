import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/widgets/product_helpers.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/providers/products/index.dart';
import 'package:e_commerce/services/products/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/common/widgets/image_slider.dart';
// import 'package:e_commerce/common/widgets/product_helpers.dart';
import 'package:e_commerce/constants/global_variables.dart';
// import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const List<String> images = [
    'https://images.unsplash.com/photo-1713105227378-91e790dfe4f0?q=80&w=1376&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1713042451651-42cecb8a2e19?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1713148312902-bd3105e11b2a?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ];
  static List<Category> categories = [
    Category(
      image:
          'https://plus.unsplash.com/premium_photo-1677526496597-aa0f49053ce2?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      name: "ميك اب",
    ),
    Category(
      image:
          'https://images.unsplash.com/photo-1480264104733-84fb0b925be3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      name: "رياضة",
    ),
    Category(
      image:
          'https://plus.unsplash.com/premium_photo-1671377387797-8d3307a546a6?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      name: "طبخ",
    ),
    Category(
      image:
          'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      name: "تخييم",
    ),
    Category(
      image:
          'https://plus.unsplash.com/premium_photo-1664304106292-ef7e34f74dc0?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      name: "بناء الاجسام",
    ),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
      GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: HomeScreen.categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final Category category = HomeScreen.categories[index];
          return CategoryWidget(category: category);
        },
      ),
      const SizedBox(height: 10),
      const Label(
        title: "افضل مبيعاتنا",
      ),
      const SizedBox(height: 10),
      Consumer<ProductsProvider>(
        builder: (context, value, child) {
          final bool onEnd = value.onEnd;
          final bool isLoading = value.isLoading;
          final List<Product> products = value.products;
          final int listLength =
              isLoading ? products.length + 25 : products.length + 1;

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),

            // itemCount: isLoading ? 25 : products.length,
            itemCount: listLength,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (BuildContext context, int index) {
              if (!isLoading || products.isNotEmpty) {
                if (index < products.length) {
                  final Product product = products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ResponsiveProductGridCard(product: product),
                  );
                } else {
                  if (index < listLength - 1) {
                    return const ProductSkeleton();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: onEnd
                          ? Directionality(
                              textDirection: TextDirection.ltr,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // context.go(StoresPage.path);
                                },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('المتاجر'),
                              ),
                            )
                          : OutlinedButton(
                              onPressed: () {
                                value.fetchProductsOnScroll('teke=2');
                              },
                              child: const Text('اكثر'),
                            ),
                    );
                  }
                }
              } else {
                return const ProductSkeleton();
              }
            },
          );
        },
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.category,
  });
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(GlobalVariables.defalutRaduis / 2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.black87,
              width: 200,
              height: 200,
              child: CachedNetworkImage(
                alignment: Alignment.center,
                width: 200,
                height: 100,
                fit: BoxFit.fitHeight,
                imageUrl: category.image,
              ),
            ),
            Text(
              category.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class ResponsiveProductGridCard extends StatelessWidget {
  const ResponsiveProductGridCard({
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
          // context.push('/products/${product.id}');
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

class Category {
  final String name;
  final String image;

  Category({required this.name, required this.image});
}
