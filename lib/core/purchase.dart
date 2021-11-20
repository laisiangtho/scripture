import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'package:bible/type.dart';

class Store {
  late Collection _cluster;
  late void Function() _notify;

  String message = 'working';

  final bool _kAutoConsume = false;
  // final _kOfConsumable = KeepConsumable(key: 'consumables');
  // final _kOfPurchase = KeepConsumable(key: 'purchases');

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _listener;

  List<String> listOfNotFoundId = [];
  List<ProductDetails> listOfProductItem = [];
  List<PurchaseDetails> listOfPurchaseItem = [];

  bool isLoading = true;
  bool isPending = false;
  bool isAvailable = false;
  String? messageResponseError;

  ProductsType productbyCart(String id) => _cluster.env.products.firstWhere((e) => e.cart == id);
  // ProductsType get offlineAccessItem => _cluster.env.products.firstWhere((e) => e.name == "offline");
  // ProductsType get thesaurusItem => _cluster.env.products.firstWhere((e) => e.name == "upgrade");
  // ProductsType get partOfSpeechItem => _cluster.env.products.firstWhere((e) => e.name == "silver");

  String get offlineAccessId => _cluster.env.products.firstWhere((e) => e.name == "offline").cart;
  String get consumableId => _cluster.env.products.firstWhere((e) => e.name == "donate").cart;
  String get upgradeId => _cluster.env.products.firstWhere((e) => e.name == "upgrade").cart;
  String get silverSubscriptionId =>
      _cluster.env.products.firstWhere((e) => e.name == "silver").cart;
  String get goldSubscriptionId => _cluster.env.products.firstWhere((e) => e.name == "gold").cart;
  List<String> get listOfProductId => _cluster.env.products.map((e) => e.cart).toList();

  bool isConsumableById(String id) =>
      _cluster.env.products.indexWhere((e) => e.cart == id && e.type == "consumable") >= 0;

  Store({void Function()? notify, Collection? collection}) {
    _cluster = collection!;
    _notify = notify!;
  }

  Future<void> init() async {
    _listener = _inAppPurchase.purchaseStream.listen(_purchaseOnUpdate,
        onDone: _purchaseOnDone, onError: _purchaseOnError, cancelOnError: true);
    await initStoreInfo();
  }

  void testUpdate(String str) {
    // message = str;
    message = _cluster.env.name;
    _notify();
  }

  Future<void> initStoreInfo() async {
    isAvailable = await _inAppPurchase.isAvailable();
    isPending = false;
    isLoading = false;
    if (!isAvailable) {
      _notify();
      return;
    }

    ProductDetailsResponse itemResponse =
        await _inAppPurchase.queryProductDetails(listOfProductId.toSet());
    listOfProductItem = itemResponse.productDetails;
    listOfNotFoundId = itemResponse.notFoundIDs;
    if (itemResponse.error != null) {
      messageResponseError = itemResponse.error!.message;
      _notify();
      return;
    }

    if (itemResponse.productDetails.isEmpty) {
      messageResponseError = null;
      _notify();
      return;
    }

    // await _inAppPurchase.restorePurchases();

    // await _kOfConsumable.list;
    _notify();
  }

  Future<void> doConsume(String purchaseId) async {
    // await _kOfConsumable.consume(purchaseId);
    _cluster.boxOfPurchaseDeleteByPurchaseId(purchaseId);
    _notify();
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
              : null);
    } else {
      param = PurchaseParam(productDetails: item, applicationUserName: null);
    }

    // debugPrint(param);
    // final abc = isConsumableById(item.id);
    // debugPrint('? ${item.id} is Consumable $abc!');
    // debugPrint(purs);

    // item.id == consumableId
    if (isConsumableById(item.id)) {
      _inAppPurchase.buyConsumable(
          purchaseParam: param, autoConsume: _kAutoConsume || Platform.isIOS);
    } else {
      _inAppPurchase.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<void> doRestore() async {
    // await Future.delayed(Duration(milliseconds: 1500));
    await _inAppPurchase.restorePurchases();
    // debugPrint('total listOfPurchaseItem $listOfPurchaseItem');
    // _kOfPurchase.data = listOfPurchaseItem.map((e) => e.productID).toList();
    // await _kOfPurchase.save();
    for (var e in listOfPurchaseItem) {
      if (_cluster.boxOfPurchase.values.where((o) => o.purchaseId == e.purchaseID).isEmpty) {
        _cluster.boxOfPurchase.add(PurchaseType(
            productId: e.productID,
            purchaseId: e.purchaseID,
            completePurchase: e.pendingCompletePurchase,
            transactionDate: e.transactionDate));
      }
    }

    _notify();
  }

  void _handlePendingPurchase() {
    isPending = true;
    _notify();
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
    if (isConsumableById(item.productID)) {
      if (item.pendingCompletePurchase && item.status == PurchaseStatus.purchased) {
        // await _kOfConsumable.insert(item.purchaseID!);
        if (_cluster.boxOfPurchase.values.where((o) => o.purchaseId == item.purchaseID).isEmpty) {
          _cluster.boxOfPurchase.add(PurchaseType(
              productId: item.productID,
              purchaseId: item.purchaseID,
              completePurchase: item.pendingCompletePurchase,
              transactionDate: item.transactionDate,
              consumable: true));
        }
      }
    } else {
      final hasNotAdded =
          listOfPurchaseItem.indexWhere((e) => e.purchaseID == item.purchaseID) == -1;
      if (hasNotAdded) {
        // await _kOfPurchase.insert(item.productID);
        listOfPurchaseItem.add(item);
        if (_cluster.boxOfPurchase.values.where((o) => o.purchaseId == item.purchaseID).isEmpty) {
          _cluster.boxOfPurchase.add(PurchaseType(
              productId: item.productID,
              purchaseId: item.purchaseID,
              completePurchase: item.pendingCompletePurchase,
              transactionDate: item.transactionDate,
              consumable: false));
        }
      }
    }

    isPending = false;
    _notify();
  }

  void _handleError(IAPError error) {
    isPending = false;
    _notify();
  }

  Future<bool> _handleVerifyPurchase(PurchaseDetails item) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails item) {
    // handle invalid purchase here if  _handleVerifyPurchase` failed.
  }

  void _purchaseOnUpdate(List<PurchaseDetails> items) async {
    for (var item in items) {
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
        } else if (item.status == PurchaseStatus.restored) {
          _handleDeliverPurchase(item);
        }
        if (Platform.isAndroid) {
          // item.productID == consumableId
          if (!_kAutoConsume && isConsumableById(item.productID)) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(item);
          }
        }
        if (item.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(item);
        }
      }
    }
  }

  void _purchaseOnDone() => _listener.cancel();

  void _purchaseOnError(dynamic error) => true;

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails item, Map<String, PurchaseDetails> purs) {
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

  Map<String, PurchaseDetails> get getPreviousPurchases {
    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    Map<String, PurchaseDetails> purs = Map.fromEntries(listOfPurchaseItem.map((PurchaseDetails e) {
      if (e.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(e);
      }
      return MapEntry<String, PurchaseDetails>(e.productID, e);
    }));
    return purs;
  }
}
