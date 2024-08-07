part of 'main.dart';

class Authenticate extends AuthenticateUnit<Data> {
  Authenticate(Data data)
      : super(
          data: data,
          appleServiceId: 'com.laisiangtho.app.signin',
          redirectUri: 'https://lai-siangtho-app.firebaseapp.com/__/auth/handler',
        );
}
