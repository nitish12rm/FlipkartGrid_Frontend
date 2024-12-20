// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCs7VITxQbPm9lU1dUH2ZfeD_Wa_FG8JhQ',
    appId: '1:518384174562:web:3808c7500ec3bc24c4a5bb',
    messagingSenderId: '518384174562',
    projectId: 'flipkart-grid-abyss',
    authDomain: 'flipkart-grid-abyss.firebaseapp.com',
    storageBucket: 'flipkart-grid-abyss.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyuhcnp-MrjJTGthRtDaZgcr2X8F_esFQ',
    appId: '1:518384174562:android:ca94c1b83ff812f6c4a5bb',
    messagingSenderId: '518384174562',
    projectId: 'flipkart-grid-abyss',
    storageBucket: 'flipkart-grid-abyss.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMSf5Tj9n93-TZMs24X6TBgyfx8CzyJ3w',
    appId: '1:518384174562:ios:e25f4b18d9929146c4a5bb',
    messagingSenderId: '518384174562',
    projectId: 'flipkart-grid-abyss',
    storageBucket: 'flipkart-grid-abyss.appspot.com',
    iosBundleId: 'com.example.flipmlkitocr',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAMSf5Tj9n93-TZMs24X6TBgyfx8CzyJ3w',
    appId: '1:518384174562:ios:e25f4b18d9929146c4a5bb',
    messagingSenderId: '518384174562',
    projectId: 'flipkart-grid-abyss',
    storageBucket: 'flipkart-grid-abyss.appspot.com',
    iosBundleId: 'com.example.flipmlkitocr',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCs7VITxQbPm9lU1dUH2ZfeD_Wa_FG8JhQ',
    appId: '1:518384174562:web:15f129ae5ddd8a74c4a5bb',
    messagingSenderId: '518384174562',
    projectId: 'flipkart-grid-abyss',
    authDomain: 'flipkart-grid-abyss.firebaseapp.com',
    storageBucket: 'flipkart-grid-abyss.appspot.com',
  );
}
