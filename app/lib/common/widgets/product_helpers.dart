// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/models/user.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/screens/products/id/index.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// class ProductCard extends StatelessWidget {
//   const ProductCardTest({
//     super.key,
//     required this.product,
//     this.longPressEvent = false,
//   });

//   final Product product;
//   final bool longPressEvent;

//   IconData? get add_circle_outline_outlined => null;

//   @override
//   Widget build(BuildContext context) {
//     return Card.outlined(
//       shape: RoundedRectangleBorder(
//         side: BorderSide(
//           color: Theme.of(context).colorScheme.outlineVariant,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: InkWell(
//         onLongPress: () {
//           // if (!longPressEvent) return;
//           // context.push('${StoresPage.path}/${product.storeId}');
//         },
//         borderRadius: BorderRadius.circular(
//           GlobalVariables.defaultPadding,
//         ),
//         onTap: () {
//           context.push(
//             '/products/${product.id}',
//           );
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               flex: 2,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(
//                   GlobalVariables.defaultPadding,
//                 ),
//                 child: CachedNetworkImage(
//                   imageUrl: product.image,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             // const SizedBox(height: 6),
//             Expanded(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           product.title,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           '${product.price} د',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                     IconButton.filled(
//                       onPressed: () {
//                         showModalBottomSheet(
//                           showDragHandle: false,
//                           backgroundColor: Colors.transparent,
//                           isScrollControlled: true,
//                           context: context,
//                           builder: (context) => buildAddToCartSheet(
//                             context: context,
//                             product: product,
//                           ),
//                         );
//                       },
//                       icon: const Icon(
//                         Icons.add_outlined,
//                         color: Colors.white,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

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

// import 'package:flutter/material.dart';

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
                      child: CircularProgressIndicator(),
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
                child: FilledButton(
                  onPressed: () {
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
                    minimumSize:
                        const Size(40, 40), // Minimum size for the button
                    padding: EdgeInsets.zero, // Remove default padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Icon(Icons.add, size: 20, color: Colors.white),
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
