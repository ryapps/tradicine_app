import 'package:flutter/material.dart';
import 'package:tradicine_app/components/text/subtitle_text.dart';
import 'package:tradicine_app/services/auth.dart';

class HeaderHome extends StatefulWidget {
  const HeaderHome({super.key});

  @override
  _HeaderHomeState createState() => _HeaderHomeState();
}

class _HeaderHomeState extends State<HeaderHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _inAnimation;
  late Animation<Offset> _outAnimation;

  AuthService _authService = AuthService();

  final List<String> searchSuggestions = [
    "Olahan Temulawak",
    "Jamu Kunyit Asam",
    "Wedang Jahe",
    "Obat Herbal Alami",
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _inAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _outAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startTextAnimation();
  }

  void _startTextAnimation() {
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;

      setState(() {
        _currentIndex = (_currentIndex + 1) % searchSuggestions.length;
      });

      _controller.forward(from: 0);
      _startTextAnimation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void showCustomSnackbar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      padding: EdgeInsets.all(10),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Text(
              "Tutup",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor:
          isError ? Colors.redAccent : Theme.of(context).primaryColor,
      behavior: SnackBarBehavior.floating,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.all(20),
      duration: Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleLogout(BuildContext context) async {
    await _authService.logoutUser();
    showCustomSnackbar(context, 'Logout Berhasil');

    // Navigasi kembali ke halaman login
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/slogan_logo.png',
                width: 140,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _handleLogout(context),
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              print("🔍 Search Clicked!");
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  SizedBox(width: 10),

                  // 🔹 ANIMASI TEKS BERGANTIAN DENGAN EFEK SLIDE
                  Expanded(
                    child: ClipRect(
                      child: Stack(
                        children: [
                          // Teks yang keluar (fade out)
                          SlideTransition(
                            position: _outAnimation,
                            child: SubtitleText(
                              text: searchSuggestions[(_currentIndex -
                                      1 +
                                      searchSuggestions.length) %
                                  searchSuggestions.length],
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),

                          // Teks yang masuk (slide in)
                          SlideTransition(
                            position: _inAnimation,
                            child: SubtitleText(
                              text: searchSuggestions[_currentIndex],
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
