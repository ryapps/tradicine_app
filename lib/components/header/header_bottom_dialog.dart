import 'package:flutter/material.dart';

class HeaderBottomDialog extends StatelessWidget {
  final Widget title;
  HeaderBottomDialog({required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(20),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          title,
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              "Tutup",
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
            ),
          )
        ]),
      ),
    );
  }
}
