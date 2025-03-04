import 'package:flutter/material.dart';
import 'package:tradicine_app/components/loading/shimmer_loading.dart';
import 'package:tradicine_app/models/recipe/recipe_model.dart';
import 'package:tradicine_app/services/recipe_service.dart';
import 'package:tradicine_app/view/home/components/card_recipe.dart';

class RecipeList extends StatelessWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecipesService recipesService = RecipesService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 228,
          child: StreamBuilder<List<Recipe>>(
            stream: recipesService.getRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: ShimmerLoading(height: 200, width: 115));
              } else if (snapshot.hasError) {
                return const Center(child: Text("Gagal memuat resep"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Tidak ada resep tersedia"));
              }
          
              List<Recipe> recipes = snapshot.data!;
          
              return Container(
                height: 209, // 🔹 Batasan tinggi agar tidak berantakan
                child: ListView.separated(
                  itemCount: recipes.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: index == 0
                            ? EdgeInsets.only(left: 20)
                            : index == recipes.length - 1
                                ? EdgeInsets.only(right: 20)
                                : EdgeInsets.all(0),
                        child: RecipeCard(
                          recipe: recipes[index],
                        ));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
