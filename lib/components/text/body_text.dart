import 'package:flutter/material.dart';

class BodyText extends StatefulWidget {
  final String text;
  Color? color;
  TextAlign? textAlign;
  FontWeight? fontWeight;
  BodyText({super.key, required this.text, this.color, this.textAlign,this.fontWeight});

  @override
  State<BodyText> createState() => _BodyTextState();
}

class _BodyTextState extends State<BodyText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: widget.fontWeight ?? FontWeight.normal,
        color: widget.color ??Colors.black87,
      ),
      textAlign: widget.textAlign ?? TextAlign.left,
    );
  }
}
