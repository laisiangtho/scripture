import 'package:flutter/material.dart';
import 'package:scripture/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'test-card';
  static String label = 'Dart';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Card test Card test Card test'),
        ),
        body: Views(
          child: CustomScrollView(
            slivers: [
              ViewSections(
                headerLeading: const Icon(Icons.ac_unit_outlined),
                headerTrailing: const Icon(Icons.ac_unit_outlined),
                child: ViewCards(
                  child: ListTile(
                    title: const Text('Normal (none)'),
                    subtitle: const Text('As a normal card'),
                    onTap: () {},
                  ),
                ),
              ),
              ViewSections(
                headerLeading: const Icon(Icons.ac_unit_outlined),
                headerTrailing: const Icon(Icons.ac_unit_outlined),
                child: ViewCards.fill(
                  // child: ListTile(
                  //   title: const Text('Normal (fill)'),
                  //   subtitle: const Text('As a normal card'),
                  //   onTap: () {},
                  // ),
                  child: ViewLists.separator(
                    itemBuilder: (_, __) {
                      return ListTile(
                        title: const Text('Normal (fill)'),
                        subtitle: const Text('As a normal card'),
                        onTap: () {},
                      );
                    },
                    separator: (_, __) {
                      return const ViewDividers();
                    },
                    itemCount: 3,
                  ),
                ),
              ),
              ViewSections(
                headerLeading: const Icon(Icons.ac_unit_outlined),
                headerTrailing: const Icon(Icons.ac_unit_outlined),
                child: ViewCards.shadow(
                  child: ListTile(
                    title: const Text('Normal (shadow)'),
                    subtitle: const Text('As a normal card'),
                    onTap: () {},
                  ),
                ),
              ),
              ViewSections(
                headerLeading: const Icon(Icons.ac_unit_outlined),
                headerTrailing: const Icon(Icons.ac_unit_outlined),
                child: ViewCards.shadow(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  blurRadius: 12,
                  child: ListTile(
                    title: const Text('Normal (shadow)'),
                    subtitle: const Text('As a normal card'),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget normal(String type) {
    // return ViewLists.separator(
    //   separator: (BuildContext context, int index) {
    //     return const ViewDividers();
    //   },
    //   itemBuilder: (BuildContext context, int index) {
    //     return ListTile(
    //       // splashColor: Colors.red,
    //       // focusColor: Colors.amber,
    //       title: Text('noneDecoration $index'),
    //       onTap: () {},
    //     );
    //   },
    //   itemCount: 3,
    // );
    return ViewCards(
      child: ListTile(
        title: Text('Normal ($type)'),
        subtitle: const Text('As a normal card'),
        onTap: () {},
      ),
    );
  }

  Widget fill(String type) {
    return ViewCards.fill(
      child: ListTile(
        title: Text('Normal ($type)'),
        subtitle: const Text('As a normal card'),
        onTap: () {},
      ),
    );
  }
}
