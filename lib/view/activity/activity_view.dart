import 'package:flutter/material.dart';
import 'package:tradicine_app/view/home/widgets/bottom_navbar.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Placeholder(),
      bottomNavigationBar: BottomNav(page: 3),
    );
  }
}