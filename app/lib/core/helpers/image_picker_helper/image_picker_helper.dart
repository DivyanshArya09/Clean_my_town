import 'dart:io';

import 'package:app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerhelper {
  static Future<Either<Failure, File?>> pickImage(
      {ImageSource source = ImageSource.camera}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        XFile imageFile = await _compressFile(File(image.path));
        File imageFileFinal = File(imageFile.path);
        return Right(imageFileFinal);
      }
    } catch (e) {
      return Left(NormalFailure(message: e.toString()));
    }
    return const Right(null);
  }

  static Future<XFile> _compressFile(File file) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      var result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        outPath,
        quality: 25,
      ) as XFile;
      return result;
    } catch (e) {
      print('============IMAGE PICKER ERR=========================> $e');
      rethrow;
    }
  }
}
