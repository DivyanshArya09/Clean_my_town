import 'package:app/features/add_request/model/request_model.dart';
import 'package:app/features/add_request/presentation/models/location_model.dart';
import 'package:app/features/add_request/presentation/pages/add_request_page.dart';
import 'package:app/features/add_request/presentation/pages/request_detail_page.dart';
import 'package:app/features/auth/presentation/pages/login_page.dart';
import 'package:app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:app/features/auth/presentation/pages/verfy_email_page.dart';
import 'package:app/features/home/presentation/pages/home_page.dart';
import 'package:app/features/profile/presentation/pages/profile_page.dart';
import 'package:app/features/shared/splash_screen.dart';
import 'package:app/route/app_pages.dart';
import 'package:flutter/material.dart';

final kNavigatorKey = GlobalKey<NavigatorState>();

class CustomNavigator {
  static Route<dynamic> controller(RouteSettings settings) {
    switch (settings.name) {
      case AppPages.home:
        return MaterialPageRoute(
          builder: (context) => HomePage(
            locationModel: settings.arguments as LocationModel,
          ),
          settings: settings,
        );
      case AppPages.initial:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(
            isUserLoggingIn: settings.arguments as bool,
          ),
          settings: settings,
        );
      case AppPages.login:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
          settings: settings,
        );
      case AppPages.signup:
        return MaterialPageRoute(
          builder: (context) => const SignUpPage(),
          settings: settings,
        );
      case AppPages.addRequests:
        return MaterialPageRoute(
          builder: (context) => AddRequestPage(
            location: settings.arguments as LocationModel,
          ),
          settings: settings,
        );
      case AppPages.verfyemail:
        return MaterialPageRoute(
          builder: (context) => const VerfyEmail(),
          settings: settings,
        );
      case AppPages.profilePage:
        return MaterialPageRoute(
          builder: (context) => const ProfilePage(),
          settings: settings,
        );
      case AppPages.requestDetailPage:
        return MaterialPageRoute(
          builder: (context) {
            Map data = settings.arguments as Map;
            RequestModel request = data['request'] as RequestModel;
            RequestType requestType = data['requestType'] as RequestType;
            return RequestDetailPage(
              request: request,
              requestType: requestType,
            );
          },
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
    }
  }

  static Future<T?> pushTo<T extends Object?>(
    BuildContext context,
    String strPageName, {
    Object? arguments,
  }) async {
    return await Navigator.of(context, rootNavigator: true)
        .pushNamed(strPageName, arguments: arguments);
  }

  // Pop the top view
  static void pop(BuildContext context, {Object? result}) {
    Navigator.pop(context, result);
  }

  // Pops to a particular view
  static Future<T?> popTo<T extends Object?>(
    BuildContext context,
    String strPageName, {
    Object? arguments,
  }) async {
    return await Navigator.popAndPushNamed(
      context,
      strPageName,
      arguments: arguments,
    );
  }

  static void popUntilFirst(BuildContext context) {
    Navigator.popUntil(context, (page) => page.isFirst);
  }

  static void popUntilRoute(BuildContext context, String route, {var result}) {
    Navigator.popUntil(context, (page) {
      if (page.settings.name == route && page.settings.arguments != null) {
        (page.settings.arguments as Map<String, dynamic>)["result"] = result;
        return true;
      }
      return false;
    });
  }

  static Future<T?> pushReplace<T extends Object?>(
    BuildContext context,
    String strPageName, {
    Object? arguments,
  }) async {
    return await Navigator.pushReplacementNamed(
      context,
      strPageName,
      arguments: arguments,
    );
  }
}
