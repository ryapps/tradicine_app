import 'package:flutter/material.dart';
import 'dart:async';

class BottomNav extends StatefulWidget {
  final int page;
  const BottomNav({Key? key, required this.page}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  Future<void> getPage(int index) async {
    if (index == 0) {
      await Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      await Navigator.pushReplacementNamed(context, '/cart');
    } else if (index == 2) {
      await Navigator.pushReplacementNamed(context, '/chat');
    } else if (index == 3) {
      await Navigator.pushReplacementNamed(context, '/activity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      // Margin agar bar tidak menempel ke tepi layar
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(50),
        
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(     
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(      
          backgroundColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedItemColor: Colors.white,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          currentIndex: widget.page,
          onTap: (int index) {
            getPage(index);
          },
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.home_filled,
                size: 27,
              ),
              icon: Icon(
                Icons.home_filled,
                size: 27,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.shopping_cart,
                size: 27,
              ),
              icon: Icon(
                Icons.shopping_cart_outlined,
                size: 27,
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.chat_bubble,
                size: 27,
              ),
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 27,
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.receipt_long,
                size: 27,
              ),
              icon: Icon(
                Icons.receipt_long_outlined,
                size: 27,
              ),
              label: 'Aktivitas',
            )
          ],
        ),
      ),
    );
  }
}
