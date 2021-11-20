# ?

```dart
import 'package:lidea/keep.dart';

/// A store of consumable items.
///
/// This is a development prototype tha stores consumables in the shared
/// preferences. Do not use this in real world apps.
class KeepConsumable{

  late KeepUser _user;
  late List<String> _cached = [];

  KeepConsumable({String? key}) {
    _user = KeepUser(key: key??'consumables');
    _cached=[];
  }

  /// Returns the list of consumables from the store.
  List<String> get data {
    return _cached;
  }
  set data(List<String>? v) {
    _cached = v!;
  }

  Future<List<String>> get list async  => (await _user.getList()) ?? [];

  Future<void> insert(String value) async {
    _cached = await list;

    _cached.add(value);
    await _user.setList(value: _cached.toSet().toList());

  }

  Future<void> consume(String value) async {
    _cached = await list;
    if (_cached.remove(value)){
      await _user.setList(value: _cached);
    }
  }
  Future<void> save() async {
    await _user.setList(value: data);
  }
}

// const String _kConsumableId = 'consumable_testing';
// const String _kUpgradeId = 'upgrade';
// const String _kSilverSubscriptionId = 'subscription_silver';
// const String _kGoldSubscriptionId = 'offlineaccess'
// final hasNotAdded = _purchases.firstWhere((e) => e.purchaseID == purchaseDetails.purchaseID, orElse: () =>null) == null;
// if (hasNotAdded){}
// Container(
//   child: ElevatedButton(
//     child: Text('Restore'),
//     onPressed: _restorePurchasesByUser
//   ),
// ),
// Future<void> _restorePurchasesByUser() async {
//   // debugPrint('_restorePurchasesByUser');
//   // await _inAppPurchase.restorePurchases();
//   debugPrint('total _purchases $_purchases');


//   // _purchases.addAll(purchaseDetailsList);
//   // setState(() {});
//   // final response = await _inAppPurchase.restorePurchases();

//   // for (PurchaseDetails purchase in response.pastPurchases) {
//   //   if (Platform.isIOS) {
//   //     _inAppPurchase.completePurchase(purchase);
//   //   }
//   // }

//   // setState(() {
//   //   _purchases = response.pastPurchases;
//   // });
// }
