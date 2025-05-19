import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputAddressDialog extends StatefulWidget {
  final String userId;
  const InputAddressDialog({Key? key, required this.userId}) : super(key: key);

  @override
  State<InputAddressDialog> createState() => _InputAddressDialogState();
}

class _InputAddressDialogState extends State<InputAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameRecieverController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simpan data alamat ke Firestore di dokumen user dengan merge
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set({
        'name_reciever': _nameRecieverController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
      }, SetOptions(merge: true));

      // Kembalikan data alamat sebagai Map ke pemanggil
      Navigator.of(context).pop({
        'name_reciever': _nameRecieverController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan alamat: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameRecieverController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Input Alamat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameRecieverController,
                decoration: InputDecoration(
                    labelText: 'Nama Penerima',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    )),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Masukkan nama Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    )),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Masukkan nomor telepon';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                    labelText: 'Alamat Lengkap',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    )),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Masukkan alamat lengkap';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Batal',
              style: TextStyle(
                color: Colors.red,
              )),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveAddress,
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text('Simpan',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )),
        ),
      ],
    );
  }
}
