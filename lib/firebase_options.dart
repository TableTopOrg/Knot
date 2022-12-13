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
    apiKey: 'AIzaSyAEP-JiVSof360uxOfzX9aIaqvQP1VUgTQ',
    appId: '1:343037176397:web:a4bdede20b616bd2194a04',
    messagingSenderId: '343037176397',
    projectId: 'knot-371113',
    authDomain: 'knot-371113.firebaseapp.com',
    databaseURL: 'https://knot-371113-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'knot-371113.appspot.com',
    measurementId: 'G-B9X6ZSKFGY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCETZpeD9vix5oHJDZQI6VEtoDbEHzYx_g',
    appId: '1:343037176397:android:133fe9428d5a2760194a04',
    messagingSenderId: '343037176397',
    projectId: 'knot-371113',
    databaseURL: 'https://knot-371113-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'knot-371113.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5-DEAmrlDVCogQ28lE6n931poZcKlyq4',
    appId: '1:343037176397:ios:24bb260063042eca194a04',
    messagingSenderId: '343037176397',
    projectId: 'knot-371113',
    databaseURL: 'https://knot-371113-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'knot-371113.appspot.com',
    iosClientId: '343037176397-q1s3inshdi8d7ogk4gmmiak2tnnk1mja.apps.googleusercontent.com',
    iosBundleId: 'com.example.knot',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5-DEAmrlDVCogQ28lE6n931poZcKlyq4',
    appId: '1:343037176397:ios:24bb260063042eca194a04',
    messagingSenderId: '343037176397',
    projectId: 'knot-371113',
    databaseURL: 'https://knot-371113-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'knot-371113.appspot.com',
    iosClientId: '343037176397-q1s3inshdi8d7ogk4gmmiak2tnnk1mja.apps.googleusercontent.com',
    iosBundleId: 'com.example.knot',
  );
}
