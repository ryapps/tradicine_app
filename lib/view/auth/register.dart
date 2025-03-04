import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tradicine_app/components/button/button_component.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/label_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/services/auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hidePassword = true;
  String usernameInput = "";
  String emailInput = "";
  String passwordInput = "";
  String confirmPasswordInput = "";
  bool isAccept = false;
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void setUsername(String username) {
    setState(() {
      usernameInput = username;
    });
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

  void setConfirmPassword(String confirmPassword) {
    setState(() {
      confirmPasswordInput = confirmPassword;
    });
  }

  void setAccept(bool accept) {
    setState(() {
      isAccept = accept;
    });
  }

  String get getUsername {
    return usernameInput;
  }

  String get getEmail {
    return emailInput;
  }

  String get getPassword {
    return passwordInput;
  }

  String get getConfirmPassword {
    return confirmPasswordInput;
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

  void _register() async {
    if (_formKey.currentState!.validate()) {
      String name = getUsername.trim();
      String email = getEmail.trim();
      String password = getPassword.trim();

      User? user = await _authService.registerUser(
        name: name,
        email: email,
        password: password,
      );


      if (user != null) {
        
        Navigator.pushReplacementNamed(context, '/home');
        showCustomSnackbar(context, "Registrasi Berhasil");
      } else {
        showCustomSnackbar(context, "Registrasi Gagal", isError: true);
      }
    }
  }

  void _handleGoogleSignIn() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
      showCustomSnackbar(context, "Login Google Berhasil");
    } else {
      showCustomSnackbar(context, "Login Google Gagal", isError: true);
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
                  TitleText(text: 'Daftar'),
                  SizedBox(
                    height: 20,
                  ),
                  LabelText(
                    text: 'Username',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: usernameController,
                    onChanged: (value) => setUsername(value),
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                        value!.isEmpty ? 'Username wajib diisi' : null,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      hintText: "Jhon Doe",
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
                  ),
                  SizedBox(
                    height: 10,
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
                    validator: (value) => !value!.contains('@')
                        ? 'Email tidak valid'
                        : value!.isEmpty
                            ? 'Username wajib diisi'
                            : null,
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
                    validator: (value) => value!.length < 8
                        ? 'Password minimal 8 karakter'
                        : null,
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LabelText(
                    text: 'Konfirmasi Password',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    onChanged: (value) => setConfirmPassword(value),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: getHidePassword,
                    validator: (value) => value != passwordController.text
                        ? 'Password tidak cocok'
                        : null,
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
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isAccept,
                        onChanged: (value) => setAccept(!isAccept),
                        checkColor: Colors.white,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      BodyText(
                        text: 'Saya setuju dengan syarat dan ketentuan',
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                  ButtonComponent(
                    text: 'Daftar',
                    onPressed: _register,
                    radius: 15,
                    colorBackground: isAccept == true
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.surface,
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
                        text: 'Sudah punya akun?',
                        fontWeight: FontWeight.normal,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: LabelText(
                            text: 'Masuk',
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
