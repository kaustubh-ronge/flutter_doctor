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
    apiKey: 'AIzaSyAbkFoq4vKhhk9NPAXAiU17EpysrmiB6Ok',
    appId: '1:366140014626:web:9ddb217c9a22cc829f4a7b',
    messagingSenderId: '366140014626',
    projectId: 'flutter-application-69bdd',
    authDomain: 'flutter-application-69bdd.firebaseapp.com',
    storageBucket: 'flutter-application-69bdd.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVRc76KUrrx6Vm4LnA9Y0JaRfPD6Y6o-E',
    appId: '1:366140014626:android:2a7728353898fa3f9f4a7b',
    messagingSenderId: '366140014626',
    projectId: 'flutter-application-69bdd',
    storageBucket: 'flutter-application-69bdd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCa2lU7tkSy-tsaE0YN_hLRGxHZTeXnDKE',
    appId: '1:366140014626:ios:6f6ed2c9c0e926ef9f4a7b',
    messagingSenderId: '366140014626',
    projectId: 'flutter-application-69bdd',
    storageBucket: 'flutter-application-69bdd.appspot.com',
    iosBundleId: 'com.example.androidApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCa2lU7tkSy-tsaE0YN_hLRGxHZTeXnDKE',
    appId: '1:366140014626:ios:6f6ed2c9c0e926ef9f4a7b',
    messagingSenderId: '366140014626',
    projectId: 'flutter-application-69bdd',
    storageBucket: 'flutter-application-69bdd.appspot.com',
    iosBundleId: 'com.example.androidApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAbkFoq4vKhhk9NPAXAiU17EpysrmiB6Ok',
    appId: '1:366140014626:web:b8c31641ef2556499f4a7b',
    messagingSenderId: '366140014626',
    projectId: 'flutter-application-69bdd',
    authDomain: 'flutter-application-69bdd.firebaseapp.com',
    storageBucket: 'flutter-application-69bdd.appspot.com',
  );
}
