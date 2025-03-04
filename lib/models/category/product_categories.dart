import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String img;
  Category({required this.id, required this.name,required this.img});

  // Mengonversi Firestore Document ke Model Category
  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      img: data['img'] ?? ''
    );
  }

  // Mengonversi objek Category ke format Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {'name': name, 'img': img};
  }
}
