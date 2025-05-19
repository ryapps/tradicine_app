import 'package:flutter/material.dart';
import 'package:tradicine_app/components/text/body_text.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/services/auth.dart';
import 'package:tradicine_app/view/home/components/bestseller_product.dart';
import 'package:tradicine_app/view/home/components/doctor_banner.dart';
import 'package:tradicine_app/view/home/recipe/component/list_card_recipes.dart';
import 'package:tradicine_app/view/home/product/component/recommend_product.dart';
import 'package:tradicine_app/view/home/product/component/recommend_product_section.dart';
import 'package:tradicine_app/view/home/widgets/banner_carousel.dart';
import 'package:tradicine_app/view/home/widgets/bottom_navbar.dart';
import 'package:tradicine_app/view/home/widgets/header_home.dart';
import 'package:tradicine_app/dummy/img_banner.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AuthService _authService = AuthService();

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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView(
      children: [
        HeaderHome(),
        SizedBox(height: 20),
        BannerCarousel(
          listImg: DummyImgBanner.imgBanner,
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TitleText(text: 'Rekomendasi'),
        ),
        SizedBox(height: 20),
        RecommendProductSection(),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(text: 'Best Seller 🔥'),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: BodyText(
                    text: "Semua",
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        BestSellerProduct(),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(text: 'Resep Herbal  🌿'),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: BodyText(
                    text: "Semua",
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        RecipeList(),
        const SizedBox(height: 10),
        DoctorConsultBanner(
          onPressed: () {
            print('Navigasi ke konsultasi dokter');
          },
        ),
        const SizedBox(height: 20),
      ],
    )),
    bottomNavigationBar: BottomNav(page: 0),
    );

  }
}
