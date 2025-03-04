import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final int price;
  final int stock;
  final String imageUrl;
  final String categoryId;
  final String productDesc;
  final String ingredients;
  final String benefits;
  final String usage;
  final double rating;
  final int sold;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.categoryId,
    required this.productDesc,
    required this.ingredients,
    required this.benefits,
    required this.usage,
    required this.rating,
    required this.sold,
  });

  // Konversi dari Firestore ke objek Product
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toInt(),
      stock: (data['stock'] ?? 0).toInt(),
      imageUrl: data['imageUrl'] ?? '',
      categoryId: data['categoryId'] ?? '',
      productDesc: data['description']['product'] ?? '',
      ingredients: data['description']['ingredients'] ?? '',
      benefits: data['description']['benefits'] ?? '',
      usage: data['description']['usage'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      sold: (data['sold'] ?? 0).toInt(),
    );
  }
}
