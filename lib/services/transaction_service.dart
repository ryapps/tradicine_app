import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tradicine_app/models/cart/cart.dart';
import 'package:tradicine_app/models/transaction/transaction.dart';

class TransactionService {
  final CollectionReference _transactionRef =
      FirebaseFirestore.instance.collection("transactions");

  // **📍 Simpan transaksi ke Firestore**
 Future<void> saveTransaction(List<CartItem> cartItems, double totalPrice, String paymentMethod) async {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";

  List<Map<String, dynamic>> items = cartItems.map((item) {
    return {
      "productId": item.id,
      "name": item.name,
      "quantity": item.quantity,
      "price": item.price,
      "imageUrl": item.imageUrl,
    };
  }).toList();

  await _transactionRef.add({
    "userId": userId,
    "items": items,
    "totalPrice": totalPrice,
    "paymentMethod": paymentMethod, // Simpan metode pembayaran
    "timestamp": FieldValue.serverTimestamp(),
    "status": "pending",
  });
}


  // **📍 Ambil semua transaksi berdasarkan userId**
  Future<List<TransactionModel>> getTransactions(String status) async {
      final String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";

    QuerySnapshot snapshot = await _transactionRef
        .where("userId", isEqualTo: userId)
        .where("status", isEqualTo: status)
        .orderBy("timestamp", descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromFirestore(doc))
        .toList();
  }

  Future<TransactionModel?> getTransactionById(String transactionId) async {
    DocumentSnapshot doc = await _transactionRef.doc(transactionId).get();
    if (doc.exists) {
      return TransactionModel.fromFirestore(doc);
    }
    return null;
  }

 Stream<List<TransactionModel>> transactionsStream(String status) {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";
  print("📡 Mengambil transaksi untuk userId: $userId dengan status: $status");

  return _transactionRef
      .where("userId", isEqualTo: userId)
      .where("status", isEqualTo: status)
      .orderBy("timestamp", descending: true)
      .snapshots()
      .map((snapshot) {
        print("📌 Jumlah transaksi ditemukan: ${snapshot.docs.length}");
        return snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList();
      });
}


}
