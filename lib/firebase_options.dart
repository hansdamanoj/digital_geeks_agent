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
    apiKey: 'AIzaSyDv68A23zKRH8qIWKWs_J3D0BYw3R60IUY',
    appId: '1:328790078986:web:759419be651d9c2c7651f3',
    messagingSenderId: '328790078986',
    projectId: 'agent-app-48e97',
    authDomain: 'agent-app-48e97.firebaseapp.com',
    storageBucket: 'agent-app-48e97.appspot.com',
    measurementId: 'G-0E0Z91XW4T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDaa8DiWAFd_JoIBGfoJYLesgQ00geAR5A',
    appId: '1:328790078986:android:eb56e6901156a1ff7651f3',
    messagingSenderId: '328790078986',
    projectId: 'agent-app-48e97',
    storageBucket: 'agent-app-48e97.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPTQhVukMgdLVe-eVZ5L6D_FgnIDEBs90',
    appId: '1:328790078986:ios:f69654f5e904809c7651f3',
    messagingSenderId: '328790078986',
    projectId: 'agent-app-48e97',
    storageBucket: 'agent-app-48e97.appspot.com',
    iosBundleId: 'com.digitalgeeks.agent.digitalGeeksAgent',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPTQhVukMgdLVe-eVZ5L6D_FgnIDEBs90',
    appId: '1:328790078986:ios:a65ae5c5e80d9f067651f3',
    messagingSenderId: '328790078986',
    projectId: 'agent-app-48e97',
    storageBucket: 'agent-app-48e97.appspot.com',
    iosBundleId: 'com.digitalgeeks.agent.digitalGeeksAgent.RunnerTests',
  );
}