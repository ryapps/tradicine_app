import 'package:flutter/material.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/services/auth.dart';
import 'package:tradicine_app/view/admin/category/category_management.dart';
import 'package:tradicine_app/view/admin/product_management/product_management.dart';
import 'package:tradicine_app/view/admin/recipes/recipes_management.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  AuthService _authService = AuthService();
  int _selectedIndex = 0;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: TitleText(
          text: "Dashboard Admin",
          color: Colors.white,
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () => _handleLogout(context))
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Center(child: Text("Selamat Datang di Dashboard Admin")),
          ProductManagement(),
          CategoryManagement(),
          RecipeManagement(),
          Center(child: Text("Selamat Datang di Transaksi Management")),
          Center(child: Text("Selamat Datang di User Management")),
        ],
      ),
      drawer: Drawer(       
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(             
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                "Admin Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Dashboard"),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("Produk"),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Kategori"),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("Resep"),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Transaksi"),
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("User"),
              onTap: () {
                setState(() {
                  _selectedIndex = 5;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}



//Deskripsi
// OB HERBAL merupakan obat herbal terstandar yang digunakan untuk membantu meredakan batuk dan membantu melegakan tenggorokan
// Indikasi Umum
// Membantu meredakan batuk dan membantu melegakan tenggorokan
// Komposisi

// Zingiberis Rhizoma 4.5; Kaempferiae Rhizoma 1.5 ; Citrus Aurantii fructus 1.5; Thymi Herba 1.5; Mentahae Folium 0.75; Myristicae Semen 0.75; Licorice 0.25
// Dosis
// Dewasa: 1 sendok makan (15 ml), 3 x sehari. Anak-anak > 2 tahun: 1/2 sendok makan (7,5 ml), 3 x sehari
// Aturan Pakai
// Sesudah makan. Kocok dahulu sebelum diminum.
// Perhatian
// Simpan ditempat yang kering, sejuk dan terhindar dari sinar matahari langsung. Simpan pada suhu dibawah 30 C.
// Golongan Produk
// Herbal
// Kemasan
// Botol @ 100 ml
// Manufaktur
// Deltomed Laboratories
// No. Registrasi