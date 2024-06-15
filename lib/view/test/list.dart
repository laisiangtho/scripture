import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:scripture/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'test-list';
  static String label = 'List';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List test'),
      ),
      body: Views(
        child: CustomScrollView(
          slivers: [
            // separatorWithFill(),
            // separatorWithCard(),
            // separatorWithShadow(),
            // Card(
            //   child: separatorWithFill(),
            // ),
            // Card(
            //   child: separatorWithCard(),
            // ),
            SliverToBoxAdapter(
              child: separatorWithFill(),
            ),
            SliverToBoxAdapter(
              child: separatorWithCard(),
            ),
            SliverToBoxAdapter(
              child: separatorWithShadow(),
            ),
            const SliverToBoxAdapter(
              child: Card(
                child: Text('Card'),
              ),
            ),
            SliverToBoxAdapter(
              child: ListTile(
                title: const Text('Just List'),
                onTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: noneDecoration(),
            ),
            noneDecoration(),
            separatorWithCard(),
          ],
        ),
      ),
    );
  }

  Widget noneDecoration() {
    return ViewLists.separator(
      separator: (BuildContext context, int index) {
        return const ViewDividers();
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          // splashColor: Colors.red,
          // focusColor: Colors.amber,
          title: Text('noneDecoration $index'),
          onTap: () {},
        );
      },
      itemCount: 3,
    );
  }

  Widget separatorWithFill() {
    return ViewLists.separator(
      decoration: BoxDecoration(
        // color: CardTheme.of(context).color,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      separator: (BuildContext context, int index) {
        return const ViewDividers();
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          // splashColor: Colors.red,
          // focusColor: Colors.amber,
          title: Text('separatorWith Fill $index'),
          onTap: () {},
        );
      },
      itemCount: 3,
    );
  }

  Widget separatorWithCard() {
    return ViewLists.separator(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // decoration: const BoxDecoration(),
      decoration: BoxDecoration(
        color: CardTheme.of(context).color,
        // color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        // backgroundBlendMode: BlendMode.color,
        boxShadow: [
          BoxShadow(
            color: CardTheme.of(context).shadowColor!,
            blurRadius: 1,
            spreadRadius: 0.5,
            offset: const Offset(0.0, 1.0),
          )
        ],
      ),
      separator: (BuildContext context, int index) {
        return const ViewDividers();
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          splashColor: Colors.red,
          focusColor: Colors.amber,
          title: Text('separatorWith Card $index'),
          onTap: () {},
        );
      },
      itemCount: 3,
    );
  }

  Widget separatorWithShadow() {
    return ViewLists.separator(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        // color: CardTheme.of(context).color,
        // shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        // backgroundBlendMode: BlendMode.clear,
        boxShadow: [
          BoxShadow(
            color: CardTheme.of(context).shadowColor!,
            blurRadius: 5,
            spreadRadius: 0.2,
            offset: const Offset(0.0, 0.0),
          )
        ],
      ),
      separator: (BuildContext context, int index) {
        return const ViewDividers();
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          // splashColor: Colors.red,
          // focusColor: Colors.amber,
          // tileColor: Colors.green,
          title: Text('separatorWith Shadow $index'),
          onTap: () {},
        );
      },
      itemCount: 3,
    );
  }
}
