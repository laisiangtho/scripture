import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:lidea/provider.dart';

import 'package:bible/core.dart';
import 'package:bible/type.dart';
import 'package:bible/widget.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends State<PurchaseView> {
  late Core core;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Core>(
      builder: (BuildContext _, Core core, Widget? child) => buildContainer(),
    );
  }

  Widget buildContainer() {
    List<Widget> sliverChildren = [];
    if (core.store.messageResponseError == null) {
      sliverChildren.add(
        Column(
          children: [
            // Container(
            //   child: ElevatedButton(
            //     child: Text('Restore purchase'),
            //     onPressed: core.store.doRestore
            //   ),
            // ),
            // Container(
            //   child: ElevatedButton(
            //     child: Text('Consume all'),
            //     onPressed: null
            //   ),
            // ),
            _buildProductList(),
            _buildDescription(),
            // _buildConsumableBox(),
            // _buildPurchasesBox()
          ],
        ),
      );
    } else {
      if (core.store.isPending) {
        sliverChildren.add(const Center(
          child: CircularProgressIndicator(),
        ));
      } else {
        sliverChildren.add(Center(
          child: Text(core.store.messageResponseError!),
        ));
      }
    }

    // if (core.store.isPending) {
    //   _lst.add(
    //     CircularProgressIndicator()
    //   );
    // }
    // sliverChildren.add(
    //   Center(
    //     child: CircularProgressIndicator(
    //       value: 0.7,
    //     ),
    //   )
    // );

    return SliverList(delegate: SliverChildListDelegate(sliverChildren));
  }

  Widget _buildDescription() {
    Widget msgWidget = const Text('Getting products...');
    Widget msgIcon = CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColorDark,
      strokeWidth: 2,
    );

    if (core.store.isLoading) {
      // NOTE: Connecting to store...
    } else if (core.store.isPending) {
      msgWidget = const Text('A moment please');
    } else if (core.store.isAvailable) {
      // NOTE: Purchase is ready, Purchase is available
      msgWidget = const Text(
        'Ready to contribute!',
        style: TextStyle(fontSize: 20),
      );
      msgIcon = const Icon(CupertinoIcons.checkmark_shield, size: 50);
    } else {
      // NOTE: Connected to store, but purchase is not ready yet
      msgWidget = const Text('Purchase unavailable');
      msgIcon = const Icon(Icons.error_outlined, size: 50);
    }
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: msgIcon),
          Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: msgWidget),
          _buildConsumableStar(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Text(
              'Any contribution makes a huge difference for the future of MyOrdbok.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (core.store.isLoading) {
      return const Card(
        child: Text('...'),
      );
    }

    // if (!core.store.isAvailable) {
    //   return Card();
    // }

    List<Widget> itemsWidget = <Widget>[];

    String storeName = Platform.isAndroid ? 'Play Store' : 'App Store';

    if (core.store.listOfPurchaseItem.isEmpty && !core.store.isAvailable) {
      itemsWidget.add(Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: Text('Unable to connect with $storeName!'),
        ),
      ));
    }
    // This app needs special configuration to run. Please see example/README.md for instructions.
    // if (core.store.listOfNotFoundId.isNotEmpty) {
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
    //             children: core.store.listOfNotFoundId.map((String e) => TextSpan(
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

    Map<String, PurchaseDetails> purs = core.store.getPreviousPurchases;

    itemsWidget.addAll(core.store.listOfProductItem.map(
      (ProductDetails item) => _buildProductItem(item, purs),
    ));

    return Column(mainAxisSize: MainAxisSize.max, children: itemsWidget);
  }

  Widget _buildProductItem(ProductDetails item, Map<String, PurchaseDetails> purs) {
    PurchaseDetails? previousPurchase = purs[item.id];
    bool hasPurchasedPreviously = previousPurchase != null;
    String title = item.title;
    String description = item.description;
    if (title.isEmpty) {
      final ev = core.store.productbyCart(item.id);
      title = ev.title;
      description = ev.description;
    }

    final hasPurchased = hasPurchasedPreviously ||
        core.collection.boxOfPurchase.values.where((o) => o.productId == item.id).isNotEmpty;
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      child: Semantics(
        child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            leading:
                hasPurchased ? const Icon(CupertinoIcons.checkmark_shield_fill, size: 35) : null,
            title: Text(
              title.replaceAll(RegExp(r'\(.+?\)$'), ""),
              // semanticsLabel: item.title,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primaryVariant,
                fontSize: 20,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                description,
                semanticsLabel: description,
                // textScaleFactor:0.9,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryVariant,
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            // trailing: hasPurchased?Text(
            //   item.price,
            //   semanticsLabel: item.price,
            //   style: TextStyle(
            //     decoration: TextDecoration.lineThrough,
            //     fontWeight: FontWeight.w200,
            //     // color: Theme.of(context).backgroundColor,
            //     fontSize: 13
            //   ),
            // ):TextButton(
            //   style: TextButton.styleFrom(
            //     minimumSize: Size(90, 30),
            //     padding: EdgeInsets.symmetric(vertical:3, horizontal:7),
            //     backgroundColor: hasPurchased?null:Theme.of(context).primaryColorDark,
            //     // backgroundColor: hasPurchased?null:Colors.red,
            //     // primary: Theme.of(context).primaryColorLight,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(100)
            //     )
            //   ),
            //   child: Text(
            //     item.price,
            //     semanticsLabel: item.price,
            //     style: TextStyle(
            //       color: Theme.of(context).primaryColorLight
            //     )
            //   ),
            //   onPressed: hasPurchased?null:() => core.store.doPurchase(item, purs)
            // )
            trailing: hasPurchased
                ? null
                : CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                    minSize: 45,
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                    child: Text(
                      item.price,
                      semanticsLabel: item.price,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 17,
                      ),
                    ),
                    onPressed: hasPurchased ? null : () => core.store.doPurchase(item, purs),
                  )
            // trailing: hasPurchased?null:TextButton(
            //   style: TextButton.styleFrom(
            //     minimumSize: Size(110, 50),
            //     padding: EdgeInsets.symmetric(vertical:3, horizontal:7),
            //     // backgroundColor: Theme.of(context).primaryColorDark,
            //     backgroundColor: Theme.of(context).backgroundColor,
            //     // backgroundColor: hasPurchased?null:Colors.red,
            //     // primary: Theme.of(context).primaryColorLight,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(100)
            //     )
            //   ),
            //   child: Text(
            //     item.price,
            //     semanticsLabel: item.price,
            //     style: TextStyle(
            //       // color: Theme.of(context).primaryColorLight,
            //       fontSize: 17
            //     )
            //   ),
            //   onPressed: hasPurchased?null:() => core.store.doPurchase(item, purs)
            // )
            ),
      ),
    );
  }

  Widget _buildConsumableStar() {
    if (core.store.isLoading) {
      return const Text('...');
    }

    // !isAvailable || listOfNotFoundId.contains(consumableId)
    if (!core.store.isAvailable) {
      return const Text('not Available');
    }

    // _kOfConsumable.data
    // return Wrap(
    //   children: _kOfConsumable.data.where(
    //     (id) => !core.store.listOfNotFoundId.contains(id)
    //   ).map(
    //     (String id) => IconButton(
    //       icon: Icon(Icons.star),
    //       iconSize: 35,
    //       color: Theme.of(context).primaryColorDark,
    //       onPressed: () async => _buildConsumableDialog(id)
    //     )
    //   ).toList()
    // );
    return Selector<Core, Iterable<PurchaseType>>(
      selector: (BuildContext _, Core core) => core.collection.boxOfPurchase.values
          .toList()
          .where((e) => e.consumable == true && !core.store.listOfNotFoundId.contains(e.productId)),
      builder: (BuildContext _, Iterable<PurchaseType> data, Widget? child) {
        return Card(
          child: Wrap(
            // _kOfConsumable.data
            children: data
                .map(
                  (PurchaseType e) => IconButton(
                    icon: const Icon(Icons.star),
                    iconSize: 35,
                    color: Theme.of(context).primaryColorDark,
                    // onPressed: () async => _buildConsumableDialog(e.productId)
                    onPressed: () {
                      doConfirmWithDialog(
                        context: context,
                        message: 'Are you sure to remove?',
                      ).then((bool? confirmation) {
                        // debugPrint('TODO: Consumable consume');
                        if (confirmation != null && confirmation) {
                          core.store.doConsume(e.purchaseId!);
                        }
                      });
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  // Widget _buildConsumableBox() {
  //   if (core.store.isLoading) {
  //     return Card(
  //       child: Text('loading')
  //     );
  //   }

  //   if (!core.store.isAvailable) {
  //     return Container(
  //       child: Text('not Available')
  //     );
  //   }

  //   return Selector<Core, Iterable<PurchaseType>>(
  //     selector: (BuildContext _, Core core) => core.collection.boxOfPurchase.values.toList().where(
  //       (e) => e.consumable == true && !core.store.listOfNotFoundId.contains(e.productId)
  //     ),
  //     builder: (BuildContext _, Iterable<PurchaseType> data, Widget? child) {
  //       return Card(
  //         child: Wrap(
  //           // _kOfConsumable.data
  //           children: data.map(
  //             (PurchaseType e) => ListTile(
  //               title: Text(e.productId),
  //               subtitle: Text(e.purchaseId!),
  //               // onTap: () async => _buildConsumableDialog(e.productId)
  //               onTap: () {
  //                 doConfirmWithDialog(
  //                   context: context,
  //                   message: 'Are you sure to remove?'
  //                 ).then(
  //                   (bool? confirmation) {
  //                     // debugPrint('TODO: Consumable consume');
  //                     if (confirmation != null && confirmation) core.store.doConsume(e.purchaseId!);
  //                   }
  //                 );
  //               }
  //             )
  //           ).toList()
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildPurchasesBox() {
  //   if (core.store.isLoading) {
  //     return Card(
  //       child: Text('loading')
  //     );
  //   }

  //   if (!core.store.isAvailable) {
  //     return Container(
  //       child: Text('not Available')
  //     );
  //   }

  //   return Selector<Core, Iterable<PurchaseType>>(
  //     selector: (BuildContext _, Core core) => core.collection.boxOfPurchase.values.toList().where(
  //       (e) => e.consumable == false && !core.store.listOfNotFoundId.contains(e.productId)
  //     ),
  //     builder: (BuildContext _, Iterable<PurchaseType> data, Widget? child) {
  //       return Card(
  //         child: Wrap(
  //           // _kOfPurchase.data
  //           children: data.map(
  //             (PurchaseType e) => ListTile(
  //               title: Text(e.productId),
  //               // subtitle: Text(e.value.type +': press to consume it'),
  //               onTap: () {
  //                 doConfirmWithDialog(
  //                   context: context,
  //                   message: 'Are you sure to remove?'
  //                 ).then(
  //                   (bool? confirmation) {
  //                     // debugPrint('TODO: Purchase consume');
  //                     if (confirmation != null && confirmation) core.store.doConsume(e.purchaseId!);
  //                   }
  //                 );
  //               }
  //             )
  //           ).toList()
  //         ),
  //       );
  //     },
  //   );
  // }

}
