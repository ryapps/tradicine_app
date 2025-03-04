import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tradicine_app/components/loading/shimmer_loading.dart';
import 'package:tradicine_app/components/text/label_text.dart';
import 'package:tradicine_app/models/category/product_categories.dart';
import 'package:tradicine_app/services/category_service.dart';
import 'package:tradicine_app/view/home/components/recommend_product.dart';

class RecommendProductSection extends StatefulWidget {
  @override
  _RecommendProductSectionState createState() =>
      _RecommendProductSectionState();
}

class _RecommendProductSectionState extends State<RecommendProductSection>
    with SingleTickerProviderStateMixin {
  String? selectedCategoryId;
  String? selectedCategoryImg;
  final CategoryService _categoryService = CategoryService();

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _positionAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _categoryService.getAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: ShimmerLoading(
            width: double.infinity,
            height: 250,
          ));
        }
        if (snapshot.hasError) {
          return const Center(
              child: Text("Terjadi kesalahan saat memuat kategori"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Kategori tidak tersedia"));
        }

        List<Category> categories = snapshot.data!;
        selectedCategoryId ??= categories.first.id;
        selectedCategoryImg ??= categories.first.img;

        _animationController.forward();

        return Container(
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _opacityAnimation,
                            child: SlideTransition(
                              position: _positionAnimation,
                              child: child,
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: selectedCategoryImg!,
                          width: 155,
                          height: 155,
                          placeholder: (context, url) => Container(
                            width: 155,
                            height: 155,
                            color: Colors
                                .grey[300], // Placeholder sebelum gambar muncul
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.broken_image),
                        )),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(15),
                          dropdownColor: Colors.white,
                          value: selectedCategoryId,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: Theme.of(context).primaryColor),
                          items: categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: LabelText(
                                text: category.name,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryId = newValue;
                              selectedCategoryImg = categories
                                  .firstWhere(
                                      (category) => category.id == newValue)
                                  .img;
                              _animationController.reset();
                              _animationController.forward();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              if (selectedCategoryId != null)
                Expanded(
                  child: SizedBox(
                      height: 240,
                      child: RecommendProduct(categoryId: selectedCategoryId!)),
                ),
            ],
          ),
        );
      },
    );
  }
}
