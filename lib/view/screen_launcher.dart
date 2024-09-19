import 'package:flutter/material.dart';

/// NOTE: SystemUiOverlayStyle
// import 'package:flutter/services.dart';

/// NOTE: Core, Components
import '/app.dart';

part 'screen_splash.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _ScreenLauncherState();
}

class _ScreenLauncherState extends CommonStates<Main> {
  // late final Future<void> _initiator = Future.delayed(const Duration(milliseconds: 300));
  late final Future<void> _initiator = app.initialized(context);

  // @override
  // void initState() {
  //   super.initState();
  //   // App.scroll.state = OfContexts(context);
  //   WidgetsBinding.instance.addPostFrameCallback(_mediaData);
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initiator,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // switch (snapshot.connectionState) {
        //   case ConnectionState.done:
        //     return OrientationBuilder(
        //       builder: (context, orientation) {
        //         return launched();
        //       },
        //     );
        //   // return const ScreenSplash();
        //   default:
        //     return const ScreenSplash();
        // }
        if (snapshot.connectionState == ConnectionState.done) {
          Future.delayed(Duration.zero, () {
            app.route.page.go('/');
          });
        }
        return const ScreenSplash();
      },
    );
  }
}
