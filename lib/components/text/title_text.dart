import 'package:flutter/material.dart';

class TitleText extends StatefulWidget {
  final String text;
  TextAlign? textAlign;
  Color? color;
  TitleText({super.key, required this.text, this.color, this.textAlign});

  @override
  State<TitleText> createState() => _TitleTextState();
}

class _TitleTextState extends State<TitleText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        color: widget.color ?? Theme.of(context).colorScheme.tertiary,
      ),
      textAlign: widget.textAlign ?? TextAlign.left,
    );
  }
}
