part of 'main.dart';

mixin _Bar<T> on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return ViewHeaderLayoutStack(
      leftAction: [
        WidgetButton(
          child: WidgetMark(
            icon: Icons.arrow_back_ios_new_rounded,
            label: preference.text.back,
          ),
          show: hasArguments,
          onPressed: args?.currentState!.maybePop,
        ),
      ],
      primary: Align(
        alignment: const Alignment(0, 0),
        child: userPhoto(org),
      ),
      rightAction: [
        WidgetButton(
          child: const WidgetMark(
            icon: Icons.logout_rounded,
          ),
          message: preference.text.signOut,
          enable: authenticate.hasUser,
          onPressed: authenticate.signOut,
        ),
      ],
    );
  }

  Widget userPhoto(ViewHeaderData org) {
    final user = authenticate.user;
    if (user != null) {
      if (user.photoURL != null) {
        return CircleAvatar(
          // radius: 50,
          radius: (35 * org.snapShrink + 15).toDouble(),
          // backgroundColor: Theme.of(context).backgroundColor,
          child: ClipOval(
            child: Material(
              // child: Image.network(
              //   user.photoURL!,
              //   fit: BoxFit.cover,
              //   // height: (70 * org.snapShrink + 30).toDouble(),
              // ),
              child: CachedNetworkImage(
                placeholder: (context, url) {
                  return Padding(
                    padding: EdgeInsets.all((7 * org.snapShrink + 3).toDouble()),
                    child: Icon(
                      Icons.face_retouching_natural_rounded,
                      size: (70 * org.snapShrink).clamp(25, 70).toDouble(),
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
            padding: EdgeInsets.all((7 * org.snapShrink + 3).toDouble()),
            child: Icon(
              Icons.face_retouching_natural_rounded,
              size: (70 * org.snapShrink).clamp(25, 70).toDouble(),
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
          padding: EdgeInsets.all((7 * org.snapShrink + 3).toDouble()),
          child: Icon(
            Icons.face,
            color: Theme.of(context).hintColor,
            size: (70 * org.snapShrink).clamp(25, 70).toDouble(),
          ),
        ),
      ),
    );
  }
}
