part of 'screen_launcher.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MergeSemantics(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '"',
                  semanticsLabel: "open quotation mark",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'the',
                      semanticsLabel: "the",
                      style: TextStyle(fontSize: 45),
                    ),
                    TextSpan(
                      text: ' Holy\n',
                      semanticsLabel: "Holy",
                      style: TextStyle(
                        fontSize: 45,
                      ),
                    ),
                    TextSpan(
                      text: 'BIBLE\n',
                      semanticsLabel: "Bible",
                      style: TextStyle(
                        fontSize: 65,
                      ),
                    ),
                    TextSpan(
                      text: 'in ',
                      semanticsLabel: "in",
                      // style: TextStyle(fontSize: 30),
                    ),
                    TextSpan(
                      text: 'languages',
                      semanticsLabel: "languages",
                      // style: TextStyle(fontSize: 30),
                    ),
                    TextSpan(
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
                child: Text(
                  App.core.message.value,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
