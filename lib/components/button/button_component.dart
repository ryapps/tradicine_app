import 'package:flutter/material.dart';

class ButtonComponent extends StatefulWidget {
  double? width;
  double? height;
  double? radius;
  Color? colorBackground;
  Color? colorText;
  EdgeInsets? padding;
  EdgeInsets? margin;
  BoxBorder? border;
  final String text;
  final Function() onPressed;
  Widget? icon;
  ButtonComponent(
      {required this.text,
      required this.onPressed,
      this.width,
      this.height,
      this.colorBackground,
      this.colorText,
      this.margin,
      this.padding,
      this.radius,
      this.border,
      this.icon});

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  Widget buildContainer() {
    if (widget.icon != null) {
      return Container(
        padding: widget.padding ?? EdgeInsets.only(top: 15, bottom: 15),
        width: widget.width ?? MediaQuery.of(context).size.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: widget.colorBackground ?? Theme.of(context).primaryColor,
            border: widget.border,
            borderRadius: BorderRadius.circular(widget.radius ?? 50)),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            widget.icon!,
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                widget.text,
                style: TextStyle(
                    color: widget.colorText ?? Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
      );
    } else {
      return Container(
        padding: widget.padding ?? EdgeInsets.only(top: 15, bottom: 15),
        width: widget.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: widget.colorBackground ?? Theme.of(context).primaryColor,
            border: widget.border,
            borderRadius: BorderRadius.circular(widget.radius ?? 50)),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
                color: widget.colorText ?? Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        margin: widget.margin ?? null,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(widget.radius ?? 50),
          child: buildContainer(),
        ),
      ),
    );
  }
}
