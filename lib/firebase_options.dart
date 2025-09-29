// File generated manually (normally via FlutterFire CLI).
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// 
/// Example:
/// ```dart
/// import 'firebase_options.dart';
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android. '
          'Run `flutterfire configure` to re-generate.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS. '
          'Run `flutterfire configure` to re-generate.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS. '
          'Run `flutterfire configure` to re-generate.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Windows. '
          'Run `flutterfire configure` to re-generate.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux. '
          'Run `flutterfire configure` to re-generate.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Web config from Firebase Console
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyA0NCqiERZ_zw4ARnl1xd7_z4eUcECvIZQ",
    authDomain: "salon-booking-app-001.firebaseapp.com",
    projectId: "salon-booking-app-001",
    storageBucket: "salon-booking-app-001.appspot.com", // ✅ corrected
    messagingSenderId: "75962857233",
    appId: "1:75962857233:web:140c9b655cfec84a203eb0", // ✅ corrected
  );
}

