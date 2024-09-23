import 'package:e_commerce/common/widgets/brand_helpers.dart';
import 'package:e_commerce/models/category.dart';
import 'package:e_commerce/screens/home/home_screen.dart';
import 'package:e_commerce/services/categoy_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.id});
  final String? id;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Category? _category;
  CategoryService _categoryService = CategoryService();
  bool _isLoading = false;

  @override
  void initState() {
    getCategoryInfo();
    super.initState();
  }

  void getCategoryInfo() async {
    setState(() {
      _isLoading = true;
    });
    final result = await _categoryService.getCategory(widget.id ?? "");
    _category = result;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: _isLoading
              ? const Text("جاري التحميل ...")
              : _category != null
                  ? Text("${_category?.title}")
                  : const Text("غير متاح"),
        ),
        body: _isLoading
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 180,
                ),
                itemCount: 22,
                itemBuilder: (BuildContext context, int index) {
                  return const BrandSkeleton();
                },
              )
            : _category == null
                ? Center(
                    child: Column(
                      children: [
                        const Text("هذا الصنف غير متاح"),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            context.go(HomeScreen.path);
                          },
                          child: const Text("الرئيسية"),
                        )
                      ],
                    ),
                  )
                : _category!.brands!.isEmpty
                    ? const Center(child: Text("لا يوجد براندات"))
                    : CustomScrollView(
                        // physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          SliverGrid.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 180,
                              crossAxisCount: 3,
                            ),
                            itemCount:
                                _isLoading ? 12 : _category!.brands!.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (!_isLoading) {
                                final brand = _category?.brands![index];
                                return BrandCard(brand: brand!);
                              }

                              return const BrandSkeleton();
                            },
                          ),
                        ],
                      ),
      ),
    );
  }
}
