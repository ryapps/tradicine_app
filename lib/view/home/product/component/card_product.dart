import 'package:flutter/material.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/icon_text.dart';
import 'package:tradicine_app/components/text/label_text.dart';
import 'package:tradicine_app/models/product/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tradicine_app/view/home/product/detail_product.dart';

class CardProduct extends StatefulWidget {
  final Product product;

  const CardProduct({super.key, required this.product});

  @override
  State<CardProduct> createState() => _CardProductState();
}

class _CardProductState extends State<CardProduct>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailPage(productId: widget.product.id),
            ));
      },
      child: Container(
        width: 136,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(1, 1)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
              width: 70,
              height: 70,
              placeholder: (context, url) => Container(
                width: 70,
                height: 70,
                color: Colors.grey[300], // Placeholder sebelum gambar muncul
              ),
              errorWidget: (context, url, error) => Icon(Icons.broken_image),
            )),
            SizedBox(height: 8),
            LabelText(
              text: widget.product.name,
            ),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: BodyText(
                text: "${widget.product.sold} terjual",
                color: Colors.amber,
              ),
            ),
            SizedBox(height: 6),
            LabelText(
              text: "Rp${widget.product.price.toString()}",
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 3,
            ),
            IconText(
                text: widget.product.rating.toString(),
                icon: Icons.star,
                color: Colors.orange),
          ],
        ),
      ),
    );
  }
}
