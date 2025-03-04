import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradicine_app/services/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate(); // Memulai navigasi saat splash screen dimulai
  }

  AuthService _authService = AuthService();

  void _navigate() async {
    // Durasi splash screen
    await Future.delayed(Duration(seconds: 3));

    // Periksa status onboarding
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? onboardingCompleted = prefs.getBool('onboarding_completed');

    // Periksa apakah user sudah login
    bool isLoggedIn = await AuthService().isLoggedIn();

    String? getRole = await _authService.getUserRole();

    if (await isLoggedIn) {
      // Jika user sudah login, menuju HomePage
      if (getRole == "admin") {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else if (onboardingCompleted ?? false) {
      // Jika onboarding selesai tetapi belum login, menuju LoginPage
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Jika onboarding belum selesai, menuju OnboardingPage
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang splash screen
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 175,
        ),
      ),
    );
  }
}
