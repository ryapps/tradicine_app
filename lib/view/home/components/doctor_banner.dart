import 'package:flutter/material.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/label_text.dart';

class DoctorConsultBanner extends StatelessWidget {
  final VoidCallback onPressed;

  const DoctorConsultBanner({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Theme.of(context).primaryColor)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              'assets/images/sick.png',
              width: 70,
              height: 70,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            // Bagian teks dan tombol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText(
                    text: 'Sering merasa gak enak badan?',
                  ),
                  const SizedBox(height: 4),
                  BodyText(
                    text: 'Dokter kami akan bantu atasi masalahmu!',
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(height: 8),
                  // Tombol "Tanya Dokter"
                  ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: Icon(Icons.chat_bubble_outline,
                        color: Theme.of(context).primaryColor),
                    label: Text('Tanya Dokter',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
