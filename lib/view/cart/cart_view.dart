import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/subtitle_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/helpers/db_helper.dart';
import 'package:tradicine_app/models/cart/cart.dart';
import 'package:tradicine_app/view/home/widgets/bottom_navbar.dart';
import 'package:tradicine_app/view/transaction/checkout_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final DatabaseHelper _cartDb = DatabaseHelper();

  Future<void> _updateCart(CartItem item, bool increment) async {
    if (increment) {
      await _cartDb.addToCart(item);
    } else {
      await _cartDb.decrementQuantity(item);
    }
    setState(() {}); // Trigger rebuild untuk memperbarui FutureBuilder
  }
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleText(text: 'Keranjangku'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CartItem>>(
        future: _cartDb.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }
          final cartItems = snapshot.data ?? [];
          if (cartItems.isEmpty) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 120,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.25),
                    child: Icon(Icons.shopping_basket, size: 100, color: Theme.of(context).primaryColor)),
                ),
                SizedBox(height: 20),
                TitleText(text: "Keranjangmu masih kosong!",size: 18,),
                SizedBox(height: 10,),
                SubtitleText(text: "Tambahkan produk obat herbal yang telah tersedia",color: Theme.of(context).colorScheme.surface,)
              ],
            ));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(244, 244, 244, 1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.network(item.imageUrl, width: 48, height: 48),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SubtitleText(text: item.name),
                                SizedBox(height: 5),
                                SubtitleText(
                                  text: "Rp. ${item.price}",
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (item.quantity == 1) {
                                _cartDb.removeFromCart(item.id);
                                setState(() {
                                  cartItems.removeAt(index);
                                });
                              } else if (item.quantity >= 0) {
                                _updateCart(item, false);
                              } else {
                                return;
                              }
                            },
                            icon: Icon(Icons.remove_circle_outline),
                          ),
                          BodyText(text: item.quantity.toString()),
                          IconButton(
                            onPressed: () => _updateCart(item, true),
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubtitleText(
                            text: "Subtotal",
                            color: Theme.of(context).colorScheme.surface),
                        SubtitleText(
                          text:
                              "Rp.${cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity))}",
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutView(cartItems: cartItems,userId: userId,)));
                      },
                      style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size(320, 50)),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                      ),
                      child: TitleText(
                        text: "Checkout",
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNav(page: 1),
    );
  }
}
