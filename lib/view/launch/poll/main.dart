import 'package:flutter/material.dart';

// import 'package:lidea/hive.dart';
import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
// import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/widget/main.dart';
import '/type/main.dart';

part 'bar.dart';
part 'state.dart';
part 'member.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/launch/poll';
  static const icon = Icons.how_to_vote_outlined;
  static const name = 'Poll';
  static const description = '...';

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          slivers: sliverWidgets(),
        ),
      ),
    );
  }

  List<Widget> sliverWidgets() {
    debugPrint('sliverWidgets');
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        // reservedPadding: MediaQuery.of(context).padding.top,
        padding: MediaQuery.of(context).viewPadding,
        // heights: const [kToolbarHeight],
        heights: const [kToolbarHeight, 50],
        // overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),
      PullToActivate(
        onUpdate: core.poll.updateIndividual,
      ),
      WidgetBlockSection(
        duration: const Duration(milliseconds: 250),
        show: poll.hasSubmitted,
        placeHolder: const SliverToBoxAdapter(),
        headerLeading: const Icon(Icons.receipt_long_outlined),
        headerTitle: WidgetBlockTile(
          title: WidgetLabel(
            alignment: Alignment.centerLeft,
            label: pollBoard.info.outcome.replaceFirst('showTotal', results.length.toString()),
          ),
        ),
        child: WidgetListBuilder(
          primary: false,
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: results.length,
          itemBuilder: (_, index) {
            final result = results.elementAt(index);
            final candidate = pollBoard.member.firstWhere((e) => e.memberId == result.candidateId);

            return PullResultItemWidget(
              value: result.memberId.length * 1.0 / pollBoard.member.length,
              // value: 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      candidate.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Text('1507'),
                  WidgetLabel(
                    alignment: Alignment.center,
                    icon: Icons.verified_user_outlined,
                    iconColor: Theme.of(context).hintColor,
                    label: result.memberId.length.toString(),
                    // label: '34579',
                    iconSize: 18,
                    // labelPadding: const EdgeInsets.only(left: 10),
                    labelStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 15),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      WidgetBlockSection(
        duration: const Duration(milliseconds: 250),
        placeHolder: const SliverToBoxAdapter(),
        headerLeading: const Icon(Icons.how_to_vote_outlined),
        headerTitle: WidgetBlockTile(
          title: WidgetLabel(
            alignment: Alignment.centerLeft,
            label: pollBoard.info.candidate.replaceFirst('showTotal', candidates.length.toString()),
          ),
        ),
        footerTitle: WidgetBlockTile(
          title: ListBody(
            children: [
              WidgetLabel(
                alignment: Alignment.center,
                softWrap: true,
                maxLines: 3,
                textAlign: TextAlign.center,
                label: pollBoard.info.description,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetLabel(
                      // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                      alignment: Alignment.centerLeft,
                      icon: Icons.pending_actions_outlined,
                      label: pollBoard.info.expireDatetime,
                      // iconSize: 18,
                      labelPadding: const EdgeInsets.only(left: 10),
                      labelStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 15),
                    ),
                    if (pollBoard.data.used.isNotEmpty)
                      WidgetLabel(
                        // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                        alignment: Alignment.centerLeft,
                        icon: Icons.gas_meter_outlined,
                        // label: '${pollBoard.data.limit} - ${pollBoard.data.used}',
                        label:
                            '${pollBoard.data.resetDatetime} (${pollBoard.data.remaining}/${pollBoard.data.used})',
                        // label: pollBoard.data.remaining,
                        // iconSize: 18,
                        labelPadding: const EdgeInsets.only(left: 10),
                        labelStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 15),
                      ),
                  ],
                ),
              ),
              WidgetLabel(
                alignment: Alignment.center,
                softWrap: true,
                maxLines: 15,
                textAlign: TextAlign.center,
                label: pollBoard.info.note,
              ),
            ],
          ),
        ),
        child: Card(
          child: WidgetListBuilder(
            primary: false,
            itemCount: candidates.length,
            itemBuilder: (_, index) {
              final member = candidates.elementAt(index);
              bool hasSelected = selection.contains(member.memberId);
              // bool hasVoted = pollBoard.result
              //     .where(
              //         (e) => e.memberId.contains(userMemberId) && e.candidateId == member.memberId)
              //     .isNotEmpty;
              bool hasVoted = poll.userVotedCandidate(member.memberId);

              return ListTile(
                leading: Icon(
                  // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  // alignment: Alignment.centerLeft,
                  Icons.person,
                  // icon: Icons.check_rounded,
                  // iconColor: hasSelected ? Theme.of(context).highlightColor : null,
                  // color: hasSelected ? Theme.of(context).errorColor : Theme.of(context).hintColor,
                  color: hasSelected ? null : Theme.of(context).hintColor,
                ),
                selected: hasSelected,
                selectedColor: Theme.of(context).errorColor,
                title: Text(member.name),
                trailing: Icon(
                  // hasSelected ? Icons.remove_done_outlined : Icons.done_outlined,
                  Icons.done_outlined,
                  // color: hasVoted ? Theme.of(context).primaryColorDark : Colors.transparent,
                  color: hasVoted ? Theme.of(context).hintColor : Colors.transparent,
                ),
                // remove_done_outlined
                onTap: () {
                  if (pollBoard.hasExpired) {
                    doConfirmWithSimple(
                      context: context,
                      title: pollBoard.info.title,
                      message: pollBoard.info.expireMessage,
                    );
                    return;
                  }
                  poll.toggleSelection(member.memberId);
                },
              );
            },
            itemSeparator: (_, index) {
              return const WidgetListDivider();
            },
          ),
        ),
      ),
    ];
  }
}

// PullResultItemWidget
class PullResultItemWidget extends StatelessWidget {
  final double max;
  final double value;
  final Widget? child;
  // final Color color;

  const PullResultItemWidget({
    Key? key,
    required this.value,
    this.child,
    this.max = 1.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      child: LayoutBuilder(
        builder: (_, boxConstraints) {
          var x = boxConstraints.maxWidth;
          var percent = (value / max) * x;
          return Container(
            height: 40,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: percent,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    // borderRadius: BorderRadius.circular(7),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  // width: double.infinity,
                  // height: 35,
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).disabledColor,
                  //   borderRadius: BorderRadius.circular(7),
                  // ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: child,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                //   child: child,
                // )
              ],
            ),
          );
        },
      ),
    );
  }
}
