import 'package:flutter/material.dart';
import 'package:tradicine_app/components/header/header_bottom_dialog.dart';

class BottomDialogLayout extends StatelessWidget {
  final Widget title;
  final double height;
  final Widget child;
  const BottomDialogLayout(
      {super.key, required this.child, required this.title, this.height = 300});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          HeaderBottomDialog(title: title),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20), child: child))
        ]));
  }
}
