import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradicine_app/models/category/product_categories.dart';

class CategoryService {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  // Mendapatkan semua kategori dalam bentuk stream
 Future<List<Category>> getAllCategories() async {
  QuerySnapshot snapshot = await _categoryCollection.get();
  return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
}


  // Menambahkan kategori baru
  Future<void> addCategory(String name, String img) async {
    await _categoryCollection.add({'name': name, 'img' : img});
  }

  // Memperbarui kategori berdasarkan ID
  Future<void> updateCategory(String id, String newName, String newImg) async {
    await _categoryCollection.doc(id).update({'name': newName, 'img' : newImg});
  }

  // Menghapus kategori berdasarkan ID
  Future<void> deleteCategory(String id) async {
    await _categoryCollection.doc(id).delete();
  }

  // Mengambil kategori berdasarkan ID
  Future<Category?> getCategoryById(String id) async {
    DocumentSnapshot doc = await _categoryCollection.doc(id).get();
    if (doc.exists) {
      return Category.fromFirestore(doc);
    }
    return null;
  }
}
