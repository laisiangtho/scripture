part of data.core;

class Authentication extends UnitAuthentication {
  // Authentication({name, options}) : super(name: name, options: options);
  Authentication()
      : super(
          appleServiceId: 'com.laisiangtho.app.signin',
          redirectUri: 'https://lai-siangtho-app.firebaseapp.com/__/auth/handler',
        );
}
