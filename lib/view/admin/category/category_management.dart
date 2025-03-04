import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradicine_app/components/text/title_text.dart';
import 'package:tradicine_app/services/category_service.dart';

class CategoryManagement extends StatefulWidget {
  const CategoryManagement({super.key});

  @override
  _CategoryManagementState createState() => _CategoryManagementState();
}

class _CategoryManagementState extends State<CategoryManagement> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  CategoryService _categoryService = CategoryService();
  String? _editingCategoryId;

  void _showCategoryDialog({String? categoryId, String? categoryName, String? categoryImg}) {
    _nameController.text = categoryName ?? '';
    _imgController.text = categoryImg ?? '';
    _editingCategoryId = categoryId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(categoryId == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Kategori'),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _imgController,
              decoration: InputDecoration(labelText: 'Gambar Kategori'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_editingCategoryId == null) {
                _categoryService.addCategory(_nameController.text,_imgController.text);
              } else {
                _categoryService.updateCategory(_editingCategoryId!, _nameController.text,_imgController.text);
              }
              Navigator.pop(context);
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
  void _showDeleteConfirmationDialog(String categoryId) {
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
              _categoryService.deleteCategory(categoryId);
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
          title: TitleText(text: 'Manajemen Kategori'),
          backgroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          var categories = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.separated(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var category = categories[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(width: 1)),
                  leading: Image.network(category['img']),    
                  title: Text(category['name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showCategoryDialog(
                          categoryId: category.id,
                          categoryName: category['name'],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmationDialog(category.id),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _showCategoryDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
