import 'package:flutter/material.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'sheet-bible-tmp';
  static String label = 'Tmp';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        elevation: 1,
        title: const Text("Tmp"),
      ),
      body: ListView.builder(
        // key: ValueKey('value-$msg'),
        // key: PageStorageKey('value-$msg'),

        key: const PageStorageKey('Tmp'),
        primary: false,
        // shrinkWrap: true,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text('Tmp: $index'),
          );
        },
        itemCount: 66,
      ),
    );
  }
}
