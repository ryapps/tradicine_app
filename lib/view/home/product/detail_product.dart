import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradicine_app/components/loading/shimmer_loading.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/icon_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/helpers/db_helper.dart';
import 'package:tradicine_app/models/cart/cart.dart';
import 'package:tradicine_app/models/product/product_model.dart';
import 'package:tradicine_app/services/product_service.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductService _productService = ProductService();
  bool _isFavorite = false;
  bool _isExpanded = false;
  final int _maxLines = 4;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Product?>(
        future: _productService.getProductById(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: ShimmerLoading(
              height: double.infinity,
              width: 500,
            ));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Produk tidak ditemukan"));
          }

          final product = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Stack(children: [
                    Image.network(
                      product.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor),
                            ),
                            color: Theme.of(context).primaryColor,
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 230),
                          IconButton(
                              onPressed: _toggleFavorite,
                              icon: _isFavorite == false
                                  ? Icon(Icons.favorite_border,
                                      color:
                                          Theme.of(context).colorScheme.surface)
                                  : Icon(Icons.favorite,
                                      color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
                // Nama produk
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleText(
                            text: product.name,
                          ),
                          IconText(
                              text: product.rating.toString(),
                              icon: Icons.star,
                              color: Colors.orange),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: BodyText(
                              text: "${product.sold} terjual",
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: product.stock > 0
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: BodyText(
                              text: product.stock > 0 ? "Tersedia" : "Habis",
                              color: product.stock > 0
                                  ? Colors.green
                                  : Colors.redAccent,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      TitleText(
                        text: "Rp${product.price.toString()}",
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black45.withOpacity(0.2),
                  thickness: 1,
                  height: 0.5,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(
                        text: "Deskripsi ",
                        size: 18,
                      ),
                      const SizedBox(height: 7),
                      AnimatedCrossFade(
                        crossFadeState: _isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                        firstChild: Text(
                          product.productDesc,
                          maxLines: _maxLines,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        secondChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyText(
                              text: product.productDesc,
                            ),
                            const SizedBox(height: 10),
                            TitleText(text: 'Kandungan', size: 16),
                            const SizedBox(height: 7),
                            BodyText(text: product.ingredients),
                            const SizedBox(height: 10),
                            TitleText(text: 'Manfaat', size: 16),
                            const SizedBox(height: 7),
                            BodyText(text: product.benefits),
                            const SizedBox(height: 10),
                            TitleText(text: 'Cara Penggunaan', size: 16),
                            const SizedBox(height: 7),
                            BodyText(text: product.usage),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Tautan 'Lihat semua deskripsi'
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isExpanded
                                  ? 'Sembunyikan deskripsi'
                                  : 'Lihat semua deskripsi',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).primaryColor,
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Theme.of(context).primaryColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black45.withOpacity(0.2),
                  thickness: 1,
                  height: 0.5,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(text: 'Ulasan', size: 18),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Lihat semua ulasan',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).primaryColor,
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Theme.of(context).primaryColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<Product?>(
          future: _productService.getProductById(widget.productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerLoading(
                width: double.infinity,
                height: 50,
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Terjadi error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("Produk tidak ditemukan"));
            }

            final product = snapshot.data!;
            return Container(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  final cartDb = DatabaseHelper();
                  final cartItem = CartItem(
                    id: product.id,
                    name: product.name,
                    imageUrl: product.imageUrl,
                    price: product.price,
                    quantity: 1, // Awalnya jumlah 1
                  );

                  await cartDb.addToCart(cartItem);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("${product.name} ditambahkan ke keranjang!")),
                  );
                },
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(320, 50)),
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                ),
                child: TitleText(
                  text: "Tambah ke Keranjang",
                  color: Colors.white,
                  size: 16,
                ),
              ),
            );
          }),
    );
  }
}
