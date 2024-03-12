part of 'main.dart';

/// Primary page snap and scroll notifier
class Views<T> extends ViewScroll<T> {
  const Views({
    super.key,
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

// class ScrollNotifier extends ViewData {}
