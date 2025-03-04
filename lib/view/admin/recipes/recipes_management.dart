import 'package:flutter/material.dart';
import 'package:tradicine_app/components/layout/bottom_dialog_layout.dart';
import 'package:tradicine_app/components/text/label_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/models/category/product_categories.dart';
import 'package:tradicine_app/models/recipe/recipe_model.dart';
import 'package:tradicine_app/services/recipe_service.dart';
import 'package:tradicine_app/services/category_service.dart';

class RecipeManagement extends StatefulWidget {
  const RecipeManagement({super.key});

  @override
  _RecipeManagementState createState() => _RecipeManagementState();
}

class _RecipeManagementState extends State<RecipeManagement> {
  RecipesService _recipesService = RecipesService();
  final CategoryService _categoryService = CategoryService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlVideoController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController vitaminsController = TextEditingController();
  final TextEditingController imgRecipeController = TextEditingController();
  List<TextEditingController> ingredientsNameController = [];
  List<TextEditingController> ingredientsAmountController = [];
  List<IngredientRecipe> ingredients = [];
  List<TextEditingController> stepsOrderController = [];
  List<TextEditingController> stepsDescriptionController = [];
  List<TextEditingController> stepsImgController = [];
  List<StepRecipe> step = [];
  List<TextEditingController> benefitsNameController = [];
  List<TextEditingController> benefitsDescriptionController = [];
  List<BenefitRecipe> benefits = [];

