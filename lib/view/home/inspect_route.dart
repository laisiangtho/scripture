part of 'main.dart';

class InspectRoute extends StatefulWidget {
  const InspectRoute({super.key});

  @override
  State<InspectRoute> createState() => _InspectRouteState();
}

abstract class _InspectRouteAbstract extends CommonStates<InspectRoute> {}

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
                    context.go('/search');
                  },
                  child: const Text('to search'),
                ),
                ViewButtons(
                  onPressed: () {
                    // data.suggestQuery = 'love you as';
                    // app.conclusionGenerate(ord: 'love you as');
                    context.go('/search', extra: {'keyword': 'love you as'});
                  },
                  child: const Text('push:love you as, see if notifier'),
                ),
                ViewButtons(
                  onPressed: () {
                    // data.suggestQuery = 'king of all';
                    // app.conclusionGenerate(ord: 'king of all');
                    context.go('/search', extra: {'keyword': 'king of all'});
                  },
                  child: const Text('push:king of all, see if notifier'),
                ),
                ViewButtons(
                  onPressed: () {
                    context.go('/search', extra: {'focus': true, 'keyword': 'love'});
                  },
                  child: const Text('go:love and focus'),
                ),
                ViewButtons(
                  onPressed: () {
                    context.go('/search', extra: {'keyword': 'kings'});
                  },
                  child: const Text('go:kings, see if responsive'),
                ),
                ViewButtons(
                  onPressed: () {
                    // data.searchQuery = 'loves';
                    app.route.page.go('/search', extra: {'keyword': 'loves', 'focus': true});
                  },
                  child: const Text('go:loves and focus'),
                ),
                ViewButtons(
                  onPressed: () {
                    data.searchQuery = 'kings';
                    app.route.page.go('/search', extra: {'keyword': 'kings'});
                  },
                  child: const Text('search in tab:kings'),
                ),
                ViewButtons(
                  onPressed: () {
                    // routeOld.pushNamed('search', arguments: {'keyword': 'kings'});
                    Navigator.pushNamed(context, '/search', arguments: {'keyword': 'kings'});
                  },
                  child: const Text('Navigator.pushNamed'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
