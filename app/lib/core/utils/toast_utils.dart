import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelpers {
  static void showToast(String message, {bool err = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: err ? AppColors.err : AppColors.primary,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
