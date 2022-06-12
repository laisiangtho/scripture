part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    // return ViewHeaderLayoutStack(
    //   leftAction: [
    //     WidgetButton(
    //       show: canPop(),
    //       onPressed: maybePop(),
    //       child: WidgetMark(
    //         icon: Icons.arrow_back_ios_new_rounded,
    //         label: preference.text.back,
    //       ),
    //     ),
    //   ],
    //   primary: WidgetAppbarTitle(
    //     label: pollBoard.info.title,
    //   ),
    //   rightAction: const [],
    // );
    return ViewHeaderLayoutStack(
      leftAction: [
        WidgetButton(
          show: hasArguments,
          onPressed: args?.currentState!.maybePop,
          child: WidgetMark(
            icon: Icons.arrow_back_ios_new_rounded,
            label: preference.text.back,
          ),
        ),
      ],
      primary: WidgetAppbarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          org.snapShrink,
        ),
        label: pollBoard.info.title,
        shrink: org.shrink,
      ),
      rightAction: [
        // WidgetButton(
        //   enable: hasReady2Vote,
        //   onPressed: vote,
        //   child: AnimatedBuilder(
        //     animation: busyController,
        //     builder: (context, child) {
        //       if (busyAnimation.isCompleted) {
        //         return child!;
        //       }
        //       return WidgetMark(
        //         icon: Icons.add_task_outlined,
        //         iconColor: hasReady2Submit ? Theme.of(context).errorColor : null,
        //       );
        //     },
        //     child: const WidgetMark(
        //       child: SizedBox.square(
        //         dimension: 25,
        //         child: CircularProgressIndicator(
        //           strokeWidth: 2,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        AnimatedBuilder(
          animation: busyController,
          builder: (context, child) {
            return WidgetButton(
              enable: hasReady2Vote,
              onPressed: vote,
              child: busyAnimation.isCompleted
                  ? child
                  : WidgetMark(
                      icon: Icons.add_task_outlined,
                      iconColor: hasReady2Submit ? Theme.of(context).errorColor : null,
                    ),
            );
          },
          child: const WidgetMark(
            child: SizedBox.square(
              dimension: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
