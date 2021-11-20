# ?

```dart
import 'dart:async';
import 'dart:io';
// import 'dart:math';
// import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

// import 'package:lidea/provider.dart';

// import 'package:music/notifier.dart';
// import 'package:music/core/store.dart';
import 'package:music/core.dart';

import 'keep.consumable.dart';

// https://github.com/flutter/plugins/tree/master/packages/in_app_purchase/in_app_purchase/example/lib
// https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple

class CartMain extends StatefulWidget {
  CartMain({Key? key}) : super(key: key);
  @override
  _View createState() => _View();
}

class _View extends State<CartMain> {

  final bool _kAutoConsume = false;
  final _kOfConsumable = KeepConsumable(key: 'consumables');
  final _kOfPurchase = KeepConsumable(key: 'purchases');
  final _env = Core.instance.collection.env;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _listener;

  List<String> listOfNotFoundId = [];
  List<ProductDetails> listOfProductItem = [];
  List<PurchaseDetails> listOfPurchaseItem = [];


  bool isLoading = true;
  bool isPending = false;
  bool isAvailable = false;
  String? messageResponseError;

  String get offlineAccessId => _env.products.firstWhere((e) => e.name == "offline").cart;
  String get consumableId => _env.products.firstWhere((e) => e.name == "donate").cart;
  String get upgradeId => _env.products.firstWhere((e) => e.name == "upgrade").cart;
  String get silverSubscriptionId => _env.products.firstWhere((e) => e.name == "silver").cart;
  String get goldSubscriptionId => _env.products.firstWhere((e) => e.name == "gold").cart;
  List<String> get listOfProductId => _env.products.map((e) => e.cart).toList();

  bool isConsumableById(String id) => _env.products.indexWhere((e) => e.cart == id && e.type == "consumable") >= 0;

  @override
  void initState() {

    _listener = _inAppPurchase.purchaseStream.listen(
      _purchaseOnUpdate,
      onDone: _purchaseOnDone,
      onError: _purchaseOnError,
      cancelOnError: true
    );
    initStoreInfo();
    super.initState();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  Future<void> initStoreInfo() async {
    isAvailable = await _inAppPurchase.isAvailable();
    isPending = false;
    isLoading = false;
    if (!isAvailable) {
      setState((){});
      return;
    }

    ProductDetailsResponse itemResponse = await _inAppPurchase.queryProductDetails(listOfProductId.toSet());
    listOfProductItem = itemResponse.productDetails;
    listOfNotFoundId = itemResponse.notFoundIDs;
    if (itemResponse.error != null) {
      messageResponseError = itemResponse.error!.message;
      setState((){});
      return;
    }

    if (itemResponse.productDetails.isEmpty) {
      messageResponseError = null;
      setState((){});
      return;
    }

    await _inAppPurchase.restorePurchases();

    await _kOfConsumable.list;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    // final tmp = context.watch<StoreNotifier>();
    // final message = context.watch<Store>().message;
    // final message = context.watch<ParentStoreNotifier>().message;
    // final message = context.watch<ParentStoreNotifier>().message;
    List<Widget> _lst = [];
    if (messageResponseError == null) {
      _lst.add(
        Column(
          children: [
            Container(
              child: ElevatedButton(
                child: Text('Restore purchase'),
                onPressed: doRestore
              ),
            ),
            Container(
              child: ElevatedButton(
                child: Text('Consume all'),
                onPressed: (){

                  debugPrint(_kOfPurchase.data.toString());
                  debugPrint(listOfPurchaseItem.map((e) => e.productID).toList());
                  setState((){});
                }
              ),
            ),
            // Container(
            //   child: ElevatedButton(
            //     child: Text('test Notify $message'),
            //     onPressed: (){
            //       var _random = new Random();
            //       var _diceface = (_random.nextInt(6) +1).toString();
            //       // context.read<ParentStoreNotifier>().message = _diceface;
            //       // Core.instance.store.testUpdate(_diceface);
            //       // Core.instance.store.message = _diceface.toString();
            //       context.read<Store>().message = _diceface.toString();
            //       // Provider.of<StoreNotifier>(context, listen: false).message= _diceface.toString();
            //       // StoreNotifier().message = _diceface.toString();
            //     }
            //   ),
            // ),
            _buildProductList(),
            _buildDescription(),
            _buildConsumableBox(),
            _buildPurchasesBox()
          ],
        ),
      );
    } else {
      _lst.add(
        Center(
          child: Text(messageResponseError!),
        )
      );
    }

    if (isPending) {
      _lst.add(
        CircularProgressIndicator()
      );
    }

    return new SliverList(
      delegate: new SliverChildListDelegate(_lst)
    );

  }

  Widget _buildDescription() {
    Widget msgWidget = Text('Getting products...');
    Widget msgIcon = CircularProgressIndicator();
    if (isLoading) {
      // NOTE: Connecting to store...
    } else if (isAvailable) {
      // NOTE: Purchase is ready, Purchase is available
      msgWidget = Text('Ready to contribute!');
      msgIcon = Icon(CupertinoIcons.checkmark_shield,size: 50);
    } else {
      // NOTE: Connected to store, but purchase is not ready yet
      msgWidget = Text('Purchase unavailable');
      msgIcon = Icon(Icons.error_outlined,size: 50);
    }
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: msgIcon
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: msgWidget
          ),
          _buildConsumableStar(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Text('Any contribution makes a huge difference for the future of MyOrdbok.',textAlign: TextAlign.center,)
          )
        ]
      ),
    );
  }

  Widget _buildProductList() {
    if (isLoading) {
      return Card(
        child: Text('...')
      );
    }

    if (!isAvailable) {
      return Card();
    }


    List<Widget> itemsWidget = <Widget>[];

    String storeName = Platform.isAndroid?'Play Store':'App Store';

    if (listOfPurchaseItem.length == 0) {
      itemsWidget.add(
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0))
          ),
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical:5, horizontal:7),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child:Text('Unable to connect with $storeName!')
          )
        )
      );
    }
    // This app needs special configuration to run. Please see example/README.md for instructions.
    // if (listOfNotFoundId.isNotEmpty) {
    //   itemsWidget.add(
    //     Card(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.all(Radius.circular(7.0))
    //       ),
    //       elevation: 2,
    //       margin: EdgeInsets.symmetric(vertical:10, horizontal:10),
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    //         // child: Text('[${listOfNotFoundId.join(", ")}] not found',
    //         //   style: TextStyle(color: ThemeData.light().errorColor)
    //         // )
    //         child: RichText(
    //           textAlign: TextAlign.center,
    //           text: TextSpan(
    //             text: 'Unavailable ',
    //             style: TextStyle(color: Theme.of(context).primaryColor),
    //             children: listOfNotFoundId.map((String e) => TextSpan(
    //               style: TextStyle(color: Theme.of(context).errorColor),
    //               text: "$e, "
    //               )
    //             ).toList()
    //           )
    //         )
    //       ),
    //     )
    //   );
    // }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    Map<String, PurchaseDetails> purs = Map.fromEntries(
      listOfPurchaseItem.map((PurchaseDetails e) {
        if (e.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(e);
        }
        return MapEntry<String, PurchaseDetails>(e.productID, e);
      })
    );

    itemsWidget.addAll(listOfProductItem.map(
      (ProductDetails item) => _buildProductItem(item, purs),
    ));

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: itemsWidget
    );
  }

  Widget _buildProductItem(ProductDetails item, Map<String, PurchaseDetails> purs) {
    PurchaseDetails? previousPurchase = purs[item.id];
    bool hasPurchased = previousPurchase != null;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7.0))
      ),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical:5, horizontal:7),
      child: Semantics(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          leading: hasPurchased?Icon(
            CupertinoIcons.checkmark_shield_fill,
            size: 35
          ):null,
          title: Text(
            item.title.replaceAll(RegExp(r'\(.+?\)$'), ""),
            // semanticsLabel: item.title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.primaryVariant,
              fontSize: 18
            )
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top:10),
            child: Text(
              item.description,
              semanticsLabel: item.description,
              // textScaleFactor:0.9,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primaryVariant,
                fontWeight: FontWeight.w300
              )
            ),
          ),
          trailing: hasPurchased?Text(
            item.price,
            semanticsLabel: item.price,
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              fontWeight: FontWeight.w200,
              // color: Theme.of(context).backgroundColor,
              fontSize: 13
            ),
          ):TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size(90, 30),
              padding: EdgeInsets.symmetric(vertical:3, horizontal:7),
              backgroundColor: hasPurchased?null:Theme.of(context).primaryColorDark,
              // backgroundColor: hasPurchased?null:Colors.red,
              // primary: Theme.of(context).primaryColorLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)
              )
            ),
            // icon: Icon(
            //   hasPurchased?Icons.verified:CupertinoIcons.cart_fill,
            //   size: hasPurchased?40:20,
            // ),
            child: Text(
              item.price,
              semanticsLabel: item.price,
              style: TextStyle(
                color: Theme.of(context).primaryColorLight
              )
            ),
            onPressed: hasPurchased?null:() => doPurchase(item, purs)
          )
        ),
      ),
    );
  }

  Widget _buildConsumableStar() {
    if (isLoading) {
      return Container(
        child: Text('...')
      );
    }

    // !isAvailable || listOfNotFoundId.contains(consumableId)
    if (!isAvailable) {
      return Container(
        child: Text('not Available')
      );
    }

    return Wrap(
      children: _kOfConsumable.data.where(
        (id) => !listOfNotFoundId.contains(id)
      ).map(
        (String id) => IconButton(
          icon: Icon(Icons.star),
          iconSize: 35,
          color: Theme.of(context).primaryColorDark,
          onPressed: () async => _buildConsumableDialog(id)
        )
      ).toList()
    );
  }

  Widget _buildConsumableBox() {
    if (isLoading) {
      return Card(
        child: Text('loading')
      );
    }

    if (!isAvailable) {
      return Container(
        child: Text('not Available')
      );
    }

    return Card(
      child: Wrap(
        children: _kOfConsumable.data.where(
          (id) => !listOfNotFoundId.contains(id)
        ).map(
          (String id) => ListTile(
            title: Text(id),
            // subtitle: Text(e.value.type +': press to consume it'),
            onTap: () async => _buildConsumableDialog(id)
          )
        ).toList()
      ),
    );
  }

  Widget _buildPurchasesBox() {
    if (isLoading) {
      return Card(
        child: Text('loading')
      );
    }

    if (!isAvailable) {
      return Container(
        child: Text('not Available')
      );
    }

    return Card(
      child: Wrap(
        children: _kOfPurchase.data.where(
          (id) => !listOfNotFoundId.contains(id)
        ).map(
          (String id) => ListTile(
            title: Text(id),
            // subtitle: Text(e.value.type +': press to consume it'),
            onTap: () async {
              await _kOfPurchase.consume(id);
              setState((){});
            }
          )
        ).toList()
      ),
    );
  }

  void _buildConsumableDialog(String id) async{
    String label = "Are you sure to remove?";
    bool? confirmation = await showDialog<bool>(
      context: context,
      barrierLabel: label,
      builder: (context) => AlertDialog(
        title: Text('Are you sure',
          textAlign: TextAlign.center
        ),
        content: Text(label,
          textAlign: TextAlign.center
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text('No'),
            onPressed: ()=>Navigator.of(context, rootNavigator: true).pop(false)
          ),
          CupertinoButton(
            child: Text('Yes'),
            onPressed: ()=>Navigator.of(context, rootNavigator: true).pop(true)
          )
        ]
      )
    );
    if (confirmation != null && confirmation){
      await doConsume(id);
    }
  }

  Future<void> doConsume(String id) async {
    await _kOfConsumable.consume(id);
    setState((){});
  }

  Future<void> doPurchase(ProductDetails item, Map<String, PurchaseDetails> purs) async {
    late PurchaseParam param;

    if (Platform.isAndroid) {
      // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
      // verify the latest status of you your subscription by using server side receipt validation
      // and update the UI accordingly. The subscription purchase status shown
      // inside the app may not be accurate.
      final oldSubscription = _getOldSubscription(item, purs);

      param = GooglePlayPurchaseParam(
        productDetails: item,
        applicationUserName: null,
        changeSubscriptionParam: (oldSubscription != null)
          ? ChangeSubscriptionParam(
            oldPurchaseDetails: oldSubscription,
            prorationMode: ProrationMode.immediateWithTimeProration,
          )
          : null
      );
    } else {
      param = PurchaseParam(productDetails: item, applicationUserName: null);
    }

    // item.id == consumableId
    if (this.isConsumableById(item.id)) {
      _inAppPurchase.buyConsumable(purchaseParam: param, autoConsume: _kAutoConsume || Platform.isIOS);
    } else {
      _inAppPurchase.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<void> doRestore() async {
    await _inAppPurchase.restorePurchases();
    // debugPrint('total listOfPurchaseItem $listOfPurchaseItem');
    _kOfPurchase.data = listOfPurchaseItem.map((e) => e.productID).toList();
    await _kOfPurchase.save();
    setState((){});
  }

  void _handlePendingPurchase() {
    isPending = true;
    setState((){});
  }

  Future<void> _handleDeliverPurchase(PurchaseDetails item) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
      // debugPrint("good -> productID: ${item.productID} error: ${item.error} status: ${item.status}");
    // item.productID == consumableId
    // if (item.pendingCompletePurchase){
    //   debugPrint("-----------------------");
    //   debugPrint("productID: ${item.productID} error: ${item.error} status: ${item.status}");
      // debugPrint("pendingCompletePurchase: ${item.pendingCompletePurchase} purchaseID: ${item.purchaseID}");
      // debugPrint("transactionDate: ${item.transactionDate}");
    //   debugPrint("verificationData");
    //   debugPrint("localVerificationData: ${item.verificationData.localVerificationData}");
    //   debugPrint("serverVerificationData: ${item.verificationData.serverVerificationData}");
    //   debugPrint("source: ${item.verificationData.source}");
    //   debugPrint("-----------------------");
    // }
    if (this.isConsumableById(item.productID)) {
      if (item.pendingCompletePurchase && item.status == PurchaseStatus.purchased){
        await _kOfConsumable.insert(item.purchaseID!);
      }
    } else {
      final hasNotAdded = listOfPurchaseItem.indexWhere((e) => e.purchaseID == item.purchaseID) == -1;
      if (hasNotAdded){
        await _kOfPurchase.insert(item.productID);
        listOfPurchaseItem.add(item);
      }
    }

    isPending = false;
    setState((){});
  }

  void _handleError(IAPError error) {
    isPending = false;
    setState((){});
  }

  Future<bool> _handleVerifyPurchase(PurchaseDetails item) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails item) {
    // handle invalid purchase here if  _handleVerifyPurchase` failed.
  }

  void _purchaseOnUpdate(List<PurchaseDetails> items) {
    items.forEach((PurchaseDetails item) async {
      if (item.status == PurchaseStatus.pending) {
        _handlePendingPurchase();
      } else {
        if (item.status == PurchaseStatus.error) {
          _handleError(item.error!);
        } else if (item.status == PurchaseStatus.purchased) {
          bool valid = await _handleVerifyPurchase(item);
          if (valid) {
            _handleDeliverPurchase(item);
          } else {
            _handleInvalidPurchase(item);
            return;
          }
        } else if (item.status == PurchaseStatus.restored){
          _handleDeliverPurchase(item);
        }
        if (Platform.isAndroid) {
          // item.productID == consumableId
          if (!_kAutoConsume &&  this.isConsumableById(item.productID)) {
            final InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(item);
          }
        }
        if (item.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(item);
        }
      }
    });
  }

  void _purchaseOnDone() => _listener.cancel();

  void _purchaseOnError(dynamic error) => null;

  GooglePlayPurchaseDetails? _getOldSubscription(ProductDetails item, Map<String, PurchaseDetails> purs) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    GooglePlayPurchaseDetails? oldSubscription;
    if (item.id == silverSubscriptionId && purs[goldSubscriptionId] != null) {
      oldSubscription = purs[goldSubscriptionId] as GooglePlayPurchaseDetails;
    } else if (item.id == goldSubscriptionId && purs[silverSubscriptionId] != null) {
      oldSubscription = purs[silverSubscriptionId] as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }
}
