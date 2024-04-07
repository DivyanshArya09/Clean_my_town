import 'dart:io';

import 'package:app/core/errors/failures.dart';
import 'package:app/core/helpers/firestore_helpers/firestore_helpers.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// Upload image to Firebase Storage
class FireBaseStorageHelper {
  FireStoreHelpers fireStoreHelpers = FireStoreHelpers();
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

  Future<Either<Failure, String>> uploadProfilePicture(File imagePath) async {
    try {
      final path = 'files/${imagePath.path}.jpg';
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(imagePath);
      final imageUrl = await ref.getDownloadURL();
      await fireStoreHelpers.updateUser(['profilePicture'], [imageUrl]);
      return Right(imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
      Left(NormalFailure(message: e.toString()));
    }
    return const Right('');
  }

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
