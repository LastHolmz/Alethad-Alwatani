import 'package:e_commerce/common/widgets/image_slider.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/models/sku.dart';
import 'package:e_commerce/services/products/index.dart';
import 'package:flutter/material.dart';

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
      });
      setState(() {
        loading = false;
      });
    }
  }

  List<String> _setImages(List<Sku>? skus, String image) {
    List<String> images = [];
    if (skus != null) {
      for (final sku in skus) {
        if (sku.image != null) {
          images = [...images, sku.image!];
        }
      }
    }
    images = [...images, image];
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator.adaptive(
        onRefresh: () async => _fetchProduct(),
        child: Scaffold(
          appBar: AppBar(
            title:
                loading ? const Text("تحميل ... ") : Text(product?.title ?? ""),
            centerTitle: true,
          ),
          body: loading && product == null
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
                          // isLoading: true,
                        ),
                        Text(
                          product?.title ?? "",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(product?.description ?? ""),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
