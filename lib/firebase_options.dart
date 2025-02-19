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
    apiKey: 'AIzaSyC_FWBGnJKyqkvbd1smAa5-Fk2nrUgdtbU',
    appId: '1:537267851900:web:12d19a24642ca3b4d06ff9',
    messagingSenderId: '537267851900',
    projectId: 'notes-app-9f7bb',
    authDomain: 'notes-app-9f7bb.firebaseapp.com',
    storageBucket: 'notes-app-9f7bb.firebasestorage.app',
    measurementId: 'G-XJVD4W0YZT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOeBPNtzGeb3INIZ3JCVyndGEzNcbsaKk',
    appId: '1:537267851900:android:713b35562afbe068d06ff9',
    messagingSenderId: '537267851900',
    projectId: 'notes-app-9f7bb',
    storageBucket: 'notes-app-9f7bb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcw0FagTOc3_ITDmYz_I_85MCRElhZJ8I',
    appId: '1:537267851900:ios:a0335276a79b336bd06ff9',
    messagingSenderId: '537267851900',
    projectId: 'notes-app-9f7bb',
    storageBucket: 'notes-app-9f7bb.firebasestorage.app',
    iosBundleId: 'com.example.notesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDcw0FagTOc3_ITDmYz_I_85MCRElhZJ8I',
    appId: '1:537267851900:ios:a0335276a79b336bd06ff9',
    messagingSenderId: '537267851900',
    projectId: 'notes-app-9f7bb',
    storageBucket: 'notes-app-9f7bb.firebasestorage.app',
    iosBundleId: 'com.example.notesApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC_FWBGnJKyqkvbd1smAa5-Fk2nrUgdtbU',
    appId: '1:537267851900:web:0ef658cdea98b06bd06ff9',
    messagingSenderId: '537267851900',
    projectId: 'notes-app-9f7bb',
    authDomain: 'notes-app-9f7bb.firebaseapp.com',
    storageBucket: 'notes-app-9f7bb.firebasestorage.app',
    measurementId: 'G-XDL1WTMYBH',
  );
}
