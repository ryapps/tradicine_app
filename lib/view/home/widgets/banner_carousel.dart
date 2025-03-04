import 'package:flutter/material.dart';
import 'package:tradicine_app/components/custom/listview.dart';

class BannerCarousel extends StatefulWidget {
  List<String> listImg;
  BannerCarousel({super.key, required this.listImg});

  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomListView(
        itemCount: widget.listImg.length,
        itemWidth: 260,
        itemHeight: MediaQuery.of(context).size.height * 0.16,
        scrollDirection: Axis.horizontal,
        itemShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.listImg[index],
                    fit: BoxFit.cover,
                    height: 140,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Container(),
      ),
    );
  }
}
