import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String id;
  String name;
  String categoryId;
  String imgRecipe;
  String urlVideo;
  String duration;
  int calories;
  double carbs;
  double protein;
  double vitamins;
  List<IngredientRecipe> ingredients;
  List<StepRecipe> steps;
  List<BenefitRecipe> benefits;

  Recipe({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.imgRecipe,
    required this.urlVideo,
    required this.duration,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.vitamins,
    required this.ingredients,
    required this.steps,
    required this.benefits,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      name: map['name'],
      categoryId: map['categoryId'],
      imgRecipe: map['imgRecipe'],
      urlVideo: map['urlVideo'],
      duration: map['duration'],
      calories: map['calories'],
      carbs: map['carbs'].toDouble(),
      protein: map['protein'].toDouble(),
      vitamins: map['vitamins'].toDouble(),
      ingredients: List<IngredientRecipe>.from(
        map['ingredients'].map((x) => IngredientRecipe.fromFirestore(x)),
      ),
      steps: List<StepRecipe>.from(
        map['steps'].map((x) => StepRecipe.fromFirestore(x)),
      ),
      benefits: List<BenefitRecipe>.from(
        map['benefits'].map((x) => BenefitRecipe.fromFirestore(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryId': categoryId,
      'urlVideo': urlVideo,
      'duration': duration,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'vitamins': vitamins,
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'steps': steps.map((x) => x.toMap()).toList(),
      'benefits': benefits.map((x) => x.toMap()).toList(),
    };
  }
}

class IngredientRecipe {
  String name;
  String amount;

  IngredientRecipe({required this.name, required this.amount});

  factory IngredientRecipe.fromFirestore(Map<String, dynamic> map) {
    return IngredientRecipe(
      name: map['name'],
      amount: map['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}


class StepRecipe {
  int order;
  String description;
  String? imageUrl;

  StepRecipe({required this.order, required this.description, this.imageUrl});

  factory StepRecipe.fromFirestore(Map<String, dynamic> map) {
    return StepRecipe(
      order: map['order'],
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}


class BenefitRecipe {
  String name;
  String description;

  BenefitRecipe({required this.name, required this.description});

  factory BenefitRecipe.fromFirestore(Map<String, dynamic> map) {
    return BenefitRecipe(
      name: map['name'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }
}
