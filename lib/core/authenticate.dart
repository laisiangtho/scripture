part of 'main.dart';

class Authenticate extends AuthenticateUnit {
  // Authentication({name, options}) : super(name: name, options: options);

  Authenticate({required super.data})
      : super(
          appleServiceId: 'com.laisiangtho.app.signin',
          redirectUri: 'https://lai-siangtho-app.firebaseapp.com/__/auth/handler',
        );
}
