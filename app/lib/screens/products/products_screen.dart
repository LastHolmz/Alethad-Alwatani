import 'package:e_commerce/common/widgets/search_products_grid.dart';
import 'package:e_commerce/providers/orders_provider.dart';
import 'package:e_commerce/providers/products_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  static const String name = "products";
  static const String path = "/products";

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    Future.microtask(
      () => context.read<SearchProvider>().fetchProducts(),
    );
    super.initState();
  }

  void fetchProducts([String? params]) async {
    final provider = context.read<SearchProvider>();
    await provider.fetchProducts('?${params != null ? 'title=$params' : ''}');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final content = [
      const SearchProductGrid(
        gridCol: 3,
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator.adaptive(
        onRefresh: () async => {fetchProducts()},
        child: Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                key: const PageStorageKey("/orders"),
                title: const Text(
                  "كل المنتجات",
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
                        fetchProducts(value);
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
                    // final isLoading = value.isLoading;
                    return orders.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: TextButton(
                                child: const Text("لا يوجد"),
                                onPressed: () async => {},
                              ),
                            ),
                          )
                        : SliverList.builder(
                            itemCount: content.length,
                            itemBuilder: (context, index) => content[index],
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

  @override
  bool get wantKeepAlive => true;
}
