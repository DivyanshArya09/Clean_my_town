import 'dart:async';

import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VerfyEmail extends StatefulWidget {
  const VerfyEmail({super.key});

  @override
  State<VerfyEmail> createState() => _VerfyEmailState();
}

class _VerfyEmailState extends State<VerfyEmail> {
  bool isVerified = false;
  Timer? _timer;

  Future _checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (isVerified) {
        CustomNavigator.pushReplace(context, AppPages.home);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isVerified) {
      _sendEmailVerification();
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        _checkEmailVerified();
      });
    } else {
      CustomNavigator.pushReplace(context, AppPages.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: DEFAULT_Horizontal_PADDING,
            vertical: DEFAULT_VERTICAL_PADDING),
        height: MediaQuery.of(context).size.height,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'An email has been sent to\n${FirebaseAuth.instance.currentUser!.email} please verify',
              style: AppStyles.headingDark,
              textAlign: TextAlign.center,
            ),
            CustomSpacers.height16,
            SizedBox(
              height: MediaQuery.of(context).size.height * .35,
              child: SvgPicture.asset(AppImages.volunteers),
            )
          ],
        ),
      ),
    );
  }

  Future _sendEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      ToastHelpers.showToast(e.toString());
    }
  }
}
