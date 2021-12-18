part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: const [kBottomNavigationBarHeight, 100],
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Stack(
          alignment: const Alignment(0, 0),
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: canPop ? 30 : 0, end: 0),
              duration: const Duration(milliseconds: 300),
              builder: (BuildContext context, double align, Widget? child) {
                return Positioned(
                  left: align,
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
                    child: Hero(
                      tag: 'appbar-left-$canPop',
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 30,
                        onPressed: () {
                          arguments.navigator!.currentState!.maybePop();
                        },
                        child: WidgetLabel(
                          icon: CupertinoIcons.left_chevron,
                          label: translate.back,
                          // label: AppLocalizations.of(context)!.back,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: const Alignment(0, 0),
              child: Hero(
                tag: 'appbar-center-$canPop',
                child: userPhoto(org, snap),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 13),
                child: Hero(
                  tag: 'appbar-right-$canPop',
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 30,
                    // color: Colors.red,
                    onPressed:
                        authenticate.hasUser ? () async => await authenticate.signOut() : null,
                    child: WidgetLabel(
                      icon: Icons.logout_rounded,
                      message: translate.signOut,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget userPhoto(ViewHeaderData org, ViewHeaderData snap) {
    final user = authenticate.user;
    if (user != null) {
      if (user.photoURL != null) {
        return CircleAvatar(
          // radius: 50,
          radius: (35 * snap.shrink + 15).toDouble(),
          // backgroundColor: Theme.of(context).backgroundColor,
          child: ClipOval(
            child: Material(
              // child: Image.network(
              //   user.photoURL!,
              //   fit: BoxFit.cover,
              //   // height: (70 * snap.shrink + 30).toDouble(),
              // ),
              child: CachedNetworkImage(
                placeholder: (context, url) {
                  return Padding(
                    padding: EdgeInsets.all((7 * snap.shrink + 3).toDouble()),
                    child: Icon(
                      Icons.face_retouching_natural_rounded,
                      size: (70 * snap.shrink).clamp(25, 70).toDouble(),
                    ),
                  );
                },
                imageUrl: user.photoURL!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
      return ClipOval(
        child: Material(
          elevation: 10,
          shape: CircleBorder(
            side: BorderSide(
              color: Theme.of(context).backgroundColor,
              width: .5,
            ),
          ),
          shadowColor: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.all((7 * snap.shrink + 3).toDouble()),
            child: Icon(
              Icons.face_retouching_natural_rounded,
              size: (70 * snap.shrink).clamp(25, 70).toDouble(),
            ),
          ),
        ),
      );
    }

    return ClipOval(
      child: Material(
        elevation: 30,
        shape: CircleBorder(
          side: BorderSide(
            color: Theme.of(context).backgroundColor,
            width: .7,
          ),
        ),
        shadowColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all((7 * snap.shrink + 3).toDouble()),
          child: Icon(
            Icons.face,
            color: Theme.of(context).hintColor,
            size: (70 * snap.shrink).clamp(25, 70).toDouble(),
          ),
        ),
      ),
    );
  }
}
