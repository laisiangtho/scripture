part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
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
        AnimatedBuilder(
          animation: busyController,
          builder: (context, child) {
            return WidgetMark(
              badge: selectionCount,
              child: WidgetButton(
                enable: hasReady2Vote,
                onPressed: vote,
                child: busyAnimation.isCompleted
                    ? child
                    : Icon(
                        Icons.add_task_outlined,
                        color: hasReady2Submit ? Theme.of(context).errorColor : null,
                      ),
              ),
            );
          },
          child: const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              value: 0.8,
              strokeWidth: 2,
            ),
          ),
        ),
      ],
    );
  }
}