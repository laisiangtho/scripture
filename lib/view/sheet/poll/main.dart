import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';

// import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';

import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'sheet-poll';
  static String label = 'Poll';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends DraggableSheets<Main> {
  @override
  late final Core app = context.read<Core>();

  @override
  double get actualInitialSize => 0.5;
  @override
  double get actualMinSize => 0.4;

  late final Poll poll = app.poll;

  late final List<PollMemberType> member = poll.pollBoard.member
    ..sort((a, b) => a.name.compareTo(b.name));
  List<PollResultType> get result => poll.pollBoard.result;
  bool hasUserVoted(int id) => result.where((e) => e.memberId.contains(id)).isNotEmpty;
  Iterable<PollMemberType> get voteList => member.where(
        (e) => result.where((r) => r.memberId.contains(e.memberId)).isNotEmpty,
      );
  int get countVotedMember => voteList.length;
  int get countMember => member.length;

  @override
  List<Widget> slivers() {
    return <Widget>[
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 50],
        backgroundColor: Colors.transparent,
        overlapsBackgroundColor: state.theme.scaffoldBackgroundColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: (_, vhd) {
          return ViewHeaderLayouts(
            data: vhd,
            primary: ViewHeaderTitle(
              // alignment: Alignment.lerp(
              //   const Alignment(0, 0),
              //   const Alignment(0, .5),
              //   vhd.snapShrink,
              // ),
              alignment: const Alignment(0, -.5),
              data: vhd,
              label: 'Member',
              // label: 'အဖွဲ့ဝင်',
            ),
            secondary: ViewHeaderTitle(
              // alignment: Alignment.lerp(
              //   const Alignment(0, .5),
              //   const Alignment(0, .5),
              //   vhd.snapShrink,
              // ),
              alignment: const Alignment(0, .7),
              data: vhd,
              shrinkMax: 20,
              shrinkMin: 12,
              label: 'MV: $countMember/$countVotedMember',
            ),
            // secondary: ViewHeaderBar(
            //   shrink: vhd.snapShrink,
            //   label: 'MV: $countMember/$countVotedMember',
            // ),
          );
        },
      ),
      ViewSections(
        // headerTitle: const WidgetLabel(
        //   // alignment: Alignment.centerLeft,
        //   label: '...',
        // ),
        headerTitle: ViewButtons(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const WorkingMemberInfo()),
            // );
            // navigator.currentState!.pushNamed('testing');
          },
          child: const Text('Nav'),
        ),
        child: ViewLists(
          duration: const Duration(milliseconds: 900),
          itemSnap: ListTile(
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
          ),
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
