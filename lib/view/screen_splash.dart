part of 'screen_launcher.dart';
// import 'package:flutter/material.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(
  //     body: Center(
  //       child: Text('Splash'),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MergeSemantics(
              child: RichText(
                textAlign: TextAlign.center,
                // strutStyle: StrutStyle(),
                text: TextSpan(
                  text: '"',
                  semanticsLabel: "open quotation mark",
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.labelLarge!.color,
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'the',
                      semanticsLabel: "the",
                      style: TextStyle(fontSize: 45),
                    ),
                    const TextSpan(
                      text: ' Holy\n',
                      semanticsLabel: "Holy",
                      style: TextStyle(
                        fontSize: 45,
                      ),
                    ),
                    TextSpan(
                      text: 'Bible\n'.toUpperCase(),
                      semanticsLabel: "Bible",
                      style: const TextStyle(
                        fontSize: 65,
                      ),
                    ),
                    const TextSpan(
                      text: 'in ',
                      semanticsLabel: "in",
                      // style: TextStyle(fontSize: 30),
                    ),
                    const TextSpan(
                      text: 'languages',
                      semanticsLabel: "languages",
                      // style: TextStyle(fontSize: 30),
                    ),
                    const TextSpan(
                      text: '"',
                      semanticsLabel: "close quotation mark",
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
            Semantics(
              label: "Progress",
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Text(App.core.message.value),
              ),
            ),
            // Semantics(
            //   label: "Message",
            //   child: Text(
            //     App.core.message,
            //     semanticsLabel: App.core.message,
            //     style: const TextStyle(fontSize: 30),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
