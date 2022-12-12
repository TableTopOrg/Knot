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
    apiKey: 'AIzaSyBfd8-coguafpQvbzIeQS6P0SfZHdcQK-k',
    appId: '1:333792263271:web:d90714b7806bc32f6d68c2',
    messagingSenderId: '333792263271',
    projectId: 'cse4186-ff4e8',
    authDomain: 'cse4186-ff4e8.firebaseapp.com',
    databaseURL: 'https://cse4186-ff4e8-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'cse4186-ff4e8.appspot.com',
    measurementId: 'G-98ZGJF7BHP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDvVOdXRB9kZOswY1r3HG0cKIj99SQER78',
    appId: '1:333792263271:android:879d7e8481b77b7a6d68c2',
    messagingSenderId: '333792263271',
    projectId: 'cse4186-ff4e8',
    databaseURL: 'https://cse4186-ff4e8-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'cse4186-ff4e8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBhAceAGNtXdt5MoMb59YEInbR62XriAeE',
    appId: '1:333792263271:ios:988507ac96fd749b6d68c2',
    messagingSenderId: '333792263271',
    projectId: 'cse4186-ff4e8',
    databaseURL: 'https://cse4186-ff4e8-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'cse4186-ff4e8.appspot.com',
    iosClientId: '333792263271-g9h30r8hjpnrun2o0apgcsu583sea6s4.apps.googleusercontent.com',
    iosBundleId: 'com.example.knot',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBhAceAGNtXdt5MoMb59YEInbR62XriAeE',
    appId: '1:333792263271:ios:988507ac96fd749b6d68c2',
    messagingSenderId: '333792263271',
    projectId: 'cse4186-ff4e8',
    databaseURL: 'https://cse4186-ff4e8-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'cse4186-ff4e8.appspot.com',
    iosClientId: '333792263271-g9h30r8hjpnrun2o0apgcsu583sea6s4.apps.googleusercontent.com',
    iosBundleId: 'com.example.knot',
  );
}
