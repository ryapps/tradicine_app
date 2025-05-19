import 'package:flutter/material.dart';
import 'package:tradicine_app/components/text/label_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';

class SuccessOrderScreen extends StatelessWidget {
  const SuccessOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 64),
            const SizedBox(height: 16),
            TitleText(
              text: 'Pesanan Berhasil',
             
            ),
            const SizedBox(height: 8),
            LabelText(
              text: 'Terima kasih telah berbelanja di Tradicine',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child:  Text('Kembali ke Beranda',style: TextStyle(color: Theme.of(context).primaryColor),),
            ),
          ],
        ),
      ),
    );
  }
}