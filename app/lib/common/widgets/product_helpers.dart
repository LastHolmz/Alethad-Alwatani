// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/constants/global_variables.dart';
// import 'package:go_router/go_router.dart';

// class Product {
//   final String title;
//   final String image;
//   final double price;

//   Product({required this.title, required this.image, required this.price});
// }

/// product card with listTile
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    this.widht = 80,
    this.height = 80,
    this.longPressEvent = false,
    required this.product,
  });
  final double widht;
  final double height;
  // set this to true if you want to navigate to store's product;
  final bool longPressEvent;

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        child: InkWell(
          // onLongPress: () {
          // if (!longPressEvent) return;
          // context.push('${StoresPage.path}/${product.storeId}');
          // },
          onTap: () {
            // context.push('/products/${product.id}');
          },
          hoverColor: Theme.of(context).colorScheme.onPrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  GlobalVariables.defalutRaduis,
                ),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  width: widht,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          '${product.price} د',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({
    super.key,
    this.widht = 80,
    this.height = 80,
  });
  final double widht;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: height,
        child: Row(
          // textDirection: TextDirection.rtl,
          children: [
            Skeleton(
              height: height,
              width: widht,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Skeleton(
                    height: 7,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Skeleton(
                    height: 7,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  Skeleton(
                    height: 7,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
