import 'package:flutter/material.dart';
import'dart:core';

class LabelText extends StatefulWidget {
  final String text;
  Color? color;
  FontWeight? fontWeight;
  LabelText({super.key, required this.text, this.color, this.fontWeight});

  @override
  State<LabelText> createState() => _LabelTextState();
}

class _LabelTextState extends State<LabelText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,          
      style: TextStyle(
        fontSize: 14,
        fontWeight: widget.fontWeight ?? FontWeight.w600,
        color: widget.color ?? Colors.black,

      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
