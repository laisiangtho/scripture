part of 'main.dart';

class ScreenLauncher extends StatelessWidget {
  const ScreenLauncher({Key? key}) : super(key: key);

  // the Holy Bible in languages
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text('...'),
              ),
            ),
            Semantics(
              label: "Message",
              child: Selector<Core, String>(
                selector: (_, core) => core.message,
                builder: (BuildContext _, String message, Widget? child) => Text(
                  message,
                  semanticsLabel: message,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
