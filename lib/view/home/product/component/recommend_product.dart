import 'package:flutter/material.dart';
import 'package:tradicine_app/components/loading/shimmer_loading.dart';
import 'package:tradicine_app/models/product/product_model.dart';
import 'package:tradicine_app/services/product_service.dart';
import 'package:tradicine_app/view/home/product/component/card_product.dart';

class RecommendProduct extends StatefulWidget {
  final String categoryId;

  const RecommendProduct({super.key, required this.categoryId});

  @override
  State<RecommendProduct> createState() => _RecommendProductState();
}

class _RecommendProductState extends State<RecommendProduct> {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,16,0,16),
      child: StreamBuilder<List<Product>>(
        stream: _productService.getProductsByCategoryId(widget.categoryId), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ShimmerLoading(height: 200,width: 115));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat produk"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada produk tersedia"));
          }

          List<Product> products = snapshot.data!;

          return Container(
            height: 200, // 🔹 Batasan tinggi agar tidak berantakan
            child: ListView.separated(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Container(
                  margin: index == products.length - 1 && products.length > 1 ? EdgeInsets.only(right: 20) : EdgeInsets.all(0),
                  child: CardProduct(product: products[index]));
              },
            ),
          );
        },
      ),
    );
  }
}
