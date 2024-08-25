import 'package:flutter/material.dart';

/// NOTE: SystemUiOverlayStyle
// import 'package:flutter/services.dart';

/// NOTE: State management
import 'package:lidea/provider.dart';

import 'app.dart';
import 'initialize.dart';

void main() async {
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
        // ChangeNotifierProvider<Preference>(
        //   create: (context) => App.core.preference,
        // ),
        // ChangeNotifierProvider<Authenticate>(
        //   create: (context) => App.core.authenticate,
        // ),
      ],
      builder: (BuildContext context, Widget? child) {
        final preference = App.core.preference;
        return AnimatedBuilder(
          animation: preference,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp.router(
              key: const ValueKey('LaiSiangtho'),
              showSemanticsDebugger: false,
              debugShowCheckedModeBanner: false,
              restorationScopeId: 'lidea',
              locale: preference.locale,
              localizationsDelegates: preference.localeDelegates,
              supportedLocales: preference.listOfLocale,
              theme: preference.light(context),
              darkTheme: preference.dark(context),
              themeMode: preference.themeMode,
              onGenerateTitle: (BuildContext context) => App.core.data.env.name,
              routeInformationParser: RouteParser(),
              routerDelegate: App.core.routeDelegate,
              backButtonDispatcher: RootBackButtonDispatcher(),
            );
          },
        );
      },
    );
  }
}
