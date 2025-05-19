import 'package:flutter/material.dart'; // Ensure dart:core is available (default in Dart)

class IconText extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const IconText({
    super.key,
    required this.text,
    required this.icon,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
