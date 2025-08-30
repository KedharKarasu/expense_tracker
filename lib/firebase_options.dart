import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for linux');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNeaWEfwf-VAVCuCrXtNZaBtI3wB8mofQ',
    appId: '1:164501189722:android:416a4dfc3fbd750453d463',
    messagingSenderId: '164501189722',
    projectId: 'expense-tracker-1f708',
    storageBucket: 'expense-tracker-1f708.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPth2fQwmB38FWDnFnICgvcV-isd4D6BQ',
    appId: '1:164501189722:ios:2bc37f75eca33c5053d463',
    messagingSenderId: '164501189722',
    projectId: 'expense-tracker-1f708',
    storageBucket: 'expense-tracker-1f708.firebasestorage.app',
    iosBundleId: 'com.example.expenseTracker',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCme5NoWv3fLO2qPMcTpEdnLPhnucxf8Vk',
    appId: '1:164501189722:web:0e15b4c8465d5a9853d463',
    messagingSenderId: '164501189722',
    projectId: 'expense-tracker-1f708',
    authDomain: 'expense-tracker-1f708.firebaseapp.com',
    storageBucket: 'expense-tracker-1f708.firebasestorage.app',
    measurementId: 'G-E0HE4DEPMX',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDPth2fQwmB38FWDnFnICgvcV-isd4D6BQ',
    appId: '1:164501189722:ios:2bc37f75eca33c5053d463',
    messagingSenderId: '164501189722',
    projectId: 'expense-tracker-1f708',
    storageBucket: 'expense-tracker-1f708.firebasestorage.app',
    iosBundleId: 'com.example.expenseTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCme5NoWv3fLO2qPMcTpEdnLPhnucxf8Vk',
    appId: '1:164501189722:web:79265d04741b70d753d463',
    messagingSenderId: '164501189722',
    projectId: 'expense-tracker-1f708',
    authDomain: 'expense-tracker-1f708.firebaseapp.com',
    storageBucket: 'expense-tracker-1f708.firebasestorage.app',
    measurementId: 'G-G7C6K778WQ',
  );

}