part of data.core;

/// Primary page snap and scroll notifier
class Views<T> extends ViewScroll<T> {
  const Views({
    Key? key,
    super.scrollBottom,
    super.depth,
    super.onNotification,
    super.snap,
    super.snapAwait,
    super.snapError,
    super.heroController,
    required super.child,
  }) : super(key: key);
}

// class ScrollNotifier extends ViewData {}
