import 'package:flutter/material.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/subtitle_text.dart';
import 'package:tradicine_app/models/category/product_categories.dart';
import 'package:tradicine_app/services/category_service.dart';

class RenderCategory extends StatefulWidget {
  RenderCategory(
      {super.key, required this.categoryId, this.isIcon, this.isSubtitle});
  final String categoryId;
  bool? isIcon;
  bool? isSubtitle;
  @override
  State<RenderCategory> createState() => _RenderCategoryState();
}

class _RenderCategoryState extends State<RenderCategory> {
  CategoryService categoryService = CategoryService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category?>(
      future: categoryService.getCategoryById(widget.categoryId),
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
              widget.isIcon == true 
                ?
                  Icon(Icons.category_outlined,
                      size: 18, color: Theme.of(context).primaryColor) : Container(),
              const
              SizedBox(width: 4),
              widget.isSubtitle == true
                  ? SubtitleText(
                      text: category != null ? category.name : "Unknown",
                      color: Theme.of(context).colorScheme.surface,

                    )
                  : BodyText(
                      text: category != null ? category.name : "Unknown",
                      color: Theme.of(context).colorScheme.surface,
                    ),
            ],
          );
        }
      },
    );
  }
}
