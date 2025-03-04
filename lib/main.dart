import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tradicine_app/firebase_options.dart';
import 'package:tradicine_app/view/activity/activity_view.dart';
import 'package:tradicine_app/view/admin/dashboard_admin.dart';
import 'package:tradicine_app/view/auth/login.dart';
import 'package:tradicine_app/view/auth/register.dart';
import 'package:tradicine_app/view/cart/chart_view.dart';
import 'package:tradicine_app/view/chat/chat_view.dart';
import 'package:tradicine_app/view/home/home.dart';
import 'package:tradicine_app/view/onboarding/onboarding_widget.dart';
import 'package:tradicine_app/view/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Pastikan binding Flutter sudah siap
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
   FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // ✅ Mengaktifkan cache offline Firestore
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tradicine',
      initialRoute: '/',
      theme: ThemeData(
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Colors.white),
        textTheme: GoogleFonts.latoTextTheme(),
        primaryColor: Color.fromRGBO(62, 177, 74, 1),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Color.fromRGBO(158, 215, 164, 1),
            surface: Color.fromRGBO(127, 127, 127, 1),
            tertiary: Color.fromRGBO(5, 23, 44, 1)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromRGBO(62, 177, 74, 1), // Warna cursor
          selectionColor:
              Color.fromRGBO(62, 177, 74, 0.5), // Warna highlight teks yang dipilih
          selectionHandleColor:
              Color.fromRGBO(62, 177, 74, 1), // Warna titik pemegang seleksi teks
        ),
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginView(),
        '/register':(context) => RegisterView(),
        '/home' : (context) => HomeView(),
        '/cart': (context) => CartView(),
        '/chat': (context) => ChatView(),
        '/activity': (context) => ActivityView(),
        '/onboarding': (context) => OnBoardingView(),
        '/admin': (context) => DashboardAdmin()
      },
    );
  }
}
