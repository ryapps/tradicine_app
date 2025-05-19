import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradicine_app/components/loading/shimmer_loading.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/icon_text.dart';
import 'package:tradicine_app/components/text/label_text.dart';
import 'package:tradicine_app/components/text/subtitle_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/models/recipe/recipe_model.dart';
import 'package:tradicine_app/services/recipe_service.dart';
import 'package:tradicine_app/view/home/recipe/tutorial_step_recipe.dart';
import 'package:tradicine_app/view/home/widgets/render_category.dart';

class DetailRecipe extends StatefulWidget {
  final String recipeId;
  const DetailRecipe({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<DetailRecipe> createState() => _DetailRecipeState();
}

class _DetailRecipeState extends State<DetailRecipe> {
  final RecipesService _recipesService = RecipesService();
  bool _isFavorite = false;
  bool _isExpanded = false;
  final int _maxLines = 4;
  int _portion = 1;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _increment() {
    setState(() {
      _portion++;
    });
  }

  void _decrement() {
    if (_portion > 1) {
      setState(() {
        _portion--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Recipe?>(
        future: _recipesService.getRecipeById(widget.recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ShimmerLoading(
                height: double.infinity,
                width: 500,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Resep tidak ditemukan"));
          }

          final recipe = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan gambar dan tombol di atas
                Stack(
                  children: [
                    Image.network(
                      recipe.imgRecipe,
                      height: 300,
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                    // Tombol navigasi dan favorit di dalam Stack
                    Positioned(
                      top: 30,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                            ),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _toggleFavorite,
                                icon: _isFavorite
                                    ? const Icon(Icons.favorite,
                                        color: Colors.redAccent)
                                    : Icon(Icons.favorite_border,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface),
                              ),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
                                ),
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Detail bagian resep, dengan margin negatif agar tumpang tindih dengan gambar header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(top: 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TitleText(text: recipe.name),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RenderCategory(
                            categoryId: recipe.categoryId,
                            isSubtitle: true,
                          ),
                          Text(" / ",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
                          SubtitleText(
                            text: recipe.duration,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Nutrisi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              LabelText(
                                text: "${recipe.calories} kkal",
                              ),
                              BodyText(
                                text: "Kalori",
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              LabelText(
                                text: "${recipe.carbs} g",
                              ),
                              BodyText(
                                text: "Karbohidrat",
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              LabelText(
                                text: "${recipe.protein} g",
                              ),
                              BodyText(
                                text: "Protein",
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              LabelText(
                                text: "${recipe.vitamins} mg",
                              ),
                              BodyText(
                                text: "Vitamin",
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Bagian bahan-bahan (ingredients)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TitleText(
                                text: "Bahan-bahan",
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: SubtitleText(
                                    text: "$_portion Porsi",
                                    color:
                                        Theme.of(context).colorScheme.surface),
                              ),
                            ],
                          ),
                          Container(
                            width: 70,
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                // Tombol minus
                                Expanded(
                                  child: IconButton(
                                    onPressed: _decrement,
                                    icon: const Icon(Icons.remove, size: 12),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ),
                                // Pembatas tengah
                                Container(
                                  width: 1.5,
                                  color: Colors.black,
                                ),
                                // Tombol plus
                                Expanded(
                                  child: IconButton(
                                    onPressed: _increment,
                                    icon: const Icon(Icons.add, size: 12),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Daftar bahan-bahan (ingredients)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipe.ingredients.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                        itemBuilder: (context, index) {
                          final ingredient = recipe.ingredients[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BodyText(
                                text: ingredient.name,
                                fontWeight: FontWeight.w600,
                              ),
                              BodyText(
                                text: ingredient.amount,
                                color: Theme.of(context).colorScheme.surface,
                              )
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      // Bagian cara pembuatan (steps)
                      Row(
                        children: [
                          TitleText(
                            text: "Cara Pembuatan",
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SubtitleText(
                                text: "${recipe.steps.length} Langkah",
                                color: Theme.of(context).colorScheme.surface),
                          ),
                        ],
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipe.steps.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 5),
                        itemBuilder: (context, index) {
                          final stepItem = recipe.steps[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SubtitleText(
                                      text: "Langkah ${stepItem.order} "),
                                  SubtitleText(
                                    text: "/ ${recipe.steps.length}",
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              Image.network(
                                stepItem.imageUrl ?? "",
                                height: 75,
                                width: 75,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              ),
                              const SizedBox(height: 5),
                              BodyText(
                                text: stepItem.description,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          TitleText(
                            text: "Khasiat",
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SubtitleText(
                                text: "${recipe.benefits.length} khasiat",
                                color: Theme.of(context).colorScheme.surface),
                          ),
                        ],
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipe.benefits.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final benefitItem = recipe.benefits[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubtitleText(
                                text: "${index + 1}. ${benefitItem.name}",
                              ),
                              BodyText(
                                text: benefitItem.description,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(          
                onPressed: () {},
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(150, 50)),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                ),
                child: TitleText(
                  text: "Simpan",
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextButton.icon(
                  label: TitleText(text:"Buat obat ini", size: 16,color: Colors.white,),
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(50, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TutorialStepRecipe(recipeId: widget.recipeId)));
                  },
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.arrow_forward, color: Colors.white, size: 20)
                  
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
