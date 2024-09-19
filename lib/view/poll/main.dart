import 'package:flutter/material.dart';

// import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/hive.dart';

import '/app.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Views(
        // scrollBottom: ScrollBottomNavigation(
        //   listener: scrollController.bottom,
        //   notifier: viewData.bottom,
        // ),
        child: CustomScrollView(
          controller: scrollController,
          slivers: _slivers,
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        padding: state.media.viewPadding,
        heights: const [kToolbarHeight, kToolbarHeight],
        // overlapsBackgroundColor: theme.primaryColor,
        overlapsBorderColor: theme.dividerColor,
        builder: _header,
      ),
      PullToActivate(
        onUpdate: app.poll.updateIndividual,
      ),
      ViewSections(
        sliver: true,
        duration: const Duration(milliseconds: 250),
        show: poll.hasSubmitted,
        onAwait: const SliverToBoxAdapter(),
        headerLeading: const Icon(Icons.receipt_long_outlined),
        headerTitle: ViewSectionTitle(
          title: ViewLabels(
            alignment: Alignment.centerLeft,
            label: pollBoard.info.outcome.replaceFirst('showTotal', results.length.toString()),
          ),
        ),
        child: ViewLists(
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: results.length,
          itemBuilder: (_, index) {
            final result = results.elementAt(index);
            final candidate = pollBoard.member.firstWhere((e) => e.memberId == result.candidateId);

            return _ItemWidget(
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
                  ViewLabels(
                    alignment: Alignment.center,
                    icon: Icons.verified_user_outlined,
                    iconColor: theme.hintColor,
                    label: result.memberId.length.toString(),
                    // label: '34579',
                    iconSize: 18,
                    // labelPadding: const EdgeInsets.only(left: 10),
                    labelStyle: TextStyle(color: theme.hintColor, fontSize: 15),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      ViewSections(
        duration: const Duration(milliseconds: 250),
        onAwait: const SliverToBoxAdapter(),
        headerLeading: const Icon(Icons.how_to_vote_outlined),
        headerTitle: ViewSectionTitle(
          title: ViewLabels(
            alignment: Alignment.centerLeft,
            label: pollBoard.info.candidate.replaceFirst('showTotal', candidates.length.toString()),
          ),
        ),
        footerTitle: ViewSectionTitle(
          title: ListBody(
            children: [
              ViewLabels(
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
                    ViewLabels(
                      // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                      alignment: Alignment.centerLeft,
                      icon: Icons.pending_actions_outlined,
                      label: pollBoard.info.expireDatetime,
                      // iconSize: 18,
                      labelPadding: const EdgeInsets.only(left: 10),
                      labelStyle: TextStyle(color: theme.hintColor, fontSize: 15),
                    ),
                    if (pollBoard.listicle.used.isNotEmpty)
                      ViewLabels(
                        // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                        alignment: Alignment.centerLeft,
                        icon: Icons.gas_meter_outlined,
                        // label: '${pollBoard.data.limit} - ${pollBoard.data.used}',
                        label:
                            '${pollBoard.listicle.resetDatetime} (${pollBoard.listicle.remaining}/${pollBoard.listicle.used})',
                        // label: pollBoard.data.remaining,
                        // iconSize: 18,
                        labelPadding: const EdgeInsets.only(left: 10),
                        labelStyle: TextStyle(color: theme.hintColor, fontSize: 15),
                      ),
                  ],
                ),
              ),
              ViewLabels(
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
          child: ViewLists.separator(
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
                  // iconColor: hasSelected ? theme.highlightColor : null,
                  // color: hasSelected ? theme.errorColor : theme.hintColor,
                  color: hasSelected ? null : theme.hintColor,
                ),
                selected: hasSelected,
                selectedColor: colorScheme.error,
                title: Text(member.name),
                trailing: Icon(
                  // hasSelected ? Icons.remove_done_outlined : Icons.done_outlined,
                  Icons.done_outlined,
                  // color: hasVoted ? theme.primaryColorDark : Colors.transparent,
                  color: hasVoted ? theme.hintColor : Colors.transparent,
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
            separator: (_, index) {
              return const ViewDividers();
            },
          ),
        ),
      ),
    ];
  }
}

// PullResultItemWidget
class _ItemWidget extends StatelessWidget {
  final Widget? child;
  final double value;

  const _ItemWidget({
    required this.value,
    this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      child: LayoutBuilder(
        builder: (_, boxConstraints) {
          var x = boxConstraints.maxWidth;
          var percent = (value / 1.0) * x;
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
