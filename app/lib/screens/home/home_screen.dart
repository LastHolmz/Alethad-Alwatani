import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/widgets/products_grid.dart';

import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/models/category.dart';
import 'package:e_commerce/models/brand.dart';
import 'package:e_commerce/providers/products_provider.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/screens/auth/auth.dart';
import 'package:e_commerce/screens/products/products_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/common/widgets/image_slider.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const List<String> images = [
    "https://plus.unsplash.com/premium_photo-1677526496597-aa0f49053ce2?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1591019479261-1a103585c559?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1617221078682-5f4feaa1f419?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  ];
  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static const String name = "home";
  static const String path = "/";
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  int currentPageIndex = 0;
  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    Future.microtask(
      () => context.read<ProductsProvider>().fetchProducts(),
    );
    Future.microtask(
      () => context.read<CategoriesProvider>().fetchCategories(),
    );
    super.initState();
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
      const Categories(),
      const SizedBox(height: 10),
      const Label(
        title: "افضل مبيعاتنا",
      ),
      const SizedBox(height: 10),
      const ProductsGrid()
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          Future.microtask(
            () => context.read<ProductsProvider>().resetFilters(),
          );
          Future.microtask(
            () => context.read<CategoriesProvider>().fetchCategories(),
          );
        },
        child: Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                key: const PageStorageKey("/home"),
                actions: [
                  IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu_outlined),
                  ),
                ],

                leadingWidth: 0,
                leading: const SizedBox.shrink(),
                title: Consumer<UserProvider>(builder: (context, value, child) {
                  final _isLoading = value.isLoading;
                  final _user = value.user;
                  return _isLoading
                      ? const Text("جاري التحميل")
                      : _user == null
                          ? TextButton.icon(
                              onPressed: () {
                                context.go(Auth.path);
                              },
                              icon: const Text("تسجيل الدخول"),
                              label: Transform.rotate(
                                angle: pi,
                                child: const Icon(
                                  Icons.login,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "اهلا, ${_user.fullName}",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'عن ماذا تبحث اليوم ؟',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            );
                }),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CupertinoSearchTextField(
                      onTap: () {
                        context.go(ProductsScreen.path);
                        FocusScope.of(context).unfocus();
                        _controller.clear();
                      },
                      suffixMode: OverlayVisibilityMode.always,
                      suffixIcon: const Icon(CupertinoIcons.search),
                      prefixIcon: _controller.value.text.isEmpty
                          ? const Text('')
                          : const Icon(
                              CupertinoIcons.xmark_circle_fill,
                            ),
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

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (context, value, child) {
        final categories = value.categories;
        final loading = value.isLoading;
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 180,
            crossAxisCount: 3,
          ),
          itemCount: loading ? 4 : categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            if (!loading) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: CategoryCard(
                  category: categories[index],
                ),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(8),
              child: CategorySkeleton(),
            );
          },
        );
      },
    );
  }
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
  const CategoryCard({
    super.key,
    required this.category,
    this.width = 100, // You can set default width
    this.height = 100,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        child: InkWell(
          onTap: () => {},
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: CachedNetworkImage(
                  imageUrl: category.image!,
                  fit: BoxFit.cover,
                  width: width,
                  height: height,
                  placeholder: (context, url) => const Center(
                    child: const Skeleton(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategorySkeleton extends StatelessWidget {
  const CategorySkeleton({
    super.key,
    this.widht = 100,
    this.height = 100,
  });
  final double widht;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Skeleton(
            height: height,
            width: widht,
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Skeleton(height: 10),
          ),
        ],
      ),
    );
  }
}

class BrandCard extends StatelessWidget {
  final Brand brand;
  final double width;
  final double height;
  final double radius;
  const BrandCard({
    super.key,
    required this.brand,
    this.width = 100, // You can set default width
    this.height = 100,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        child: InkWell(
          onTap: () => {},
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: CachedNetworkImage(
                  imageUrl: brand.image!,
                  fit: BoxFit.cover,
                  width: width,
                  height: height,
                  placeholder: (context, url) => const Center(
                    child: const Skeleton(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              // Black overlay with opacity

              // Title on top of the black overlay
              const SizedBox(height: 10),
              Center(
                child: Text(
                  brand.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrandSkeleton extends StatelessWidget {
  const BrandSkeleton({
    super.key,
    this.widht = 100,
    this.height = 100,
  });
  final double widht;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Skeleton(
            height: height,
            width: widht,
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Skeleton(height: 10),
          ),
        ],
      ),
    );
  }
}
