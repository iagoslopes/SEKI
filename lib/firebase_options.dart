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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS - '
          'Adicione manualmente as configurações do Firebase para iOS',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'Adicione manualmente as configurações do Firebase para macos',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'Adicione manualmente as configurações do Firebase para windows',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'Adicione manualmente as configurações do Firebase para linux',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não é suportado por essa plataforma.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: 'AIzaSyBZgW5hRt2LFMUw_AiNVUAebouuMAY1QI0',
      appId: '1:714606196800:android:323c0d2b49aca237be07a5',
      messagingSenderId: '714606196800',
      projectId: 'seki-99cd1',
      storageBucket: 'seki-99cd1.appspot.com');

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: 'AIzaSyBZgW5hRt2LFMUw_AiNVUAebouuMAY1QI0',
      appId: '1:714606196800:android:323c0d2b49aca237be07a5',
      messagingSenderId: '714606196800',
      projectId: 'seki-99cd1',
      storageBucket: 'seki-99cd1.appspot.com');
}
