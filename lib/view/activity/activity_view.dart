import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradicine_app/models/transaction/transaction.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/services/transaction_service.dart';
import 'package:tradicine_app/view/home/widgets/bottom_navbar.dart';

class ActivityView extends StatelessWidget {
  ActivityView({Key? key}) : super(key: key);

  final TransactionService _transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TitleText(text: 'Aktivitas Transaksi'),
          bottom:  TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(text: 'Tertunda'),
              Tab(text: 'Selesai'),
              Tab(text: 'Dibatalkan'),
            ],
          ),
        ),
        body: TabBarView(    
          children: [
            _buildTransactionList(context, "pending"),
            _buildTransactionList(context, "completed"),
            _buildTransactionList(context, "canceled"),
          ],
        ),
        bottomNavigationBar: BottomNav(page: 3),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, String status) {
    return FutureBuilder<List<TransactionModel>>(
      future: _transactionService.getTransactions(status),
      builder: (context, snapshot) {
       
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,));
        }
        if (snapshot.hasError) {
          return Center(
            child: BodyText(text: 'Terjadi error: ${snapshot.error}'),
          );
        }

        final transactions = snapshot.data;
        if (transactions == null || transactions.isEmpty) {
          return Center(child: BodyText(text: 'Tidak ada transaksi'));
        }

        return Container(
          color: Colors.grey.shade200,
          child: ListView.builder(     
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(text: "Total: Rp${tx.totalPrice}", color: Theme.of(context).primaryColor,size: 21,),
                      const SizedBox(height: 6),
                      BodyText(text: "Metode Pembayaran: ${tx.paymentMethod}"),
                      const SizedBox(height: 12),
                      Column(
                        children: tx.items.map((item) {                
                          return _buildTransactionItem(item,context);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTransactionItem(TransactionItem item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 60, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(text: item.name, size: 16),
                const SizedBox(height: 4),
                BodyText(text: "Jumlah: ${item.quantity}"),
              ],
            ),
          ),
          TitleText(text: "Rp${item.price * item.quantity}", color: Theme.of(context).primaryColor,size: 18,),
        ],
      ),
    );
  }
}
