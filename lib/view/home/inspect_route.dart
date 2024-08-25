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
    return ViewLists.static(
      children: [
        ViewSections(
          sliver: false,
          headerTitle: const Text('Extended search'),
          child: ViewCards(
            child: ListBody(
              children: [
                ViewButtons(
                  onPressed: () {
                    route.pushNamed('home/search');
                  },
                  child: const Text('to search'),
                ),
                ViewButtons(
                  onPressed: () {
                    route.pushNamed('home/search', arguments: {'keyword': 'love you as'});
                  },
                  child: const Text('search:love you as, see if notifier'),
                ),
                ViewButtons(
                  onPressed: () {
                    route.pushNamed('home/search', arguments: {'keyword': 'king of all'});
                  },
                  child: const Text('search:king of all, see if notifier'),
                ),
                ViewButtons(
                  onPressed: () {
                    route.pushNamed('home/search', arguments: {'focus': true, 'keyword': 'love'});
                  },
                  child: const Text('search:love and focus'),
                ),
                ViewButtons(
                  onPressed: () {
                    route.pushNamed('home/search', arguments: {'keyword': 'kings'});
                  },
                  child: const Text('search:kings, see if responsive'),
                ),
                ViewButtons(
                  onPressed: () {
                    data.searchQuery = 'loves';
                    route.pushNamed('search', arguments: {'keyword': 'loves', 'focus': true});
                  },
                  child: const Text('search in tab:loves and focus'),
                ),
                ViewButtons(
                  onPressed: () {
                    data.searchQuery = 'kings';
                    route.pushNamed('search', arguments: {'keyword': 'kings'});
                  },
                  child: const Text('search in tab:kings'),
                ),
                ViewButtons(
                  onPressed: () {
                    // route.pushNamed('search', arguments: {'keyword': 'kings'});
                    Navigator.pushNamed(context, 'home/search', arguments: {'keyword': 'kings'});
                  },
                  child: const Text('route'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
