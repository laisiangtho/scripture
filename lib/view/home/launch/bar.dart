part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: const [kBottomNavigationBarHeight, 50],
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Stack(
          alignment: const Alignment(0, 0),
          children: [
            // This make the return "appbar-left" Hero animation smooth
            const Positioned(
              left: 0,
              top: 0,
              child: Hero(
                tag: 'appbar-left',
                child: Padding(
                  // padding: EdgeInsets.symmetric(horizontal: 0),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 13),
                  child: Material(
                    type: MaterialType.transparency,
                    child: SizedBox(),
                    // child: CupertinoButton(
                    //   padding: EdgeInsets.zero,
                    //   minSize: 30,
                    //   onPressed: null,
                    //   child: SizedBox(),
                    // ),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, .5),
                snap.shrink,
              )!,
              child: Hero(
                tag: 'appbar-center',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    translate.holyBible,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: (30 * org.shrink).clamp(24.0, 30.0).toDouble()),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),

            Positioned(
              right: 0,
              top: 0,
              child: Padding(
                // padding: const EdgeInsets.symmetric(horizontal: 7),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                child: Hero(
                  tag: 'appbar-right',
                  child: CupertinoButton(
                    // padding: const EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.zero,
                    minSize: 30,
                    child: Tooltip(
                      message: translate.option(true),
                      child: Selector<Authentication, bool>(
                        selector: (_, e) => e.hasUser,
                        builder: (BuildContext context, bool hasUser, Widget? child) {
                          return userPhoto();
                        },
                      ),
                    ),
                    onPressed: () => core.navigate(to: '/user'),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget userPhoto() {
    final user = authenticate.user;
    if (user != null) {
      if (user.photoURL != null) {
        return CircleAvatar(
          radius: 15,
          child: ClipOval(
            child: Material(
              // child: Image.network(
              //   user.photoURL!,
              //   fit: BoxFit.cover,
              // ),
              child: CachedNetworkImage(
                placeholder: (context, url) {
                  return const Padding(
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.face_retouching_natural_rounded,
                      size: 25,
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
          child: const Padding(
            padding: EdgeInsets.all(3),
            child: Icon(
              Icons.face_retouching_natural_rounded,
              size: 25,
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
        child: const Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.face,
            size: 25,
          ),
        ),
      ),
    );
  }
}
