import 'package:flutter/material.dart';

class TitleText extends StatefulWidget {
  final String text;
  TextAlign? textAlign;
  final int size;
  Color? color;
  TitleText({super.key, required this.text, this.color, this.textAlign, this.size = 21});

  @override
  State<TitleText> createState() => _TitleTextState();
}

class _TitleTextState extends State<TitleText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: widget.size.toDouble(),
        fontWeight: FontWeight.bold,
        color: widget.color ?? Theme.of(context).colorScheme.tertiary,
      ),
      textAlign: widget.textAlign ?? TextAlign.left,
    );
  }
}
