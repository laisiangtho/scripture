import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter/scheduler.dart' show timeDilation;

// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/idea.dart';
import 'package:lidea/view/notify.dart';
// import 'package:lidea/connectivity.dart';

import 'package:bible/core.dart';
import 'package:bible/theme.dart';
import 'package:bible/view/app.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  // }

  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  return runApp(LaiSiangtho());
}

class LaiSiangtho extends StatelessWidget {
  LaiSiangtho({Key? key, this.initialRoute}) : super(key: key);

  final String? initialRoute;

  @override
  Widget build(BuildContext context){
    return IdeaModel(
      initialModel: IdeaTheme(
        themeMode: ThemeMode.system,
        textFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTesting: true
      ),
      child: appProvider()
    );
  }

  Widget appProvider(){
    return MultiProvider(
      providers: [
        // Provider(create: (context) => TestCore),
        // ChangeNotifierProxyProvider<TestCore, TestCoreNotifier>(
        //   create: (context) => TestCoreNotifier(),
        //   update: (context, data, form) {
        //     if (form == null) throw ArgumentError.notNull('form');
        //     // form.searchQuery = data.searchQuery;
        //     // form.keyword = data.keyword;
        //     // form.store = Store();
        //     // form.initiator = data.init();
        //     // initiator
        //     return form;
        //   },
        // ),

        // ProxyProvider<StoreNotifier, Store>(
        //   update: (context, data, form) => Store()
        // ),

        ChangeNotifierProvider<NotifyViewScroll>(
          create: (context) => NotifyViewScroll(),
        ),
        // ChangeNotifierProvider<NotifyNavigationScroll>(
        //   create: (context) => NotifyNavigationScroll(),
        // ),
        ChangeNotifierProvider<Core>(
          create: (context) => Core(),
        ),
      ],
      child:  app()
    );
  }
  Widget app(){
    return Builder(
      builder: (context) => uiOverlayStyle(
        isBrightness: IdeaTheme.of(context).resolvedSystemBrightness == Brightness.light,
        brightness: IdeaTheme.of(context).resolvedSystemBrightness,
        child: MaterialApp(
          title: "Lai Siangtho",
          // title: Core.instance.collection.env.name,
          showSemanticsDebugger: false,
          debugShowCheckedModeBanner: false,
          darkTheme: IdeaData.dark.copyWith(
            platform: IdeaTheme.of(context).platform,
            brightness: IdeaTheme.of(context).systemBrightness
          ),
          theme: IdeaData.light.copyWith(
            platform: IdeaTheme.of(context).platform,
            brightness: IdeaTheme.of(context).systemBrightness
          ),
          themeMode: IdeaTheme.of(context).themeMode,
          // localizationsDelegates: const [
          //   ...GalleryLocalizations.localizationsDelegates,
          //   LocaleNamesLocalizationsDelegate()
          // ],
          // supportedLocales: GalleryLocalizations.supportedLocales,
          locale: IdeaTheme.of(context).locale,
          localeResolutionCallback: (locale, supportedLocales) => locale,
          // initialRoute: initialRoute,
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
            builder: (context) => ApplyTextOptions(
              child: AppMain(key: key)
            ),
            settings: settings
          )
          // onUnknownRoute: RouteConfiguration.onUnknownRoute,
        )
      )
    );
  }

  Widget uiOverlayStyle({required Brightness brightness, required bool isBrightness, required Widget child}){
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
        statusBarBrightness: isBrightness?Brightness.dark:Brightness.light,
        systemNavigationBarColor: isBrightness?IdeaData.darkScheme.primary:IdeaData.lightScheme.primary,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: brightness
      ),
      child: child
    );
  }
}