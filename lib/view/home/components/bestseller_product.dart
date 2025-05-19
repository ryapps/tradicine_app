import 'package:flutter/material.dart';
import 'package:tradicine_app/models/product/product_model.dart';
import 'package:tradicine_app/services/product_service.dart';
import 'package:tradicine_app/view/home/product/component/card_product.dart';

class BestSellerProduct extends StatefulWidget {
  const BestSellerProduct({super.key});

  @override
  State<BestSellerProduct> createState() => _BestSellerProductState();
}

class _BestSellerProductState extends State<BestSellerProduct> {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [      
        SizedBox(
          height: 228, // Sesuaikan tinggi agar produk terlihat jelas
          child: StreamBuilder<List<Product>>(
            stream: _productService.getBestSellerProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Gagal memuat produk best seller"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Belum ada produk best seller"));
              }
    
              List<Product> products = snapshot.data!;
    
              return ListView.separated(
                itemCount: products.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 10),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  return Container(
                    margin: index == products.length - 1 ? EdgeInsets.only(right: 20) : index == 0 ? EdgeInsets.only(left: 20) : EdgeInsets.all(0),
                    child: CardProduct(product: products[index]));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
