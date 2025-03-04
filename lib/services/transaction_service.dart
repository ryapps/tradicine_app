import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ CREATE TRANSACTION
  Future<void> createTransaction({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalPrice,
  }) async {
    await _firestore.collection('transactions').add({
      'userId': userId,
      'items': items,
      'totalPrice': totalPrice,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ✅ GET TRANSACTIONS BY USER
  Stream<QuerySnapshot> getTransactionsByUser(String userId) {
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}
