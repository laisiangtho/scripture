import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';
import 'package:lidea/authentication.dart';

// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'package:bible/core.dart';
import 'package:bible/settings.dart';

import 'core/theme/data.dart';
import 'view/app.routes.dart';

// const bool isProduction = bool.fromEnvironment('dart.vm.product');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  // }

  final authentication = Authentication();
  await authentication.ensureInitialized();

  final core = Core(authentication);
  await core.ensureInitialized();
  authentication.stateObserver(core.userObserver);

  final settings = SettingsController(SettingsService(core.collection));
  await settings.ensureInitialized();

  runApp(LaiSiangtho(
    core: core,
    settings: settings,
    authentication: authentication,
  ));
}

class LaiSiangtho extends StatelessWidget {
  const LaiSiangtho({
    Key? key,
    required this.core,
    required this.settings,
    required this.authentication,
  }) : super(key: key);

  final Authentication authentication;
  final Core core;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ViewScrollNotify>(
          create: (context) => ViewScrollNotify(),
        ),
        ChangeNotifierProvider<Core>(
          create: (context) => core,
        ),
        ChangeNotifierProvider<SettingsController>(
          create: (context) => settings,
        ),
        ChangeNotifierProvider<Authentication>(
          create: (context) => authentication,
        ),
        ChangeNotifierProvider<NavigatorNotify>(
          create: (context) => NavigatorNotify(),
        ),
      ],
      child: start(),
    );
  }

  Widget start() {
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settings,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          showSemanticsDebugger: false,
          // debugShowCheckedModeBanner: false,

          restorationScopeId: 'lidea',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: settings.locale,
          supportedLocales: const [
            // English
            Locale('en', 'GB'),
            // Norwegian
            Locale('no', 'NO'),
            // Myanmar
            Locale('my', ''),
          ],
          darkTheme: IdeaData.dark(context),
          theme: IdeaData.light(context),
          themeMode: settings.themeMode,
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appLaiSiangtho,

          initialRoute: AppRoutes.rootInitial,
          routes: AppRoutes.rootMap,
          navigatorObservers: [
            NavigatorNotifyObserver(
              Provider.of<NavigatorNotify>(
                context,
                listen: false,
              ),
            ),
          ],
          builder: (BuildContext context, Widget? view) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                systemNavigationBarColor: Theme.of(context).primaryColor,
                systemNavigationBarDividerColor: Colors.transparent,
                systemNavigationBarIconBrightness: settings.resolvedSystemBrightness,
                systemNavigationBarContrastEnforced: true,
                statusBarColor: Colors.transparent,
                statusBarBrightness: settings.resolvedSystemBrightness,
                statusBarIconBrightness: settings.resolvedSystemBrightness,
                systemStatusBarContrastEnforced: true,
              ),
              child: view!,
            );
          },
          /*
          home: Builder(
            builder: (BuildContext context) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  systemNavigationBarColor: Theme.of(context).primaryColor,
                  systemNavigationBarDividerColor: Colors.transparent,
                  systemNavigationBarIconBrightness: settings.resolvedSystemBrightness,
                  systemNavigationBarContrastEnforced: true,
                  statusBarColor: Colors.transparent,
                  statusBarBrightness: settings.resolvedSystemBrightness,
                  statusBarIconBrightness: settings.resolvedSystemBrightness,
                  systemStatusBarContrastEnforced: true,
                ),
                child: AppMain(settings: settings),
              );
            },
          ),
          onGenerateRoute: (RouteSettings route) => PageRouteBuilder<void>(
            settings: route,
            pageBuilder: (BuildContext context, Animation<double> a, Animation<double> b) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  systemNavigationBarColor: Theme.of(context).primaryColor,
                  systemNavigationBarDividerColor: Colors.transparent,
                  systemNavigationBarIconBrightness: settings.resolvedSystemBrightness,
                  systemNavigationBarContrastEnforced: true,
                  statusBarColor: Colors.transparent,
                  statusBarBrightness: settings.resolvedSystemBrightness,
                  statusBarIconBrightness: settings.resolvedSystemBrightness,
                  systemStatusBarContrastEnforced: true,
                ),
                child: AppMain(settings: settings),
              );
            },
          ),
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                controller.context = context;
                switch (routeSettings.name) {
                  case AppMain.routeName:
                  default:
                    return AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle(
                        systemNavigationBarColor: Theme.of(context).primaryColor,
                        systemNavigationBarDividerColor: Colors.transparent,
                        systemNavigationBarIconBrightness: controller.resolvedSystemBrightness,
                        systemNavigationBarContrastEnforced: true,
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: controller.resolvedSystemBrightness,
                        statusBarIconBrightness: controller.resolvedSystemBrightness,
                        systemStatusBarContrastEnforced: true,
                      ),
                      child: const AppMain(),
                    );
                }
              },
            );
          },
          */
        );
      },
    );
  }
}
