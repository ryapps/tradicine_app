import 'package:flutter/material.dart';
import 'package:tradicine_app/components/layout/bottom_dialog_layout.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/models/category/product_categories.dart';
import 'package:tradicine_app/services/category_service.dart';
import 'package:tradicine_app/services/product_service.dart';
import 'package:tradicine_app/models/product/product_model.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({super.key});

  @override
  _ProductManagementState createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();

  Future<void> _showProductDialog({Product? product}) async {
    final TextEditingController nameController =
        TextEditingController(text: product?.name ?? '');
    final TextEditingController priceController =
        TextEditingController(text: product?.price.toString() ?? '');
    final TextEditingController stockController =
        TextEditingController(text: product?.stock.toString() ?? '');
    final TextEditingController imageUrlController =
        TextEditingController(text: product?.imageUrl ?? '');
    final TextEditingController descController =
        TextEditingController(text: product?.productDesc ?? '');
    final TextEditingController ingredientsController =
        TextEditingController(text: product?.ingredients ?? '');
    final TextEditingController benefitsController =
        TextEditingController(text: product?.benefits ?? '');
    final TextEditingController usageController =
        TextEditingController(text: product?.usage ?? '');

    String? selectedCategory = product?.categoryId;
    List<Category> categories = await _categoryService.getAllCategories();
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (BuildContext context) => BottomDialogLayout(
              title: TitleText(
                text: product == null ? 'Tambah Produk' : 'Edit Produk',
                color: Colors.white,
              ),
              height: 1000,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Produk',
                          
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
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
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                          labelText: 'Harga',
                          labelStyle: TextStyle(color: Colors.black),
                          
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
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
                        keyboardType: TextInputType.number),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: stockController,
                        decoration: InputDecoration(
                          labelText: 'Stok',
                          labelStyle: TextStyle(color: Colors.black),
                          
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
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
                        keyboardType: TextInputType.number),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: imageUrlController,
                        decoration: InputDecoration(
                          labelText: 'URL Gambar',
                          labelStyle: TextStyle(color: Colors.black),
                          
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
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
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                          labelText: 'Kategori',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface,
                                width: 1),
                            borderRadius: BorderRadius.circular(15),
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
                          )),
                      dropdownColor: Colors.white,
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: descController,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi',
                          labelStyle: TextStyle(color: Colors.black),
                          
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
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
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: ingredientsController,
                        decoration: InputDecoration(
                          labelText: 'Bahan',
                          labelStyle: TextStyle(color: Colors.black),
                          
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
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
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: benefitsController,
                        decoration: InputDecoration(
                          labelText: 'Manfaat',
                          labelStyle: TextStyle(color: Colors.black),
                          
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
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
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: usageController,
                        decoration: InputDecoration(
                          labelText: 'Cara Penggunaan',
                          labelStyle: TextStyle(color: Colors.black),
                          
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
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
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Batal',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (product == null) {
                                _productService.addProduct(
                                  name: nameController.text,
                                  price: int.parse(priceController.text),
                                  stock: int.parse(stockController.text),
                                  imageUrl: imageUrlController.text,
                                  categoryId: selectedCategory!,
                                  productDesc: descController.text,
                                  ingredients: ingredientsController.text,
                                  benefits: benefitsController.text,
                                  usage: usageController.text,
                                  rating: 0,
                                  sold: 0,
                                );
                              } else {
                                _productService.updateProduct(
                                  product.id,
                                  name: nameController.text,
                                  price: int.parse(priceController.text),
                                  stock: int.parse(stockController.text),
                                  imageUrl: imageUrlController.text,
                                  categoryId: selectedCategory!,
                                  productDesc: descController.text,
                                  ingredients: ingredientsController.text,
                                  benefits: benefitsController.text,
                                  usage: usageController.text,
                                  rating: product.rating,
                                  sold: product.sold,
                                );
                              }
                              Navigator.pop(context);
                            },
                            child: Text('Simpan',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ])
                  ],
                ),
              ),
            ));
  }

  void _showDeleteConfirmationDialog(String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                _productService.deleteProduct(productId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TitleText(text: 'Manajemen Produk'),
          backgroundColor: Colors.white),
      body: StreamBuilder<List<Product>>(
        stream: _productService.getAllProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: snapshot.data!.map((product) {
                return Column(
                  children: [
                    ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(width: 1)),
                      leading: Image.network(product.imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(product.name),
                      subtitle: Text('Rp ${product.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  _showProductDialog(product: product)),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _showDeleteConfirmationDialog(product.id)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _showProductDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
