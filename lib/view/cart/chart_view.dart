import 'package:flutter/material.dart';
import 'package:tradicine_app/view/home/widgets/bottom_navbar.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Placeholder(),
      bottomNavigationBar: BottomNav(page: 1),
    );
  }
}