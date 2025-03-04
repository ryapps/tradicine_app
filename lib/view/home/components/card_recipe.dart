import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/label_text.dart';
import 'package:tradicine_app/models/recipe/recipe_model.dart';
import 'package:tradicine_app/models/category/product_categories.dart';
import 'package:tradicine_app/services/category_service.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final CategoryService categoryService = CategoryService();

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(1, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian gambar di atas
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: CachedNetworkImage(
              imageUrl: widget.recipe.imgRecipe,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.red),
            ),
          ),
          // Bagian teks di bawah gambar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Resep
                LabelText(
                  text: widget.recipe.name,
                ),
                const SizedBox(height: 4),
                // Info durasi
                Row(
                  children: [
                    Icon(Icons.timer,
                        size: 18, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 4),
                    BodyText(
                      text: widget.recipe.duration,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Info porsi
                Row(
                  children: [
                    Icon(Icons.person,
                        size: 18, color: Theme.of(context).primaryColor),
                    SizedBox(width: 4),
                    BodyText(
                      text: '1 sajian',
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Info kategori menggunakan FutureBuilder
                FutureBuilder<Category?>(
                  future:
                      categoryService.getCategoryById(widget.recipe.categoryId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading...",
                          style: TextStyle(fontSize: 12, color: Colors.grey));
                    } else if (snapshot.hasError) {
                      return const Text("Error",
                          style: TextStyle(fontSize: 12, color: Colors.grey));
                    } else {
                      final category = snapshot.data;
                      return Row(
                        children: [
                          Icon(Icons.category_outlined,
                              size: 18, color: Theme.of(context).primaryColor),
                          SizedBox(width: 4),
                          BodyText(
                            text: category != null ? category.name : "Unknown",
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
