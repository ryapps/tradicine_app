import 'package:flutter/material.dart';

class CustomListView extends StatefulWidget {
  final int itemCount;
  final double itemWidth;
  final double itemHeight;
  final ShapeBorder itemShape;
  final Axis scrollDirection;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int) separatorBuilder;
  final Map<String, String>? icon;
  final String? jenis;
  CustomListView(
      {required this.itemCount,
      this.itemWidth = 100.0,
      this.itemHeight= 100.0, // Default width for horizontal list
      this.itemShape = const RoundedRectangleBorder(),
      this.scrollDirection = Axis.vertical,
      required this.itemBuilder,
      required this.separatorBuilder,
      this.icon,
      this.jenis});

  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: widget.itemHeight + 20,
            child: ListView.separated(
              scrollDirection: widget.scrollDirection,
              itemCount: widget.itemCount,
              itemBuilder: (context, index) {
                return Container(
                  margin: widget.jenis != 'kategori' ? index == widget.itemCount - 1 ? EdgeInsets.only(right: 20,left: 0) : index == 0 ? EdgeInsets.only(left: 20, right: 10) : EdgeInsets.only(right: 10) : EdgeInsets.symmetric(horizontal:0) , 
                  width: widget.scrollDirection == Axis.horizontal
                      ? widget.itemWidth
                      : null,
                  height: widget.itemHeight,
                  child: Column(
                    children: [
                      Material(
                        shape: widget.itemShape,              
                        elevation: 5,
                        color: Colors.white,
                        child: widget.itemBuilder(context, index),
                      ),
                     
                    ],
                  ),
                );
              },
              separatorBuilder: widget.separatorBuilder,
            ),
          ),
        ),
      ],
    );
  }
}
