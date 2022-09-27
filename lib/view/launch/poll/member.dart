part of 'main.dart';

class MemberModal extends ViewDraggableSheetWidget {
  const MemberModal({Key? key}) : super(key: key);

  @override
  State<MemberModal> createState() => _MemberModalState();
}

class _MemberModalState extends ViewDraggableSheetState<MemberModal> {
  @override
  bool get persistent => false;
  @override
  double get initialSize => 0.5;
  @override
  double get minSize => 0.4;

  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;
  late final Poll poll = core.poll;

  late final List<PollMemberType> member = poll.pollBoard.member
    ..sort((a, b) => a.name.compareTo(b.name));
  List<PollResultType> get result => poll.pollBoard.result;
  bool hasUserVoted(int id) => result.where((e) => e.memberId.contains(id)).isNotEmpty;
  Iterable<PollMemberType> get voteList => member.where(
        (e) => result.where((r) => r.memberId.contains(e.memberId)).isNotEmpty,
      );
  int get countVotedMember => voteList.length;
  int get countMember => member.length;

  final navigator = GlobalKey<NavigatorState>();

  // Future whenNavigate() {
  //   return Navigator.of(context).maybePop().whenComplete(() {
  //     return Future.delayed(const Duration(milliseconds: 200), () {
  //       if (Navigator.of(context).canPop()) Navigator.pop(context);
  //     });
  //   });
  // }

  @override
  Widget body() {
    // return ValueListenableBuilder(
    //   valueListenable: box.listenable(),
    //   builder: (context, Box<LibraryType> box, child) {
    //     return super.body();
    //   },
    // );
    return Scaffold(
      body: HeroControllerScope(
        controller: MaterialApp.createMaterialHeroController(),
        child: Navigator(
          key: navigator,
          initialRoute: '/',
          // initialRoute: AppRoutes.homeInitial(),
          // restorationScopeId: 'launch',
          // observers: [obs],
          onGenerateRoute: (RouteSettings route) {
            return PageRouteBuilder(
              settings: route,
              pageBuilder: (BuildContext _, Animation<double> __, Animation<double> ___) {
                return _homePage(route);
              },
              transitionDuration: const Duration(milliseconds: 400),
              reverseTransitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (_, animation, __, child) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              fullscreenDialog: true,
            );
          },
        ),
      ),
    );
  }

  Widget _homePage(RouteSettings route) {
    switch (route.name) {
      case 'testing':
        return const WorkingMemberInfo();
      default:
        // throw Exception('Invalid route: ${route.name}');
        return super.body();
    }
  }

  @override
  List<Widget> sliverWidgets() {
    return <Widget>[
      // SliverAppBar(
      //   pinned: true,
      //   elevation: 0.5,
      //   automaticallyImplyLeading: false,
      //   title: WidgetAppbarTitle(label: preference.language('Member')),
      // ),
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 50],
        backgroundColor: Colors.transparent,
        overlapsBackgroundColor: theme.scaffoldBackgroundColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: (_, org) {
          return ViewHeaderLayoutStack(
            // primary: WidgetAppbarTitle(
            //   alignment: Alignment.lerp(
            //     const Alignment(0, 0),
            //     const Alignment(0, .5),
            //     org.snapShrink,
            //   ),
            //   shrink: org.shrink,
            //   // label: book.name,
            //   label: 'Member',
            // ),
            primary: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetAppbarTitle(
                  shrink: org.shrink,
                  label: 'Member',
                ),
                WidgetAppbarTitle(
                  shrink: org.shrink,
                  shrinkMax: 20,
                  shrinkMin: 12,
                  label: 'MV: $countMember/$countVotedMember',
                ),
              ],
            ),
            rightAction: const [],
          );
        },
      ),
      WidgetBlockSection(
        // headerTitle: const WidgetLabel(
        //   // alignment: Alignment.centerLeft,
        //   label: '...',
        // ),
        headerTitle: WidgetButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const WorkingMemberInfo()),
            // );
            navigator.currentState!.pushNamed('testing');
          },
          child: const Text('Nav'),
        ),
        child: WidgetListBuilder(
          primary: false,
          duration: const Duration(milliseconds: 900),
          itemSnap: (_, index) {
            return ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).focusColor,
              ),
              title: Container(
                height: 15,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                // color: Colors.grey[200],
              ),
              subtitle: Container(
                height: 15,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                // color: Colors.grey[200],
              ),
            );
          },
          itemBuilder: (_, index) {
            final person = member.elementAt(index);
            final hasVoted = hasUserVoted(person.memberId);
            return ListTile(
              leading: Icon(
                Icons.person,
                color: hasVoted ? null : Theme.of(context).focusColor,
              ),
              title: Text(person.name),
              trailing: Icon(
                Icons.done_outlined,
                color: hasVoted ? null : Colors.transparent,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: person.email.map(
                  (email) {
                    return Tooltip(
                      message: email,
                      child: Text(
                        email.substring(0, email.indexOf('@')),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).primaryColorDark,
                            ),
                      ),
                    );
                  },
                ).toList(),
              ),
            );
          },
          itemCount: countMember,
        ),
      ),
    ];
  }
}

class WorkingMemberInfo extends StatefulWidget {
  const WorkingMemberInfo({Key? key}) : super(key: key);

  @override
  State<WorkingMemberInfo> createState() => _WorkingMemberInfoState();
}

class _WorkingMemberInfoState extends State<WorkingMemberInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hello'),
      ),
      body: const Text('WorkingMemberInfo'),
    );
  }
}
