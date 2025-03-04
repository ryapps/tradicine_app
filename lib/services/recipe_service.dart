import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradicine_app/models/recipe/recipe_model.dart';

class RecipesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "recipes";

  Future<void> addRecipe({
    required String name,
    required String categoryId,
    required String imgRecipe,
    required String urlVideo,
    required String duration,
    required int calories,
    required double carbs,
    required double protein,
    required double vitamins,
    required List<Map<String, dynamic>> ingredients,
    required List<Map<String, dynamic>> steps,
    required List<Map<String, dynamic>> benefits,
  }) async {
    await _firestore.collection(collectionName).add({
      'name': name,
      'categoryId': categoryId,
      'imgRecipe': imgRecipe,
      'urlVideo': urlVideo,
      'duration': duration,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'vitamins': vitamins,
      'ingredients': ingredients,
      'steps': steps,
      'benefits': benefits,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': null
    });
  }

  Future<void> updateRecipes(
    String recipesId, {
    required String name,
    required String categoryId,
    required String imgRecipe,
    required String urlVideo,
    required String duration,
    required int calories,
    required double carbs,
    required double protein,
    required double vitamins,
    required List<Map<String, dynamic>> ingredients,
    required List<Map<String, dynamic>>  steps,
    required List<Map<String, dynamic>> benefits,
  }) async {
    await _firestore.collection(collectionName).doc(recipesId).update({
      'name': name,
      'categoryId': categoryId,
      'imgRecipe': imgRecipe,
      'urlVideo': urlVideo,
      'duration': duration,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'vitamins': vitamins,
      'ingredients': ingredients,
      'steps': steps,
      'benefits': benefits,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': null
    });
  }

  Future<void> deleteRecipe(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }

  Future<Recipe?> getRecipeById(String id) async {
    DocumentSnapshot doc =
        await _firestore.collection(collectionName).doc(id).get();
    if (doc.exists) {
      return Recipe.fromFirestore(doc);
    }
    return null;
  }

  Stream<List<Recipe>> getRecipes() {
    return _firestore.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }
  
}
