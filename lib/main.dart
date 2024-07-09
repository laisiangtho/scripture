// NOTE: Material
import 'package:flutter/material.dart';

// NOTE: SystemUiOverlayStyle
// import 'package:flutter/services.dart';

// NOTE: Privider: state management
import 'package:lidea/provider.dart';

import 'app.dart';
import 'initialize.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);

  await initializeApp();
  await App.core.ensureInitialized();

  runApp(const LaiSiangtho());
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]).then((_) {
  //   runApp(const Example());
  // });
}

class LaiSiangtho extends StatelessWidget {
  const LaiSiangtho({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Core>(
          create: (context) => App.core,
        ),
        // ChangeNotifierProvider<Preference>(
        //   create: (context) => App.preference,
        // ),
        ChangeNotifierProvider<Authenticate>(
          create: (context) => App.authenticate,
        ),
      ],
      builder: builder,
    );
  }

  Widget builder(BuildContext context, Widget? child) {
    return AnimatedBuilder(
      animation: App.preference,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          // key: const ValueKey('laisiangtho'),
          showSemanticsDebugger: false,
          debugShowCheckedModeBanner: false,

          restorationScopeId: 'lidea',
          // // locale: Localizations.localeOf(context),
          locale: App.preference.locale,
          localizationsDelegates: App.preference.localeDelegates,
          supportedLocales: App.preference.listOfLocale,
          theme: App.preference.light(context),
          darkTheme: App.preference.dark(context),
          themeMode: App.preference.themeMode,
          onGenerateTitle: (BuildContext context) => App.core.data.env.name,

          // routeInformationParser: NavigatorRouteInformationParser(),
          routeInformationParser: RouteParser(),
          routerDelegate: App.routeDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        );
      },
    );
  }

  // Widget builder(BuildContext context, Widget? child) {
  //   return AnimatedBuilder(
  //     animation: App.preference,
  //     builder: (BuildContext context, Widget? child) {
  //       return child!;
  //     },
  //     child: child,
  //   );
  // }

  // Widget builder(BuildContext context, Widget? child) {
  //   // return AnnotatedRegion<SystemUiOverlayStyle>(
  //   //   value: SystemUiOverlayStyle(
  //   //     systemNavigationBarColor: Theme.of(context).primaryColor,
  //   //     // systemNavigationBarDividerColor: Colors.transparent,
  //   //     // systemNavigationBarDividerColor: Colors.red,
  //   //     systemNavigationBarIconBrightness: App.preference.resolvedSystemBrightness,
  //   //     systemNavigationBarContrastEnforced: false,
  //   //     statusBarColor: Colors.transparent,
  //   //     statusBarBrightness: App.preference.systemBrightness,
  //   //     statusBarIconBrightness: App.preference.resolvedSystemBrightness,
  //   //     systemStatusBarContrastEnforced: false,
  //   //   ),
  //   //   child: child!,
  //   // );
  //   return child!;
  // }
}
