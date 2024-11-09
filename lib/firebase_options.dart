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
    apiKey: 'AIzaSyAJNR7442oJo8-m1bOvv5AMSm926t7ceiY',
    appId: '1:111271853773:web:6d3fa0ee372387a7663384',
    messagingSenderId: '111271853773',
    projectId: 'mutualfundmanage',
    authDomain: 'mutualfundmanage.firebaseapp.com',
    storageBucket: 'mutualfundmanage.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwvqJzU8olhPasnlSh-Gy2w9WPHJAF5us',
    appId: '1:111271853773:ios:50afb8d35d0229b1663384',
    messagingSenderId: '111271853773',
    projectId: 'mutualfundmanage',
    storageBucket: 'mutualfundmanage.firebasestorage.app',
    iosBundleId: 'com.example.portfolio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD0--dzGa50GK07yzqxskzuM3m8l2eSelQ',
    appId: '1:612442983122:ios:05a8c4b81aa8a5fbf83b0b',
    messagingSenderId: '612442983122',
    projectId: 'portfoliomanage-ba393',
    storageBucket: 'portfoliomanage-ba393.firebasestorage.app',
    iosBundleId: 'com.example.portfolio',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJNR7442oJo8-m1bOvv5AMSm926t7ceiY',
    appId: '1:111271853773:web:e0b224f5091512a2663384',
    messagingSenderId: '111271853773',
    projectId: 'mutualfundmanage',
    authDomain: 'mutualfundmanage.firebaseapp.com',
    storageBucket: 'mutualfundmanage.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZNdn7x5YXZqFlCkNDG_QtxdOgDr0NJks',
    appId: '1:111271853773:android:0b5e630555058756663384',
    messagingSenderId: '111271853773',
    projectId: 'mutualfundmanage',
    storageBucket: 'mutualfundmanage.firebasestorage.app',
  );

}