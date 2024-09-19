// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/products/id/index.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/constants/global_variables.dart';
import 'package:go_router/go_router.dart';

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
                      onPressed: () {
                        showModalBottomSheet(
                          showDragHandle: false,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => buildAddToCartSheet(
                              context: context, product: product),
                        );
                      },
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

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({
    super.key,
    this.widht = 150,
    this.height = 150,
  });
  final double widht;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Skeleton(
        height: height,
        width: widht,
      ),
    );
  }
}
