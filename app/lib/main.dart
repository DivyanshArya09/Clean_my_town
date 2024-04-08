import 'package:app/core/constants/app_colors.dart';
import 'package:app/features/shared/splash_screen.dart';
import 'package:app/features/utils/overlay_manager.dart';
import 'package:app/firebase_options.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.primary,
              ),
            ),
          ),
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
            physics: const BouncingScrollPhysics(),
          ),
          builder: OverlayManager.transitionBuilder(),
          navigatorKey: kNavigatorKey,
          initialRoute: AppPages.initial,
          onGenerateRoute: CustomNavigator.controller,
          home: child,
        );
      },
      child: const SplashScreen(),
    );
    //
  }
}
