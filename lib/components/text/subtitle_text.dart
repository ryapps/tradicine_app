import 'package:flutter/material.dart';

class SubtitleText extends StatefulWidget {
  final String text;
  Color? color;
  SubtitleText({super.key, required this.text, this.color});

  @override
  State<SubtitleText> createState() => _SubtitleTextState();
}

class _SubtitleTextState extends State<SubtitleText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: widget.color ?? Colors.black,
      ),
    );
  }
}
