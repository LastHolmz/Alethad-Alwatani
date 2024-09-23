import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/widgets/skeleton.dart';
import 'package:e_commerce/models/category.dart';
import 'package:e_commerce/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
          onTap: () => {context.push('/categories/${category.id}')},
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
          itemCount: loading ? 9 : categories.length,
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
