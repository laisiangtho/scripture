part of 'main.dart';

mixin _Header on _State {
  Widget _headerMobile(BuildContext context, ViewBarData vbd) {
    return ViewBarLayouts(
      data: vbd,
      left: [
        OptionButtons.back(
          label: lang.back,
        ),
      ],
      primary: ViewBarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          vbd.snapShrink,
        ),
        label: pollBoard.info.title,
        data: vbd,
      ),
      right: [
        ViewButtons(
          onPressed: showMember,
          child: const ViewMarks(
            icon: Icons.groups_outlined,
          ),
        ),
        ViewButtons(
          enable: hasReady2Vote,
          onPressed: vote,
          badge: selectionCount,
          child: AnimatedBuilder(
            animation: busyController,
            builder: (context, child) {
              return ViewMarks(
                child: busyAnimation.isCompleted
                    ? child
                    : Icon(
                        Icons.add_task_outlined,
                        color: hasReady2Submit ? Theme.of(context).colorScheme.error : null,
                      ),
              );
            },
            child: const SizedBox.square(
              dimension: 20,
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
