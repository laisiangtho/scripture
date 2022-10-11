import 'package:flutter/material.dart';

import '../app.dart';

class BackButtonWidget extends StatelessWidget {
  final NavigatorState navigator;
  const BackButtonWidget({Key? key, required this.navigator}) : super(key: key);
  // NavigatorState get navigator => Navigator.of(context);
  // NavigatorState get navigator => App.route.navigator(context);
  @override
  Widget build(BuildContext context) {
    return ViewButton(
      show: navigator.canPop(),
      onPressed: navigator.maybePop,
      style: Theme.of(context).textTheme.labelMedium,
      child: ViewMark(
        icon: Icons.arrow_back_ios_rounded,
        label: App.preference.text.back,
        // label: 'Back',
      ),
    );
    // return AnimatedBuilder(
    //   animation: App.preference,
    //   builder: (BuildContext context, Widget? child) {
    //     return ViewButton(
    //       show: Navigator.of(context).canPop(),
    //       onPressed: Navigator.of(context).maybePop,
    //       child: ViewMark(
    //         icon: Icons.arrow_back_ios_rounded,
    //         label: App.preference.text.back,
    //         // label: 'Back',
    //       ),
    //     );
    //   },
    // );
    // return AnimatedBuilder(
    //   animation: App.preference,
    //   builder: (BuildContext context, Widget? child) {
    //     return ViewButton(
    //       show: Navigator.of(context).canPop(),
    //       onPressed: Navigator.of(context).maybePop,
    //       child: ViewMark(
    //         icon: Icons.arrow_back_ios_rounded,
    //         label: App.preference.text.back,
    //         // label: 'Back',
    //       ),
    //     );
    //   },
    // );
    // return ViewButton(
    //   show: Navigator.of(context).canPop(),
    //   onPressed: Navigator.of(context).maybePop,
    //   child: ViewMark(
    //     icon: Icons.arrow_back_ios_rounded,
    //     label: App.preference.text.back,
    //     // label: 'Back',
    //   ),
    // );
  }
}

class HomeButtonWidget extends StatelessWidget {
  final NavigatorState navigator;
  const HomeButtonWidget({Key? key, required this.navigator}) : super(key: key);
  // NavigatorState get navigator => Navigator.of(context);
  // NavigatorState get navigator => App.route.navigator(context);
  @override
  Widget build(BuildContext context) {
    return ViewButton(
      show: navigator.canPop(),
      onPressed: navigator.maybePop,
      style: Theme.of(context).textTheme.labelMedium,
      child: ViewMark(
        icon: Icons.arrow_back_ios_rounded,
        label: App.preference.text.back,
        // label: 'Back',
      ),
    );
  }
}
