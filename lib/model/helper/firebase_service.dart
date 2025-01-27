import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseImageHelper {
  static Future<String> getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print("Error getting download URL: $e");
      }
      return ""; // Return empty if error
    }
  }
}
