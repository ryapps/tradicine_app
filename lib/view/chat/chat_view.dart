import 'package:flutter/material.dart';
import 'package:tradicine_app/view/home/widgets/bottom_navbar.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Placeholder(),
          bottomNavigationBar: BottomNav(page: 2),

    );
  }
}