import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradicine_app/models/product/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ ADD PRODUCT
  Future<void> addProduct({
    required String name,
    required int price,
    required int stock,
    required String imageUrl,
    required String categoryId,
    required String productDesc,
    required String ingredients,
    required String benefits,
    required String usage,
    required double rating,
    required int sold,
  }) async {
    await _firestore.collection('products').add({
      'name': name,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'description': {
        'product': productDesc,
        'ingredients': ingredients,
        'benefits': benefits,
        'usage': usage,
      },
      'rating': rating,
      'sold': sold,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': null
    });
  }

  // ✅ GET ALL PRODUCTS
  Stream<List<Product>> getAllProducts() {
    return _firestore.collection('products').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList(),
    );
  }

  // ✅ GET PRODUCTS BY CATEGORY
  Stream<List<Product>> getProductsByCategoryId(String categoryId) {
  return _firestore
      .collection('products')
      .where('categoryId', isEqualTo: categoryId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList());
}

Stream<List<Product>> getBestSellerProducts({DocumentSnapshot? lastDoc}) {
    Query query = _firestore
        .collection('products')
        .orderBy('sold', descending: true)
        .limit(5); 

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc); 
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }



  // ✅ GET PRODUCT BY ID
  Future<Product?> getProductById(String productId) async {
    DocumentSnapshot doc = await _firestore.collection('products').doc(productId).get();
    if (doc.exists) {
      return Product.fromFirestore(doc);
    } else {
      return null;
    }
  }

  // ✅ UPDATE PRODUCT
  Future<void> updateProduct(
    String productId, {
    required String name,
    required int price,
    required int stock,
    required String imageUrl,
    required String categoryId,
    required String productDesc,
    required String ingredients,
    required String benefits,
    required String usage,
    required double rating,
    required int sold,
  }) async {
    await _firestore.collection('products').doc(productId).update({
     'name': name,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'description': {
        'product': productDesc,
        'ingredients': ingredients,
        'benefits': benefits,
        'usage': usage,
      },
      'rating': rating,
      'sold': sold,
      'createdAt': null,
      'updateAt':  FieldValue.serverTimestamp()
    });
  }

  // ✅ DELETE PRODUCT
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }
}
