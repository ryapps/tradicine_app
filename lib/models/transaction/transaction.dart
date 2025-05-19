import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionItem {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final int quantity;

  TransactionItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}

class TransactionModel {
  final String id;
  final String userId;
  final List<TransactionItem> items;
  final int totalPrice;
  final String paymentMethod;
  final String status;
  final DateTime timestamp;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.paymentMethod,
    required this.status,
    required this.timestamp,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      print("⚠️ Dokumen transaksi kosong: ${doc.id}");
      return TransactionModel(
        id: doc.id,
        userId: "UNKNOWN_USER",
        items: [],
        totalPrice: 0,
        paymentMethod: "Cash",
        status: "pending",
        timestamp: DateTime.now(),
      );
    }

    print("✅ Data transaksi ditemukan: ${doc.id}");
    print("🔍 Data lengkap: $data");

    DateTime parsedTimestamp;
    if (data['timestamp'] is Timestamp) {
      parsedTimestamp = (data['timestamp'] as Timestamp).toDate();
    } else {
      print("⚠️ Timestamp tidak valid, menggunakan waktu sekarang.");
      parsedTimestamp = DateTime.now();
    }

    // Ambil data items langsung dari transaksi (bukan dari model CartItem)
    List<TransactionItem> transactionItems = (data['items'] as List<dynamic>?)
        ?.where((item) => item is Map<String, dynamic>) // Pastikan hanya data yang valid
        .map((item) => TransactionItem.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return TransactionModel(
      id: doc.id,
      userId: data['userId']?.toString() ?? "UNKNOWN_USER",
      items: transactionItems,
      totalPrice: (data['totalPrice'] as num?)?.toInt() ?? 0,
      paymentMethod: data['paymentMethod']?.toString() ?? "Cash",
      status: data['status']?.toString() ?? "pending",
      timestamp: parsedTimestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
