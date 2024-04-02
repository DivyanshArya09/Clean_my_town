import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// Upload image to Firebase Storage
class FireBaseStorageHelper {
  Future<String> uploadImage(File imagePath) async {
    try {
      final path = 'files/${imagePath.path}.jpg';
      // Reference to the image location in Firebase Storage
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);

      // Upload the image file to Firebase Storage
      await ref.putFile(imagePath);

      // Get the download URL for the uploaded image
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

// Retrieve image URL from Firebase Storage
  Future<String?> getImageUrl(String objectId) async {
    try {
      // Reference to the image location in Firebase Storage
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('objects')
          .child('$objectId.jpg');

      // Get the download URL for the image
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error getting image URL: $e');
      return null;
    }
  }
}
