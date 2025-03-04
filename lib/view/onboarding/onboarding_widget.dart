import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:tradicine_app/components/text/subtitle_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradicine_app/view/onboarding/onboarding_page.dart';

class OnBoardingView extends StatelessWidget {
  OnBoardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages,
      onDone: () async {
        // Simpan status onboarding selesai
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboarding_completed', true);

        // Navigasi ke LoginPage
        Navigator.pushReplacementNamed(context, '/login');
      },
      onSkip: () async {
        // Simpan status onboarding selesai
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboarding_completed', true);

        // Navigasi ke LoginPage
        Navigator.pushReplacementNamed(context, '/login');
      },
      skipStyle: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent)),
      nextStyle: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent)),
      doneStyle: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent)),
      showSkipButton: true,
      skip: Padding(
        padding: const EdgeInsets.only(top: 200, right: 30),
        child: SubtitleText(
          text: 'Lewati',
          color: Colors.grey,
        ),
      ),
      next: Padding(
        padding: const EdgeInsets.only(top: 200.0, left: 30),
        child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 25,
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            )),
      ),
      showNextButton: true,
      showDoneButton: true,
      done: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadiusDirectional.circular(10)),
        margin: EdgeInsets.only(top: 210),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SubtitleText(
          text: "Ayo Mulai",
          color: Colors.white,
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(10, 10),
        activeSize: const Size(25.0, 10.0), // Ukuran titik aktif lebih besar
        activeColor: Theme.of(context).primaryColor,
       spacing: EdgeInsets.fromLTRB(0, 0, 7, 120), 
        color: Colors.grey,
        activeShape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15.0), // Pastikan bentuk aktif sama
        ),
      ),
      dotsContainerDecorator: BoxDecoration(
        color: Colors.transparent, // Pastikan tidak ada background
        borderRadius: BorderRadius.circular(8),
        shape: BoxShape.rectangle, // Pastikan bentuknya persegi
      ),
    );
  }
}
