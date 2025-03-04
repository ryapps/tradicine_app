import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';

final List<PageViewModel> pages = [
  PageViewModel(
    title: "",
    bodyWidget: Container(
      child: Column(
        children: [
          SizedBox(height: 30),
          Image.asset(
            'assets/images/onboarding1.png',
            width: 283,
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 275,
            child: TitleText(
              text:'Selamat Datang di Tradicine', 
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 275,
            child: BodyText(
                text:'Temukan berbagai obat herbal untuk kesehatan Anda.',
                textAlign: TextAlign.center,
               ),
          ),
        ],
      ),
    ),
    decoration: const PageDecoration(
      pageColor: Colors.white,
    ),
  ),
  PageViewModel(
    title: "",
    bodyWidget: Container(
      child: Column(
        children: [
          SizedBox(height: 80),
          Image.asset(
            'assets/images/onboarding2.png',
            width: 283,
          ),
          SizedBox(
            height: 70,
          ),
          Container(
            width: 275,
            child: TitleText(
              text:'Beragam Pilihan Obat Herbal',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 275,
            child: BodyText(
                text:'Pilih obat herbal sesuai kebutuhan Anda, dari berbagai kategori.',
                textAlign: TextAlign.center),
          ),
        ],
      ),
    ),
    decoration: const PageDecoration(
      pageColor: Colors.white,
    ),
  ),
  PageViewModel(
    title: "",

    bodyWidget: Container(
      child: Column(
        children: [
          Image.asset(
            'assets/images/onboarding3.png',
            width: 249,
          ),
          SizedBox(
            height: 47,
          ),
          Container(
            width: 275,
            child: TitleText(
              text:'Pemesanan Mudah',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 275,
            child: BodyText(
                text:'Pesan obat herbal langsung dari aplikasi dan kirim ke rumah Anda',
                textAlign: TextAlign.center),
          ),
        ],
      ),
    ),
    decoration: const PageDecoration(
      pageColor: Colors.white,
      
    ),
  ),
  PageViewModel(
    title: "",

    bodyWidget: Container(
      child: Column(
        children: [
          Image.asset(
            'assets/images/onboarding4.png',
            width: 210,
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 275,
            child: TitleText(
              text:'Siap Mulai?',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 275,
            child: BodyText(
                text:'Gabung sekarang juga!',
                textAlign: TextAlign.center),
          ),
        ],
      ),
    ),
    decoration: const PageDecoration(
      pageColor: Colors.white,
      
    ),
  ),
  
];
