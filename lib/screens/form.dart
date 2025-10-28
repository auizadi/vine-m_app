// screens/form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yolo_grapevine/main.dart';
import 'dart:io';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedImagePath;
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap upload gambar terlebih dahulu')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(
        _selectedImagePath!,
      ).copy('${appDir.path}/$fileName');

      final profileBox = await Hive.openBox('userProfile');
      await profileBox.putAll({
        'nama': _nameController.text,
        'imagePath': savedImage.path,
        'lastUpdated': DateTime.now().toString(),
      });

      final settingsBox = Hive.box('settings');
      await settingsBox.put('profile_completed', true);
      await settingsBox.flush();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil disimpan!'),
          duration: Duration(seconds: 3),
        ),
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff7864f6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Added logo image with text below
              Column(
                children: [
                  SvgPicture.asset(
                    'android/app/src/main/assets/intro4.svg', // Replace with your actual image path

                    width: 230,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'One Step Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Satu langkah lagi dan\nanda siap menggunakan aplikasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),

              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: .3),
                  labelText: 'Masukkan nama anda',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xff7864f6),
                ),
                child: const Text(
                  'Upload gambar/foto',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              if (_selectedImagePath != null)
                Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.file(
                        File(_selectedImagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gambar yang dipilih:',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xff7864f6),
                ),
                child:
                    _isSubmitting
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text(
                          'Kirim',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
