part of 'main.dart';

/// Primary page snap and scroll notifier
class Views<T> extends ViewScrolls<T> {
  const Views({
    super.key,
    super.behavior,
    super.scrollBottom,
    super.depth,
    super.onNotification,
    super.snap,
    super.snapAwait,
    super.snapError,
    super.heroController,
    required super.child,
  });
}
