import 'package:e_commerce/common/widgets/product_helpers.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final int gridCol;

  const ProductsGrid({
    super.key,
    this.gridCol = 3,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, value, child) {
        final bool onEnd = value.onEnd;
        final bool isLoading = value.isLoading;
        final List<Product> products = value.products;
        final int listLength = _calculateListLength(isLoading, products.length);

        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCol,
                mainAxisExtent: 200,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              itemCount: listLength,
              itemBuilder: (BuildContext context, int index) {
                return _buildGridItem(
                  context,
                  index,
                  products,
                  listLength,
                  isLoading,
                  onEnd,
                  value,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildFooter(context, onEnd, value),
            )
          ],
        );
      },
    );
  }

  // Helper method to calculate the total length of the GridView list
  int _calculateListLength(bool isLoading, int productCount) {
    return isLoading ? productCount + 25 : productCount;
  }

  // Helper method to build individual grid items
  Widget _buildGridItem(
    BuildContext context,
    int index,
    List<Product> products,
    int listLength,
    bool isLoading,
    bool onEnd,
    ProductsProvider value,
  ) {
    if (!isLoading || products.isNotEmpty) {
      final Product product = products[index];
      if (isLoading) {
        return const ProductSkeleton();
      }
      if (index < products.length) {
        return _buildProductCard(product);
      } else {
        return const ProductSkeleton();
      }
      // } else {
      //   return const ProductSkeleton();
      // }
      // } else if (index < listLength - 1) {
      //   return const ProductSkeleton();
      // } else {
      // return Text("all produ")
      // return _buildFooter(context, onEnd, value);
      // }
    } else {
      return const ProductSkeleton();
    }
  }

  // Helper method to build product cards
  Widget _buildProductCard(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ProductCard(
        product: product,
      ),
    );
  }

  // Helper method to build footer buttons
  Widget _buildFooter(
      BuildContext context, bool onEnd, ProductsProvider value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: onEnd
          ? _buildBackToStoresButton(context)
          : _buildLoadMoreButton(value),
    );
  }

  // Back to stores button
  Widget _buildBackToStoresButton(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FilledButton.icon(
        onPressed: () {
          // context.go(StoresPage.path); // Uncomment and implement navigation logic here
        },
        icon: const Icon(Icons.arrow_back),
        label: const Text('المتاجر'),
      ),
    );
  }

  // Load more products button
  Widget _buildLoadMoreButton(ProductsProvider value) {
    return FilledButton(
      onPressed: () {
        value.fetchProductsOnScroll('teke=2');
      },
      child: const Text('اكثر'),
    );
  }
}
