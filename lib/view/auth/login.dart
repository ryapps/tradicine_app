import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tradicine_app/components/button/button_component.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/label_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/services/auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  AuthService _authService = AuthService();

  bool hidePassword = true;
  String emailInput = "";
  String passwordInput = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void setEmail(String email) {
    setState(() {
      emailInput = email;
    });
  }

  void setPassword(String password) {
    setState(() {
      passwordInput = password;
    });
  }

  String get getEmail {
    return emailInput;
  }

  String get getPassword {
    return passwordInput;
  }

  changeObscurePassword(bool hide) {
    setState(() {
      hidePassword = hide;
    });
  }

  bool get getHidePassword {
    return hidePassword;
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

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = getEmail.trim();
      String password = getPassword.trim();

      User? user = await _authService.loginUser(
        email: email,
        password: password,
      );
      String? getRole = await _authService.getUserRole();

      if (user != null) {
        if (getRole == "admin") {
          Navigator.pushReplacementNamed(context, '/admin');
          showCustomSnackbar(context, "Login Berhasil");
        } else {
          Navigator.pushReplacementNamed(context, '/home');
          showCustomSnackbar(context, "Login Berhasil");
        }
      } else {
        showCustomSnackbar(context, "Login Gagal", isError: true);
      }
    }
  }

  void _handleGoogleSignIn() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');

      showCustomSnackbar(context, "Login Berhasil");
    } else {
      showCustomSnackbar(context, "Login Gagal", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Image.asset(
                  'assets/images/slogan_logo.png',
                  width: 140,
                ),
              ),
              Image.asset(
                'assets/images/leaf.png',
                width: 80,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(text: 'Masuk ke Beranda'),
                  SizedBox(
                    height: 20,
                  ),
                  LabelText(
                    text: 'Email',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailController,
                    onChanged: (value) => setEmail(value),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      hintText: "example@gmail.com",
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.surface)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .surface), // Warna border saat tidak fokus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2), // Warna border saat fokus
                      ),
                    ),
                    validator: (value) =>
                        !value!.contains('@') ? 'Email tidak valid' : null,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LabelText(
                    text: 'Password',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    onChanged: (value) => setPassword(value),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: getHidePassword,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      suffixIcon: GestureDetector(
                          onTap: () => changeObscurePassword(!getHidePassword),
                          child: Icon(hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .surface), // Warna border saat tidak fokus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2), // Warna border saat fokus
                      ),
                    ),
                    validator: (value) => value!.length < 8
                        ? 'Password minimal 8 karakter'
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: BodyText(
                            text: 'Lupa password?',
                            fontWeight: FontWeight.w600,
                          ))
                    ],
                  ),
                  ButtonComponent(
                    text: 'Masuk',
                    onPressed: _login,
                    radius: 15,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: BodyText(
                        text: 'Atau',
                        color: Theme.of(context).colorScheme.surface,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonComponent(
                    text: 'Masuk dengan Google',
                    onPressed: _handleGoogleSignIn,
                    radius: 15,
                    icon: Image.asset(
                      'assets/images/Google.png',
                      width: 18,
                    ),
                    colorBackground: Colors.white,
                    colorText: Theme.of(context).primaryColor,
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabelText(
                        text: 'Tidak punya akun?',
                        fontWeight: FontWeight.normal,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: LabelText(
                            text: 'Daftar',
                            color: Theme.of(context).primaryColor,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
