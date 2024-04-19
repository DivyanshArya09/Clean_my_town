import 'package:app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import '../../injection_container.dart' as di;

class AppManager {
  static Future<void> initialize() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // await Firebase.initializeApp();

    await di.init();
  }
}
