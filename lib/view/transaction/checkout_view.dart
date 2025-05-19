import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/subtitle_text.dart';
import 'package:tradicine_app/helpers/db_helper.dart';
import 'package:tradicine_app/models/cart/cart.dart';
import 'package:tradicine_app/services/transaction_service.dart';
import 'package:tradicine_app/services/user_service.dart';
import 'package:tradicine_app/view/home/widgets/bottom_navbar.dart';
import 'package:tradicine_app/view/transaction/input_address.dart';
import 'package:tradicine_app/view/transaction/success_order_screen.dart';

class CheckoutView extends StatefulWidget {
  final List<CartItem> cartItems;
  final int deliveryFee;
  final String userId;

  const CheckoutView({
    Key? key,
    required this.userId,
    required this.cartItems,
    this.deliveryFee = 15000,
  }) : super(key: key);

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String? _nameReciever;
  String? _phone;
  String? _address;
  String selectedPaymentMethod = 'COD';
  final TransactionService _transactionService = TransactionService();
  final DatabaseHelper _cartDb = DatabaseHelper();

  int get subtotal => widget.cartItems
      .fold(0, (sum, item) => sum + (item.price * item.quantity));

  void initState() {
    super.initState();
    _loadUserData();
  }

  void _placeOrder() async {
    if (_address == null || selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Silakan isi alamat dan pilih metode pembayaran')),
      );
      return;
    }
    _cartDb.clearCart();
    await _transactionService.saveTransaction(
      widget.cartItems,
      subtotal.toDouble() + widget.deliveryFee,
      selectedPaymentMethod!,
    );

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SuccessOrderScreen()),
        (route) => false);
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot userDoc = await UserService().getUser(widget.userId);

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _nameReciever = data['name_reciever'];
          _phone = data['phone'];
          _address = data['address'];
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    int total = subtotal + widget.deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: TitleText(text: 'Checkout'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color.fromRGBO(244, 244, 244, 1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 0,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await showDialog<Map<String, String>>(
                        context: context,
                        builder: (context) =>
                            InputAddressDialog(userId: widget.userId),
                      );
                      if (result != null) {
                        setState(() {
                          _nameReciever = result['name_reciever'];
                          _phone = result['phone'];
                          _address = result['address'];
                        });
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.location_on,
                                color: Theme.of(context).primaryColor)),
                        const SizedBox(width: 10),
                        if (_address != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                text: _nameReciever!,
                                size: 14,
                              ),
                              BodyText(
                                text: _phone!,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              SubtitleText(
                                text: _address!,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ],
                          )
                        else
                          SubtitleText(text: 'Klik untuk menambahkan alamat'),
                        const Spacer(),
                        Icon(
                          Icons.navigate_next,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.delivery_dining,
                            color: Theme.of(context).primaryColor,
                          )),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(
                            text: 'Estimasi Pengiriman',
                            size: 14,
                          ),
                          SubtitleText(
                            text: "45 - 60 menit",
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            TitleText(
              text: 'Metode Pembayaran',
              size: 18,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(244, 244, 244, 1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 0,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  RadioListTile(
                    title: SubtitleText(text: 'Kartu Kredit'),
                    subtitle: BodyText(
                        text: 'Visa, Mastercard, JCB',
                        color: Theme.of(context).colorScheme.surface),
                    value: 'Kartu Kredit',
                    activeColor: Theme.of(context).primaryColor,
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) =>
                        setState(() => selectedPaymentMethod = value as String),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Divider(color: Colors.grey),
                  ),
                  RadioListTile(
                    title: SubtitleText(text: 'COD (Bayar di Tempat)'),
                    value: 'COD',
                    activeColor: Theme.of(context).primaryColor,
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) =>
                        setState(() => selectedPaymentMethod = value as String),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 189,
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
                    text: 'Subtotal',
                    color: Theme.of(context).colorScheme.surface),
                SubtitleText(
                    text: "Rp${subtotal.toString()}",
                    color: Theme.of(context).colorScheme.surface),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SubtitleText(
                  text: 'Biaya Ongkir',
                  color: Theme.of(context).colorScheme.surface,
                ),
                SubtitleText(
                    text: "Rp${widget.deliveryFee.toString()}",
                    color: Theme.of(context).colorScheme.surface),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleText(
                  text: 'Total',
                  size: 16,
                ),
                TitleText(
                  text: "Rp${total.toString()}",
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _placeOrder,
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(320, 50)),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              child: TitleText(
                text: "Pesan",
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
