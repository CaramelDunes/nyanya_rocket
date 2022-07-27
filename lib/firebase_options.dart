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
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBExG_dHwDwU9H2mEwawd0p5pzy2Atm-IY',
    appId: '1:199775224910:web:18b9b8e49879d18152af1f',
    messagingSenderId: '199775224910',
    projectId: 'nyanya-rocket',
    authDomain: 'nyanya-rocket.firebaseapp.com',
    databaseURL: 'https://nyanya-rocket.firebaseio.com',
    storageBucket: 'nyanya-rocket.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQJpUFyeH5OEl6AdnziTI3J5-_9cibXTY',
    appId: '1:199775224910:android:8fb13b62d02bca4f',
    messagingSenderId: '199775224910',
    projectId: 'nyanya-rocket',
    databaseURL: 'https://nyanya-rocket.firebaseio.com',
    storageBucket: 'nyanya-rocket.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8V0_iMGUvimUu_O4dHSIMvZrJBWkNqoI',
    appId: '1:199775224910:ios:6dcccd8c7c7fa63852af1f',
    messagingSenderId: '199775224910',
    projectId: 'nyanya-rocket',
    databaseURL: 'https://nyanya-rocket.firebaseio.com',
    storageBucket: 'nyanya-rocket.appspot.com',
    androidClientId: '199775224910-lpenvrfoo0176g1rupnjvcuc36fee322.apps.googleusercontent.com',
    iosClientId: '199775224910-6nqslh31fs2tq0l8fci6qio4n5c9lj6r.apps.googleusercontent.com',
    iosBundleId: 'fr.carameldunes.nyanyaRocket',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB8V0_iMGUvimUu_O4dHSIMvZrJBWkNqoI',
    appId: '1:199775224910:ios:6dcccd8c7c7fa63852af1f',
    messagingSenderId: '199775224910',
    projectId: 'nyanya-rocket',
    databaseURL: 'https://nyanya-rocket.firebaseio.com',
    storageBucket: 'nyanya-rocket.appspot.com',
    androidClientId: '199775224910-lpenvrfoo0176g1rupnjvcuc36fee322.apps.googleusercontent.com',
    iosClientId: '199775224910-6nqslh31fs2tq0l8fci6qio4n5c9lj6r.apps.googleusercontent.com',
    iosBundleId: 'fr.carameldunes.nyanyaRocket',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBExG_dHwDwU9H2mEwawd0p5pzy2Atm-IY',
    appId: '1:199775224910:web:18b9b8e49879d18152af1f',
    messagingSenderId: '199775224910',
    projectId: 'nyanya-rocket',
    authDomain: 'nyanya-rocket.firebaseapp.com',
    databaseURL: 'https://nyanya-rocket.firebaseio.com',
    storageBucket: 'nyanya-rocket.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyBExG_dHwDwU9H2mEwawd0p5pzy2Atm-IY',
    appId: '1:199775224910:web:f292b6c062f6172852af1f',
    messagingSenderId: '199775224910',
    projectId: 'nyanya-rocket',
    authDomain: 'nyanya-rocket.firebaseapp.com',
    databaseURL: 'https://nyanya-rocket.firebaseio.com',
    storageBucket: 'nyanya-rocket.appspot.com',
  );
}
