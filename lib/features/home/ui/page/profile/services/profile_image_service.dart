import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageService {
  final ImagePicker _picker = ImagePicker();

  // untuk pilih gambar, simpan lalu mengembalikan File baru
  Future<File?> pickAndSaveImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return null; // jika user membatalkan pemilihan gambar
    }

    // get direktori pribadi aplikasi
    final directory = await getApplicationDocumentsDirectory();
    // buat nama file yang unik
    final fileName = 'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final newPath = p.join(directory.path, fileName);

    // salin file gambar ke direktori aplikasi
    final newImageFile = await File(pickedFile.path).copy(newPath);

    // simpan path baru ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', newPath);

    return newImageFile;
  }

  // untuk memuat gambar dari path yang tersimpan
  Future<File?> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_path');

    if (imagePath == null) {
      return null; // jika tidak ada gambar yang tersimpan
    }

    final imageFile = File(imagePath);
    if (await imageFile.exists()) {
      return imageFile;
    }
    
    return null; // jika file tidak ditemukan 
  }
}