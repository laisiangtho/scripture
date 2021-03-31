part of 'root.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class SplashPage extends StatelessWidget {
  const SplashPage({
    Key key,
  }) : super(key: key);


// static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ApplyTextOption(
      // child: Page(
      //   child: Backdrop(),
      // ),
      child: MainView(key: scaffoldKey,)
    );
  }
}