import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/orders_model.dart';
import '../providers/auth_methods.dart';
import '../providers/firebase_functions.dart';

class MarkOrderItem extends StatelessWidget {
  final OrderModel order;

  // final Function onApprove;
  // final Function onDeny;
  const MarkOrderItem({
    Key? key,
    required this.order,
    // required this.onApprove,
    // required this.onDeny,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final orderItems = order.items_quantity!;
    //var checkMe = orderItems.where((element) => element.item == 'Receipt paper');
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
                            return Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    if(orderItems[index].item != 'Tablets + Tote Bag (1 per tablet)')...[
                                      Text(orderItems[index].item!),
                                      Text('Quantity: ${orderItems[index]
                                          .quantity}'),
                                      //Text('TrackingId: ${orderItems[index].trackingId}'),
                                      Text('Tracking Id: ${orderItems[index]
                                          .trackingId}'),
                                      ElevatedButton(
                                          onPressed: () {
                                            addTrackingId(
                                                context, order.id, index,
                                                orderItems[index].item!,
                                                orderItems[index]
                                                    .quantity);
                                          },
                                          child: Text('Add Tracking ID'))
                                     ]
                                    ],
                                )
                            );
                          }
                    )
                  )
                ],
              ),


            ],
          ),
        ),
      );
     }

    }



void addTrackingId (BuildContext context, String? orderId, int ind,String? itemEdit,int? quantity) {
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
                decoration:
                InputDecoration(hintText: 'Tracking Id'),
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
                }
                else {
                  FDF().editOrder(
                      orderId!,
                      ind,
                      Item(
                          item: itemEdit,
                          quantity: quantity,
                          trackingId: trackingText
                      )
                  );
                };
                // onSubmit(reason,tracking);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      });
}


//inventory = > tablate
// marketing = > everything except tablate
