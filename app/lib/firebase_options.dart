// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyARt5qcJcoOXYRJ0ri9UH3_6dLxvimw7Hw',
    appId: '1:156421846422:web:d8d6fbfa13a498766719b7',
    messagingSenderId: '156421846422',
    projectId: 'clean-my-town-backend',
    authDomain: 'clean-my-town-backend.firebaseapp.com',
    storageBucket: 'clean-my-town-backend.appspot.com',
    measurementId: 'G-NJH3Q49KCV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD6t68EbGjuzBJLEfgjJhiX20nW467u4Yg',
    appId: '1:156421846422:android:bb7b284bb093c0bc6719b7',
    messagingSenderId: '156421846422',
    projectId: 'clean-my-town-backend',
    storageBucket: 'clean-my-town-backend.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDj0go9Rq6sbNOxFcC7_roY97cshxXPoxQ',
    appId: '1:156421846422:ios:7b00460b48f5343f6719b7',
    messagingSenderId: '156421846422',
    projectId: 'clean-my-town-backend',
    storageBucket: 'clean-my-town-backend.appspot.com',
    iosClientId: '156421846422-fdnm7ksd6jetmcmst5v29vknhpe937vr.apps.googleusercontent.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDj0go9Rq6sbNOxFcC7_roY97cshxXPoxQ',
    appId: '1:156421846422:ios:c8134d54932948cb6719b7',
    messagingSenderId: '156421846422',
    projectId: 'clean-my-town-backend',
    storageBucket: 'clean-my-town-backend.appspot.com',
    iosClientId: '156421846422-7853eoif5s8kqf3utre0si24umiusl0f.apps.googleusercontent.com',
    iosBundleId: 'com.example.app.RunnerTests',
  );
}
