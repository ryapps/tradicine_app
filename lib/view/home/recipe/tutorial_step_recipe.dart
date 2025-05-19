import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradicine_app/components/loading/shimmer_loading.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/subtitle_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/models/recipe/recipe_model.dart';
import 'package:tradicine_app/services/recipe_service.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TutorialStepRecipe extends StatefulWidget {
  final String recipeId;
  const TutorialStepRecipe({Key? key, required this.recipeId})
      : super(key: key);

  @override
  State<TutorialStepRecipe> createState() => _TutorialStepRecipeState();
}

class _TutorialStepRecipeState extends State<TutorialStepRecipe> {
  final RecipesService _recipesService = RecipesService();
  Recipe? _recipe;
  int _currentStepIndex = 0;
  int _totalSteps = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _nextStep() {
    if (_recipe != null && _currentStepIndex < _recipe!.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    } else {
      print("Anda sudah di langkah terakhir!");
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    } else {
      print("Anda sudah di langkah pertama!");
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
            return Center(
              child: Text("Terjadi error: ${snapshot.error}"),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Resep tidak ditemukan"));
          }

          final recipe = snapshot.data!;
          _recipe = recipe;
          final totalSteps = recipe.steps.length;
          _totalSteps = totalSteps;
          final currentStep = recipe.steps[_currentStepIndex];

          return Stack(
            children: [
              Image.network(
                recipe.urlVideo,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
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
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                      ),
                      icon: const Icon(
                        Icons.zoom_out_map,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 120,
                left: 160,
                right: 160,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: TitleText(
                            text: "Langkah ${_currentStepIndex + 1}",
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Indikator langkah
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(totalSteps, (index) {
                            final isActive = index == _currentStepIndex;
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color:
                                    isActive ? Colors.green : Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    color:
                                        isActive ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 10),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recipe.ingredients.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 5),
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
                        // Bagian cara pembuatan untuk step saat ini
                        Divider(
                          color: Colors.black45.withOpacity(0.2),
                          thickness: 1,
                          height: 0.5,
                        ),
                        const SizedBox(height: 15),
                        BodyText(text: currentStep.description),
                        const SizedBox(height: 20),
                        // Tombol "Selanjutnya"
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // Bottom bar tetap di bawah layar (jika diperlukan)
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: _currentStepIndex == _totalSteps - 1
            ? Expanded(
                child: TextButton.icon(
                    label: TitleText(
                      text: "Selesai",
                      size: 16,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size(50, 50)),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconAlignment: IconAlignment.end,
                    icon: Icon(Icons.check,
                        color: Colors.white, size: 20)),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton.icon(
                        label: TitleText(
                          text: "Sebelumnya",
                          size: 16,
                          color: Colors.black,
                        ),
                        style: ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(Size(50, 50)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                        onPressed: _prevStep,
                        iconAlignment: IconAlignment.start,
                        icon: Icon(Icons.arrow_back,
                            color: Colors.black, size: 20)),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextButton.icon(
                        label: TitleText(
                          text: "Selanjutnya",
                          size: 16,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(Size(50, 50)),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                        onPressed: _nextStep,
                        iconAlignment: IconAlignment.end,
                        icon: Icon(Icons.arrow_forward,
                            color: Colors.white, size: 20)),
                  ),
                ],
              ),
      ),
    );
  }
}
