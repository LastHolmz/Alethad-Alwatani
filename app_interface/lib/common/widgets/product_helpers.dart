// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/models/user.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/screens/products/%5Bid%5D/product_details.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({
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
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Skeleton(height: 10),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            context.push(
              '/products/${product.id}',
            );
          },
          child: Stack(
            children: [
              // Product Image with Caching
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 100,
                  // You can also add a placeholder or error widget using CachedNetworkImage directly:
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    placeholder: (context, url) => const Center(
                      child: const Skeleton(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Button Overlay in the Bottom Left Corner
              Positioned(
                bottom: 6,
                left: 6,
                child: Consumer<UserProvider>(
                  builder: (context, value, child) {
                    final user = value.user;
                    return ElevatedButton(
                      onPressed: user?.status != UserStatus.active
                          ? null
                          : () {
                              showModalBottomSheet(
                                showDragHandle: false,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => buildAddToCartSheet(
                                  context: context,
                                  product: product,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                          40,
                          40,
                        ), // Minimum size for the button
                        padding: EdgeInsets.zero, // Remove default padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 24,
                        // color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Product Price
        InkWell(
          onTap: () {
            context.push(
              '/products/${product.id}',
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8), // Spacing between image and price
              Consumer<UserProvider>(builder: (context, value, child) {
                final user = value.user;
                final allowedContent = value.renderToStatus(
                  [UserStatus.active],
                  user?.status,
                );
                return Text(
                  '${allowedContent ? product.price : 0} د',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
              const SizedBox(height: 2), // Spacing between price and name
              // Product Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[900],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
