part of 'main.dart';

class Motile extends StatefulWidget {
  final Widget child;
  const Motile({super.key, required this.child});

  @override
  State<Motile> createState() => _MotileState();
}

class _MotileState extends State<Motile> {
  // static const defaultPos = -65.0;
  static const defaultPos = -80.0;
  // static const defaultPos = 0.0;
  static const activePos = 0.0;
  double initial = 0.0;
  // double distance = 0.0;

  final ValueNotifier<double> nextChapterPosition = ValueNotifier(defaultPos);
  final ValueNotifier<double> previousChapterPosition = ValueNotifier(defaultPos);

  void onHorizontalDragStart(DragStartDetails details) {
    initial = details.globalPosition.dx;
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    final distance = details.globalPosition.dx - initial;
    final leftOrRight = distance.isNegative;
    final abc = leftOrRight ? defaultPos - distance : distance - defaultPos.abs();
    final val = abc.clamp(defaultPos, activePos);

    if (leftOrRight) {
      previousChapterPosition.value = val;
    } else {
      nextChapterPosition.value = val;
    }
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (previousChapterPosition.value == activePos) {
      App.core.chapterNext.catchError((e) {});
    } else if (nextChapterPosition.value == activePos) {
      App.core.chapterPrevious.catchError((e) {});
    }

    onHorizontalDragCancel();
  }

  void onHorizontalDragCancel() {
    int wait = 0;
    if (previousChapterPosition.value != defaultPos) {
      // _resetChapterPosition(previousChapterPosition);
      Future.delayed(Duration(milliseconds: wait), () {
        _resetChapterPosition(previousChapterPosition);
      });
      wait = 100;
    }
    if (nextChapterPosition.value != defaultPos) {
      // _resetChapterPosition(_resetChapterPosition);
      Future.delayed(Duration(milliseconds: wait), () {
        _resetChapterPosition(nextChapterPosition);
      });
    }
  }

  void onVerticalDragStart(DragStartDetails details) {
    // debugPrint('drag start ${details.globalPosition.dx}');
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    // debugPrint('drag update ${details.delta.dx}');
  }

  void onVerticalDragEnd(DragEndDetails details) {
    // debugPrint('drag end ${details.globalPosition.dx}');
  }

  void onVerticalDragCancel() {
    // debugPrint('drag cancel');
  }

  // resetChapterPosition
  StreamSubscription<double> _resetChapterPosition(ValueNotifier<double> notifier) {
    return _streamDouble(notifier.value).listen((double value) {
      // debugPrint('resetChapterPosition $value');
      notifier.value = value;
    });
  }

  // 55/56*100 height/kHeight*100 -> /100
  Stream<double> _streamDouble(double value) async* {
    double calcd = defaultPos;
    while (value >= defaultPos) {
      await Future.delayed(Duration.zero);
      calcd = (value--).toDouble();
      yield calcd;
    }
    yield calcd.roundToDouble();
  }

  ThemeData get theme => Theme.of(context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onHorizontalDragCancel: onHorizontalDragCancel,
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onVerticalDragCancel: onVerticalDragCancel,
      child: Stack(
        children: [
          widget.child,

          /// Previous chapter drag
          ValueListenableBuilder<double>(
            // valueListenable: App.scroll.bottomFactor,
            valueListenable: nextChapterPosition,
            builder: (_, val, child) {
              final active = val == activePos;
              final rad = (40 + val).clamp(5.0, 40.0);
              final blurRadius = active ? 1.0 : 3.0;
              return Positioned.fill(
                left: val,
                top: -3,
                child: Align(
                  // alignment: Alignment.centerLeft,
                  alignment: const Alignment(-1, 0.9),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      // border: Border(
                      //   left: BorderSide(
                      //     color: theme.colorScheme.error,
                      //     width: 1.0,
                      //   ),
                      // ),
                      // borderRadius: const BorderRadius.all(Radius.circular(3)),
                      // borderRadius: const BorderRadius.horizontal(right: Radius.elliptical(30, 60)),
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.elliptical(30 + rad, 50 + val)),
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          // theme.highlightColor,
                          theme.scaffoldBackgroundColor,
                          // active ? theme.indicatorColor : theme.scaffoldBackgroundColor,
                          // active ? theme.colorScheme.error : theme.scaffoldBackgroundColor,
                          // active ? theme.indicatorColor : theme.scaffoldBackgroundColor,
                          theme.disabledColor,
                          // Color(0xffF25D50),
                          // Color(0xffF2BB77),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor,
                          // color: active ? theme.hintColor : theme.shadowColor,
                          blurRadius: blurRadius,
                          spreadRadius: 1,
                          offset: const Offset(1, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        // Icons.arrow_back_rounded,
                        color: theme.primaryColorDark.withOpacity(active ? 1 : 0.2),
                        size: 25,
                        // color: active ? theme.primaryColor : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          /// Next chapter drag
          ValueListenableBuilder<double>(
            // valueListenable: App.scroll.bottomFactor,
            valueListenable: previousChapterPosition,
            builder: (_, val, child) {
              final active = val == activePos;
              final rad = (40 + val).clamp(5.0, 40.0);
              final blurRadius = active ? 1.0 : 3.0;
              return Positioned.fill(
                right: val,
                child: Align(
                  // alignment: Alignment.centerRight,
                  alignment: const Alignment(1, 0.9),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      // border: Border(
                      //   right: BorderSide(
                      //     color: theme.colorScheme.error,
                      //     width: 1.0,
                      //   ),
                      // ),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.elliptical(30 + rad, 50 + val)),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          theme.scaffoldBackgroundColor,
                          // active ? theme.primaryColorDark : theme.scaffoldBackgroundColor,
                          // active ? theme.colorScheme.error : theme.scaffoldBackgroundColor,
                          theme.disabledColor,
                          // Color(0xffF25D50),
                          // Color(0xffF2BB77),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor,
                          // color: active ? theme.hintColor : theme.shadowColor,
                          blurRadius: blurRadius,
                          spreadRadius: 1,
                          offset: const Offset(-1, 0),
                          // offset: Offset(blurRadius, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        // Icons.arrow_forward_rounded,
                        color: theme.primaryColorDark.withOpacity(active ? 1 : 0.2),
                        size: 25,
                        // color: active ? theme.primaryColor : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