  void dispose() {
    nameController.dispose();
    urlVideoController.dispose();
    imgRecipeController.dispose();
    durationController.dispose();
    caloriesController.dispose();
    carbsController.dispose();
    proteinController.dispose();
    vitaminsController.dispose();
    for (var controller in [
      ...ingredientsNameController,
      ...ingredientsAmountController,
      ...stepsOrderController,
      ...stepsDescriptionController,
      ...stepsImgController,
      ...benefitsNameController,
      ...benefitsDescriptionController,
    ]) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _showRecipeDialog({Recipe? recipe}) async {
    // Jika recipe tidak null (mode edit), populate semua controller & list global
    if (recipe != null) {
      nameController.text = recipe.name;
      urlVideoController.text = recipe.urlVideo;
      imgRecipeController.text = recipe.imgRecipe;
      durationController.text = recipe.duration;
      caloriesController.text = recipe.calories.toString();
      carbsController.text = recipe.carbs.toString();
      proteinController.text = recipe.protein.toString();
      vitaminsController.text = recipe.vitamins.toString();
      // Asumsikan recipe.ingredients, recipe.steps, recipe.benefits tersedia
      ingredients.clear();
      ingredientsNameController.clear();
      ingredientsAmountController.clear();
      for (var ing in recipe.ingredients) {
        ingredients.add(ing);
        ingredientsNameController.add(TextEditingController(text: ing.name));
        ingredientsAmountController
            .add(TextEditingController(text: ing.amount));
      }
      step.clear();
      stepsOrderController.clear();
      stepsDescriptionController.clear();
      stepsImgController.clear();
      for (var stp in recipe.steps) {
        step.add(stp);
        stepsOrderController
            .add(TextEditingController(text: stp.order.toString()));
        stepsDescriptionController
            .add(TextEditingController(text: stp.description));
        stepsImgController.add(TextEditingController(text: stp.imageUrl));
      }
      benefits.clear();
      benefitsNameController.clear();
      benefitsDescriptionController.clear();
      for (var ben in recipe.benefits) {
        benefits.add(ben);
        benefitsNameController.add(TextEditingController(text: ben.name));
        benefitsDescriptionController
            .add(TextEditingController(text: ben.description));
      }
    } else {
      // Mode tambah, pastikan list dan controller bersih
      nameController.clear();
      urlVideoController.clear();
      imgRecipeController.clear();
      durationController.clear();
      caloriesController.clear();
      carbsController.clear();
      proteinController.clear();
      vitaminsController.clear();
      ingredients.clear();
      ingredientsNameController.clear();
      ingredientsAmountController.clear();
      step.clear();
      stepsOrderController.clear();
      stepsDescriptionController.clear();
      stepsImgController.clear();
      benefits.clear();
      benefitsNameController.clear();
      benefitsDescriptionController.clear();
    }

    String? selectedCategory = recipe?.categoryId;
    List<Category> categories = await _categoryService.getAllCategories();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        // Menggunakan StatefulBuilder agar perubahan di modal dapat langsung terlihat
        return BottomDialogLayout(
          height: double.infinity,
          title: TitleText(
            text: recipe == null ? 'Tambah Resep' : 'Edit Resep',
            color: Colors.white,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Field resep statis
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Resep',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface), // Warna border saat tidak fokus
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2), // Warna border saat fokus
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Misalnya URL video
                    TextField(
                      controller: urlVideoController,
                      decoration: InputDecoration(
                        labelText: 'URL Video',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface), // Warna border saat tidak fokus
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2), // Warna border saat fokus
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: imgRecipeController,
                      decoration: InputDecoration(
                        labelText: 'Image',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface), // Warna border saat tidak fokus
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2), // Warna border saat fokus
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                          labelText: 'Kategori',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface,
                                width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface), // Warna border saat tidak fokus
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2), // Warna border saat fokus
                          )),
                      dropdownColor: Colors.white,
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: durationController,
                      decoration: InputDecoration(
                        labelText: 'Durasi',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface), // Warna border saat tidak fokus
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2), // Warna border saat fokus
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: caloriesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Kalori',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface), // Warna border saat tidak fokus
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2), // Warna border saat fokus
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: carbsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Karbohidrat',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface), // Warna border saat tidak fokus
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2), // Warna border saat fokus
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: proteinController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Protein',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface), // Warna border saat tidak fokus
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2), // Warna border saat fokus
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: vitaminsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Vitamin',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface), // Warna border saat tidak fokus
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2), // Warna border saat fokus
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Bagian Komposisi / Ingredients
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Komposisi',style: TextStyle(fontSize: 16),),
                              GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    _addIngredient();
                                  });
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: Theme.of(context).primaryColor,
                                  size: 28,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: ingredients.length,
                            itemBuilder: (context, index) {
                              return generateIngredient(index, setModalState);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Bagian Langkah / Steps
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Langkah-langkah',style: TextStyle(fontSize: 16)),
                              GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    _addStep();
                                  });
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: Theme.of(context).primaryColor,
                                  size: 28,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: step.length,
                            itemBuilder: (context, index) {
                              return generateStep(index, setModalState);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Bagian Manfaat / Benefits
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Manfaat',style: TextStyle(fontSize: 16)),
                              GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    _addBenefit();
                                  });
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: Theme.of(context).primaryColor,
                                  size: 28,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: benefits.length,
                            itemBuilder: (context, index) {
                              return generateBenefit(index, setModalState);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Tombol simpan & batal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Batal')),
                        ElevatedButton(
                          onPressed: () {
                            for (int i = 0; i < ingredients.length; i++) {
                              ingredients[i].name =
                                  ingredientsNameController[i].text;
                              ingredients[i].amount =
                                  ingredientsAmountController[i].text;
                            }
                            for (int i = 0; i < step.length; i++) {
                              step[i].order =
                                  int.tryParse(stepsOrderController[i].text) ??
                                      step[i].order;
                              step[i].description =
                                  stepsDescriptionController[i].text;
                              step[i].imageUrl = stepsImgController[i].text;
                            }
                            for (int i = 0; i < benefits.length; i++) {
                              benefits[i].name = benefitsNameController[i].text;
                              benefits[i].description =
                                  benefitsDescriptionController[i].text;
                            }
                            if (recipe == null) {
                              _recipesService.addRecipe(
                                name: nameController.text,
                                categoryId: selectedCategory!,
                                urlVideo: urlVideoController.text,
                                duration: durationController.text,
                                calories: int.parse(caloriesController.text),
                                carbs: double.parse(carbsController.text),
                                protein: double.parse(proteinController.text),
                                vitamins: double.parse(vitaminsController.text),
                                benefits:
                                    benefits.map((b) => b.toMap()).toList(),
                                imgRecipe: imgRecipeController.text,
                                ingredients:
                                    ingredients.map((i) => i.toMap()).toList(),
                                steps: step.map((s) => s.toMap()).toList(),
                              );
                            } else {
                              _recipesService.updateRecipes(
                                recipe.id,
                                name: nameController.text,
                                categoryId: selectedCategory!,
                                urlVideo: urlVideoController.text,
                                duration: durationController.text,
                                calories: int.parse(caloriesController.text),
                                carbs: double.parse(carbsController.text),
                                protein: double.parse(proteinController.text),
                                vitamins: double.parse(vitaminsController.text),
                                benefits:
                                    benefits.map((b) => b.toMap()).toList(),
                                imgRecipe: imgRecipeController.text,
                                ingredients:
                                    ingredients.map((i) => i.toMap()).toList(),
                                steps: step.map((s) => s.toMap()).toList(),
                              );
                            }
                            Navigator.pop(context);
                          },
                          child: Text('Simpan'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String recipeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus resep ini?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Batal')),
            ElevatedButton(
              onPressed: () {
                _recipesService.deleteRecipe(recipeId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _addIngredient() {
    setState(() {
      ingredients.add(IngredientRecipe(name: "", amount: ""));
      ingredientsNameController.add(TextEditingController());
      ingredientsAmountController.add(TextEditingController());
    });
  }

  void _addStep() {
    setState(() {
      step.add(
          StepRecipe(order: step.length + 1, description: "", imageUrl: ""));
      stepsOrderController.add(TextEditingController());
      stepsDescriptionController.add(TextEditingController());
      stepsImgController.add(TextEditingController());
    });
  }

  void _addBenefit() {
    setState(() {
      benefits.add(BenefitRecipe(name: "", description: ""));
      benefitsNameController.add(TextEditingController());
      benefitsDescriptionController.add(TextEditingController());
    });
  }

  void _removeIngredient(int index) {
    if (index < 0 || index >= ingredients.length)
      return; // pastikan index valid

    setState(() {
      ingredientsNameController[index].dispose();
      ingredientsAmountController[index].dispose();

      ingredients.removeAt(index);
      ingredientsNameController.removeAt(index);
      ingredientsAmountController.removeAt(index);
    });
  }

  void _removeStep(int index) {
    if (index < 0 || index >= step.length) return; // pastikan index valid

    setState(() {
      stepsOrderController[index].dispose();
      stepsDescriptionController[index].dispose();
      stepsImgController[index].dispose();

      step.removeAt(index);
      stepsOrderController.removeAt(index);
      stepsDescriptionController.removeAt(index);
      stepsImgController.removeAt(index);
    });
  }

  void _removeBenefit(int index) {
    if (index < 0 || index >= benefits.length) return; // pastikan index valid

    setState(() {
      benefitsNameController[index].dispose();
      benefitsDescriptionController[index].dispose();

      benefits.removeAt(index);
      benefitsNameController.removeAt(index);
      benefitsDescriptionController.removeAt(index);
    });
  }

  Widget generateIngredient(int index, Function(void Function()) updateModal) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  updateModal(() {
                    _removeIngredient(index);
                  });
                },
                child: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                  size: 28,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: ingredientsNameController[index],
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "Nama Komposisi",
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.surface)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .surface), // Warna border saat tidak fokus
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2), // Warna border saat fokus
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: ingredientsAmountController[index],
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Takaran",
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.surface)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .surface), // Warna border saat tidak fokus
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2), // Warna border saat fokus
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget generateStep(index, Function(void Function()) updateModal) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _removeStep(index),
                child: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                  size: 28,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: stepsOrderController[index],
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Step ke",
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.surface)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .surface), // Warna border saat tidak fokus
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2), // Warna border saat fokus
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: stepsDescriptionController[index],
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Deskripsi",
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.surface)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .surface), // Warna border saat tidak fokus
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2), // Warna border saat fokus
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: stepsImgController[index],
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Img",
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.surface)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .surface), // Warna border saat tidak fokus
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2), // Warna border saat fokus
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget generateBenefit(index, Function(void Function()) updateModal) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _removeBenefit(index),
                child: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                  size: 28,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: benefitsNameController[index],
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Manfaat",
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.surface)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .surface), // Warna border saat tidak fokus
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2), // Warna border saat fokus
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: benefitsDescriptionController[index],
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Deskripsi",
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.surface)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .surface), // Warna border saat tidak fokus
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2), // Warna border saat fokus
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleText(text: 'Manajemen Resep'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: _recipesService.getRecipes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView(
            padding: EdgeInsets.all(20),
            children: snapshot.data!.map((recipe) {
              return ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 1)),
                title: Text(recipe.name),
                subtitle:
                    Text('${recipe.duration} - ${recipe.calories} kalori'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showRecipeDialog(recipe: recipe)),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            _showDeleteConfirmationDialog(recipe.id)),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _showRecipeDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
