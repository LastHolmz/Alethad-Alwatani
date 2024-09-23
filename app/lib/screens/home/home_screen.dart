import 'dart:math';

import 'package:e_commerce/common/widgets/brand_helpers.dart';
import 'package:e_commerce/common/widgets/category_helpers.dart';
import 'package:e_commerce/common/widgets/products_grid.dart';

import 'package:e_commerce/providers/products_provider.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/screens/auth/login.dart';

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
    Future.microtask(
      () => context.read<BrandsProvider>().fetchBrands(),
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
      const Label(title: 'البراندات'),
      const SizedBox(height: 10),
      const Brands(),
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
                                context.go(LoginScreen.path);
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
                        context.push(ProductsScreen.path);
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
