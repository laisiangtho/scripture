part of 'main.dart';

mixin _Bar on _State {
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
      primary: WidgetAppbarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          org.snapShrink,
        ),
        label: preference.text.holyBible,
        shrink: org.shrink,
      ),
      rightAction: [
        WidgetButton(
          child: WidgetMark(
            child: Selector<Authentication, bool>(
              selector: (_, e) => e.hasUser,
              builder: userPhoto,
            ),
          ),
          message: preference.text.option(true),
          onPressed: () => core.navigate(to: '/user'),
        ),
      ],
    );
  }

  Widget userPhoto(BuildContext _, bool hasUser, Widget? child) {
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
              // size: 25,
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
