import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/orders_model.dart';
import '../providers/auth_methods.dart';
import '../providers/firebase_functions.dart';

class InventoryItem extends StatefulWidget {
  final OrderModel order;
  final int index;
  final String route;

  // final Function onApprove;
  // final Function onDeny;
  const InventoryItem({
    Key? key,
    required this.order,
    required this.index,
    required this.route,
    // required this.onApprove,
    // required this.onDeny,
  }) : super(key: key);

  @override
  State<InventoryItem> createState() => _InventoryItemState();
}

class _InventoryItemState extends State<InventoryItem> {
  List products = [];
  bool loading = true;

  filterDataForQueue() {
    for (int i = 0; i < widget.order.items_quantity!.length; i++) {
      if (widget.order.items_quantity![i].item ==
          "Tablets + Tote Bag (1 per tablet)") {
        var productMap = {
          'item': widget.order.items_quantity![i].item,
          'id': widget.order.id,
          'status': widget.order.status,
          'orderBy': widget.order.email,
          'quantity': widget.order.items_quantity!.length.toString(),
        };
        products.add(productMap);
      }
    }
  }

  filterDataForComplete() {
    for (int i = 0; i < widget.order.items_quantity!.length; i++) {
      if (widget.order.items_quantity![i].item ==
          "Tablets + Tote Bag (1 per tablet)") {
        if (widget.order.items_quantity![i].trackingId != null ||
            widget.order.items_quantity![i].trackingId != "") {
          var productMap = {
            'item': widget.order.items_quantity![i].item,
            'id': widget.order.id,
            'status': widget.order.status,
            'orderBy': widget.order.email,
            'quantity': widget.order.items_quantity!.length.toString(),
            'trackingId': widget.order.items_quantity![i].trackingId,
          };
          products.add(productMap);
        }
      }
    }
    print(products);
  }

  @override
  void initState() {
    if (widget.route == "queue") {
      filterDataForQueue();
    } else {
      filterDataForComplete();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderItems = widget.order.items_quantity!;
    return widget.route == "queue"
        ? uiForQueue(products, widget.order, orderItems)
        : uiForComplete(products, widget.order, orderItems);
  }
}

Widget uiForQueue(List products, OrderModel order, List orderItems) {
  if (products.isEmpty) {
    return SizedBox(
      height: 0,
    );
  } else {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Id: ${order.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Order By: ${order.email}',
            ),
            Text('Status: ${order.status}'),
            ExpansionTile(
              title: const Text('Items'),
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      return order.items_quantity![index].item.toString() ==
                              "Tablets + Tote Bag (1 per tablet)"
                          ? Card(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(orderItems[index].item!),
                                  Text(
                                      'Quantity: ${orderItems[index].quantity}'),
                                  //Text('TrackingId: ${orderItems[index].trackingId}'),
                                  Text(
                                      'Tracking Id: ${orderItems[index].trackingId}'),
                                  ElevatedButton(
                                      onPressed: () {
                                        addTrackingId(
                                            context,
                                            order.id,
                                            index,
                                            orderItems[index].item!,
                                            orderItems[index].quantity);
                                      },
                                      child: Text('Add Tracking ID'))
                                ],
                              ),
                            )
                          : SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget uiForComplete(List products, OrderModel order, List orderItems) {
  return Text("complete list will be here.");
}

void addTrackingId(BuildContext context, String? orderId, int ind,
    String? itemEdit, int? quantity) {
  String trackingText = '';
  showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Tracking Id'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Tracking Id'),
                onChanged: (value) => trackingText = value,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (trackingText == null) {
                  showSnackBar(context, 'You have an invalid value');
                } else {
                  FDF().editOrder(
                      orderId!,
                      ind,
                      Item(
                          item: itemEdit,
                          quantity: quantity,
                          trackingId: trackingText));
                }
                ;
                // onSubmit(reason,tracking);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      });

  Widget ui(List products, List orderItems) {
    return products.isEmpty
        ? const SizedBox(
            height: 0.0,
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return products.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Id: ${products[index]['id']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Order By: ${products[index]['orderBy']}',
                              ),
                              Text('Status: ${products[index]['status']}'),
                              ExpansionTile(
                                title: const Text('Items'),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(products[index]['item']),
                                      Text(
                                          'Quantity: ${products[index]['quantity']}'),
                                      //Text('TrackingId: ${orderItems[index].trackingId}'),
                                      Text(
                                          'Tracking Id: ${orderItems[index].trackingId}'),
                                      ElevatedButton(
                                          onPressed: () {
                                            addTrackingId(
                                                context,
                                                products[index]['id'],
                                                index,
                                                products[index]['item'],
                                                int.parse(products[index]
                                                    ['quantity']));
                                          },
                                          child: Text('Add Tracking ID'))
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Text("d");
                  }),
            ),
          );
  }
}
