part of 'app.dart';

class ScreenLauncher extends StatelessWidget {

  // the Holy Bible in languages

  @override
  Widget build(BuildContext context) {
    debugPrint('state build called: root');
    // final _message = context.watch<Core>().message;
    // final state = Provider.of<Core>(context);
    // final state = Provider.of<Core>(context, listen: false);
    // final message = Provider.of<Core>(context).message;
    // final progress = Provider.of<Core>(context).progressPercentage;
    // Consumer<Core>(
    //   builder: (BuildContext _, Core a, Widget? child) => null
    //   child: null,
    // );
    // Selector<Core, double?>(
    //   selector: (BuildContext _, Core core) => core.progressPercentage,
    //   builder: (BuildContext _, double? name, Widget? child) {
    //     return Center(child: Text('$name'));
    //   },
    // );
    // final focus = context.select((Core core) => core.nodeFocus && core.suggestionQuery.isNotEmpty);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // ElevatedButton(
            //   child: Text('Message'),
            //   onPressed: (){
            //     context.read<Core>().message = 'Hello';
            //   }
            // ),
            // Consumer<Core>(
            //   builder: (context, core, child)  => ElevatedButton(
            //     child: Text('Consumer: ${core.message}'),
            //     onPressed: (){
            //       core.message = 'from Consumer';
            //     }
            //   ),
            // ),
            // Selector<Core,String?>(
            //   selector: (_, core) => core.message,
            //   builder: (BuildContext context, String? message, Widget? child) => ElevatedButton(
            //     child: Text('Selector: $message'),
            //     onPressed: (){
            //       // message = 'from Selector';
            //       context.read<Core>().message = 'from Selector';
            //     }
            //   )
            // ),

            // Provider<TestCoreNotifier>(
            //   create: (_) => TestCoreNotifier(),
            //   // Will throw a ProviderNotFoundError, because `context` is associated
            //   // to the widget that is the parent of `Provider<Example>`
            //   // child: Text(context.watch<TestCoreNotifier>().message),
            //   builder: (e,s) {
            //     return ElevatedButton(
            //       child: Text('Message: ${e.read<TestCoreNotifier>().message}'),
            //       onPressed: (){
            //         e.read<TestCoreNotifier>().message = 'Hello';
            //       }
            //     );
            //   }
            // ),
            MergeSemantics(
              child: RichText(
                textAlign: TextAlign.center,
                // strutStyle: StrutStyle(),
                text: TextSpan(
                  text: '"',
                  semanticsLabel: "open quotation mark",
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.button!.color,
                    fontSize: 25
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:'the',
                      semanticsLabel: "the",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      )
                    ),
                    TextSpan(
                      text: ' Holy\n',
                      semanticsLabel: "Holy",
                      style: TextStyle(
                        fontSize: 32
                      )
                    ),
                    TextSpan(
                      text: 'Bible\n',
                      semanticsLabel: "Bible",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 60
                      )
                    ),
                    TextSpan(
                      text: 'in ',
                      semanticsLabel: "in",
                      style: TextStyle(
                        fontSize: 21
                      )
                    ),
                    TextSpan(
                      text: 'languages',
                      semanticsLabel: "languages",
                      style: TextStyle(
                        fontSize: 20
                      )
                    ),
                    TextSpan(
                      text: '"',
                      semanticsLabel: "close quotation mark",
                      style: TextStyle(
                        fontSize: 25
                      )
                    )
                  ]
                )
              ),
            ),
            Semantics(
              label: "Progress",
              child: Padding(
                padding: EdgeInsets.symmetric(vertical:50),
                child: Selector<Core, double?>(
                  selector: (_, core) => core.progressPercentage,
                  builder: (BuildContext context, double? percentage, Widget? child) => CircularProgressIndicator(
                    semanticsLabel: 'percentage',
                    semanticsValue: percentage.toString(),
                    strokeWidth: 2.0,
                    value: percentage,
                    valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
                  )
                )
                // child: CircularProgressIndicator(
                //   semanticsLabel: 'percentage',
                //   semanticsValue: state.progressPercentage.toString(),
                //   strokeWidth: 2.0,
                //   value: state.progressPercentage,
                //   valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
                // )
                // child: Consumer<Core>(
                //   builder: (context, core, _)  => CircularProgressIndicator(
                //     semanticsLabel: 'percentage',
                //     // semanticsValue: core.progressPercentage.toString(),
                //     strokeWidth: 2.0,
                //     value: core.progressPercentage,
                //     valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
                //   )
                // )
                // child: ValueListenableBuilder<double?>(
                //   valueListenable: Core.instance.collection.notify.progress,
                //   builder: (context, value, _)  => CircularProgressIndicator(
                //     semanticsLabel: 'percentage',
                //     semanticsValue: value.toString(),
                //     strokeWidth: 2.0,
                //     value: value,
                //     valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
                //   )
                // )
              )
            ),
            Semantics(
              label: "Message",
              child: Selector<Core, String>(
                selector: (_, core) => core.message,
                builder: (BuildContext _, String message, Widget? child) => Text(message,
                  semanticsLabel: message,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 30
                  )
                )
              )
            )
            // Semantics(
            //   label: "Message",
            //   child: Text(
            //     'state.message',
            //     semanticsLabel: 'state.message',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w300,
            //       fontSize: 30,
            //     ),
            //   ),
            // )

            // Semantics(
            //   label: "App name",
            //   child: Text(
            //     "MyOrdbok",
            //     semanticsLabel: "MyOrdbok",
            //     style: TextStyle(
            //       fontSize: 22
            //     )
            //   )
            // )
          ]
        )
      )
    );
  }

  // Widget name(){
  //   return Container(
  //     height: 70,
  //     child: Center(
  //       child: Text(
  //         // store.appVersion,
  //         // Store.apple
  //         'Core.instance.version',
  //         // '...',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w200,
  //           // foreground: Paint()
  //           //   ..style = PaintingStyle.stroke
  //           //   ..strokeWidth = 2
  //           shadows: <Shadow>[
  //             // Shadow(
  //             //   offset: Offset(0.3, 0.5),
  //             //   blurRadius: 0.2,
  //             // ),
  //             // Shadow(
  //             //   offset: Offset(2.0, 1.0),
  //             //   blurRadius: 20.0,
  //             // ),
  //           ],
  //         ),
  //       )
  //     ),
  //   );
  // }
}