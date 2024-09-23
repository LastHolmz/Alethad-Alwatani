// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:e_commerce/common/widgets/product_helpers.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/services/product_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import 'package:kraken_app/common/service/product.dart';
// import 'package:kraken_app/common/widgets/product_helpers.dart';
// import 'package:kraken_app/models/product.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, this.title, this.brandId, this.categoryId});
  static const String path = '/products';
  static const String name = 'products';
  final String? title;
  final String? brandId;
  final String? categoryId;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _products = [];
  bool isLoading = false;
  String? _search_query;
  late String? brandId;
  late String? categoryId;

  final TextEditingController _serachController = TextEditingController();
  @override
  void initState() {
    brandId = widget.brandId;
    categoryId = widget.categoryId;
    super.initState();
    fetchProducts();
  }

  @override
  void dispose() {
    _serachController.dispose();
    super.dispose();
  }

  Future refresh() async {
    setState(() {
      _products.clear();
    });
  }

  void fetchProducts() async {
    ProductService productService = ProductService();
    setState(() {
      isLoading = true;
    });

    List<Product> products = await productService.getProducts(
      '?${_search_query != null ? "title=$_search_query" : ""}${brandId != null ? "&brandId=${brandId}" : ""}&${categoryId != null ? "&categoryId=${categoryId}" : ""}',
    );
    setState(() {
      _products = products;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: CupertinoSearchTextField(
                controller: _serachController,
                suffixMode: OverlayVisibilityMode.always,
                suffixIcon: const Icon(CupertinoIcons.search),
                prefixIcon: _serachController.value.text.isEmpty
                    ? const Text('')
                    : GestureDetector(
                        child: const Icon(CupertinoIcons.xmark_circle_fill),
                        onTap: () {
                          setState(() {
                            _search_query = '';
                          });
                          _serachController.clear();
                        },
                      ),
                autocorrect: true,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _search_query = _serachController.text;
                  });
                  fetchProducts();
                },
                placeholder: "البحث باسم المنتج",
              ),
              toolbarHeight: 60,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            SliverList.list(
              children: [
                const Divider(),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'نتائج البحث : ${_products.length}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              brandId = null;
                            });
                            fetchProducts();
                          },
                          icon: const Icon(
                            Icons.filter_alt_off,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isLoading
                    ? GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 180,
                          crossAxisCount: 3,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return const Column(
                            children: [
                              ProductSkeleton(),
                            ],
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 200,
                            crossAxisCount: 3,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: isLoading
                              ? _products.length + 1
                              : _products.length,
                          itemBuilder: (context, index) {
                            if (index < _products.length) {
                              Product product = _products[index];
                              return Column(
                                children: [
                                  ProductCard(
                                    product: product,
                                  ),
                                  // const Divider(),
                                ],
                              );
                            } else {
                              return const Align(
                                alignment: Alignment.center,
                                child: ProductSkeleton(),
                              );
                            }
                          },
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
