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
    apiKey: 'AIzaSyDdwPhbA4tiDpQ1OunluiSXdKdW1oZOgRQ',
    appId: '1:675044749792:web:12bcaba087c337f9977b85',
    messagingSenderId: '675044749792',
    projectId: 'imontir-3bed8',
    authDomain: 'imontir-3bed8.firebaseapp.com',
    storageBucket: 'imontir-3bed8.appspot.com',
    measurementId: 'G-P9N8M4MH26',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHmjERkGmXm1jTXgMnFiQXMqkLQSq4_mA',
    appId: '1:675044749792:android:c8a7278a728de98c977b85',
    messagingSenderId: '675044749792',
    projectId: 'imontir-3bed8',
    storageBucket: 'imontir-3bed8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAAFksZNJEAwa2XegOK9IWfRtpCm1kL_6M',
    appId: '1:675044749792:ios:f47c51e85722379e977b85',
    messagingSenderId: '675044749792',
    projectId: 'imontir-3bed8',
    storageBucket: 'imontir-3bed8.appspot.com',
    iosBundleId: 'com.example.imontir',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAAFksZNJEAwa2XegOK9IWfRtpCm1kL_6M',
    appId: '1:675044749792:ios:f47c51e85722379e977b85',
    messagingSenderId: '675044749792',
    projectId: 'imontir-3bed8',
    storageBucket: 'imontir-3bed8.appspot.com',
    iosBundleId: 'com.example.imontir',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDdwPhbA4tiDpQ1OunluiSXdKdW1oZOgRQ',
    appId: '1:675044749792:web:e30781e8edcb52fb977b85',
    messagingSenderId: '675044749792',
    projectId: 'imontir-3bed8',
    authDomain: 'imontir-3bed8.firebaseapp.com',
    storageBucket: 'imontir-3bed8.appspot.com',
    measurementId: 'G-8GVF2S05GP',
  );
}
