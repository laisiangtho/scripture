import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// NOTE: SystemUiOverlayStyle
import 'package:flutter/services.dart';

/// NOTE: State management
import 'package:lidea/provider.dart';

import 'app.dart';
import 'initialize.dart';

void main() async {
  if (kReleaseMode) {
    debugPrint = (String? msg, {int? wrapWidth}) {};
  }
  WidgetsFlutterBinding.ensureInitialized();

  await initializeApp();
  await App.core.ensureInitialized();

  runApp(const LaiSiangtho());
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
        ChangeNotifierProvider<Preference>(
          create: (context) => App.core.preference,
        ),
        // ChangeNotifierProvider<Authenticate>(
        //   create: (context) => App.core.authenticate,
        // ),
      ],
      builder: (BuildContext context, Widget? child) {
        return Consumer<Preference>(
          builder: (_, preference, __) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                systemNavigationBarColor: preference.androidNavigationBarColor(context),
                systemNavigationBarDividerColor: Colors.transparent,
                systemNavigationBarIconBrightness: preference.resolvedSystemBrightness,
                systemNavigationBarContrastEnforced: false,
                statusBarColor: Colors.transparent,
                statusBarBrightness: preference.systemBrightness,
                statusBarIconBrightness: preference.resolvedSystemBrightness,
                systemStatusBarContrastEnforced: false,
              ),
              child: MaterialApp.router(
                showSemanticsDebugger: false,
                debugShowCheckedModeBanner: false,
                locale: preference.locale,
                localizationsDelegates: preference.localeDelegates,
                supportedLocales: preference.listOfLocale,
                theme: preference.light(context),
                darkTheme: preference.dark(context),
                themeMode: preference.themeMode,
                onGenerateTitle: onGenerateTitle,
                routerConfig: App.core.route.page,
              ),
            );
          },
        );
      },
    );
  }

  String onGenerateTitle(BuildContext context) {
    return App.core.data.env.name;
  }
}
