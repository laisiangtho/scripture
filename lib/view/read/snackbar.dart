part of 'main.dart';

class ChaptersSnackBar extends StatefulWidget {
  const ChaptersSnackBar({super.key});

  @override
  State<ChaptersSnackBar> createState() => _ChaptersSnackBarState();
}

class _ChaptersSnackBarState extends State<ChaptersSnackBar> {
  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return SizedBox(
      height: 30,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ViewLists(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                index.toString(),
              ),
            );
          },
          itemCount: 150,
        ),
      ),
    );
    // return SizedBox(
    //   height: 50,
    //   child: ViewLists(
    //     shrinkWrap: true,
    //     scrollDirection: Axis.horizontal,
    //     itemBuilder: (_, index) {
    //       return Padding(
    //         padding: const EdgeInsets.all(7.0),
    //         child: Text(index.toString()),
    //       );
    //     },
    //     itemCount: 150,
    //   ),
    // );
    // return const Text('snack');
  }
}
