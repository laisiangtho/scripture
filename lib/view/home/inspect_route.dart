part of 'main.dart';

class InspectRoute extends StatefulWidget {
  const InspectRoute({super.key});

  static String route = 'test-inspect';
  static String label = 'Inspect';
  static IconData icon = Icons.ac_unit;

  @override
  State<InspectRoute> createState() => _InspectRouteState();
}

abstract class _InspectRouteAbstract extends StateAbstract<InspectRoute> {}

class _InspectRouteState extends _InspectRouteAbstract {
  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: [
        ListTile(
          title: const Text('Route ??'),
          onTap: () {
            // route.pushNamed('home/test-group');
            // Navigator.of(context).pushNamed('/test-group');
            // Navigator.of(context, rootNavigator: true).pushNamed('/test-group');
          },
        ),
      ],
    );
  }
}
