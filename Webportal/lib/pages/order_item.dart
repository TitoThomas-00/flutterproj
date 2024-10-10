import 'dart:developer';

import 'package:compain_app_web/pages/list_of_items.dart';
import 'package:compain_app_web/providers/auth_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/orders_model.dart';
import '../providers/firebase_functions.dart';

class OrderItem extends StatelessWidget {
  final OrderModel order;
  // final Function onApprove;
  // final Function onDeny;
  const OrderItem({
    Key? key,
    required this.order,
    // required this.onApprove,
    // required this.onDeny,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final orderItems = order.items_quantity!;
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
                    itemBuilder: (context, index) =>
                        Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(orderItems[index].item!),
                            Text('Quantity: ${orderItems[index].quantity}'),
                            //Text('TrackingId: ${orderItems[index].trackingId}'),
                            Row(
                                children: [
                            ElevatedButton(
                                onPressed: () {
                                  showEditDialog(context,order.id!,index,orderItems[index].item!,orderItems[index].quantity);
                                  // FDF().addOrder(
                                  //   order.id!,
                                  //   Item(
                                  //   item: "Tablets + Tote Bag (1 per tablet)",
                                  //    quantity: 2,
                                  //     trackingId: ""
                                  //   )
                                  // );
                                },
                                child: const Text('Edit')
                            ),
                                  SizedBox(width: 10,),
                                  if(order.status == 'pending')...[
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty
                                                .all(Colors.red)),
                                        onPressed: () {
                                          deleteDialog(
                                              context, order.id!, index,
                                              orderItems[index].item!,
                                              orderItems[index].quantity);
                                          // FDF().addOrder(
                                          //   order.id!,
                                          //   Item(
                                          //   item: "Tablets + Tote Bag (1 per tablet)",
                                          //    quantity: 2,
                                          //     trackingId: ""
                                          //   )
                                          // );
                                        },
                                        child: const Text('Delete')
                                    ),
                                  ]


                          ]),
                              ],
                        )),
                  ),
                )
              ],
            ),
            // ...[
            //   ...order.items_quantity!
            //       .map((e) => Text('${e.item} : ${e.quantity}'))
            //       .toList()
            // ],
            if (order.status == 'pending') ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      addOrderDialog(context, order.id!);
                    },
                    child: const Text('Add Item'),
                  ),
                  

                  TextButton(
                    onPressed: () async {
                      order.status = 'Approved';
                      showReasonDialog(context, true);
                    },
                    child: const Text('Approve'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () async {
                      order.status = 'Declined';
                      showReasonDialog(context, false);
                    },
                    child: const Text('Deny'),
                  ),
                ],
              ),
            ],


          ],
        ),
      ),
    );
  }


  void addOrderDialog(BuildContext context,String orderId){
    String? itemEdit;
    int? quantity = 0;

    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Add Order'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration:
                  InputDecoration(hintText: itemsName.keys.first),
                  onChanged: (value) => itemEdit = value,
                ),
                TextField(
                  decoration:
                  InputDecoration(hintText: '$quantity'),
                  onChanged: (value) => quantity = int.parse(value),
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
                  if(itemEdit == null || quantity == null ||quantity! <= 0 ){
                    showSnackBar(context, 'You have an invalid value');
                  }
                  else{
                  FDF().addOrder(
                      orderId,
                      Item(
                          item: itemEdit,
                          quantity: quantity,
                          trackingId: ''

                      ));};
                  // onSubmit(reason,tracking);
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
  }

  void showEditDialog(BuildContext context,String orderId,int ind, String items,int? quantity){
    String itemEdit = items;
    int? quantityEdit = quantity;
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Edit Order'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Previous item: $items'),
                DropdownItemMenu(),
                TextField(
                  decoration:
                  InputDecoration(hintText: '$quantity'),
                  onChanged: (value) => quantity = int.parse(value),
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
                  FDF().editOrder(
                      orderId,
                      ind,
                      Item(
                          item: itemEdit,
                          quantity: quantity,
                          trackingId: ''

                      ));
                  // onSubmit(reason,tracking);
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
  }

  void showReasonDialog(BuildContext context, bool approve) {
    String reason = '';
    String tracking = '';
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Please fill out'),
          content: Column(
            children: [
              approve
                  ? TextField(
                decoration:
                const InputDecoration(hintText: 'Tracking number '),
                onChanged: (value) => tracking = value,
              )
                  : TextField(
                decoration: const InputDecoration(hintText: 'Reason why'),
                onChanged: (value) => reason = value,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'comments'),
                onChanged: (value) => tracking = value,
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                log(order.status.toString());
                FDF().respondRequest('mrubenstein49@gmail.com', order.id!,
                    order.status!, reason, tracking);
                // onSubmit(reason,tracking);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void deleteDialog(BuildContext context, String orderId, int ind, String items,
      int? quantity) {
    String itemEdit = items;
    int? quantityEdit = quantity;
    String reason = items+" - "+ "Denied/Deleted";
    TextEditingController reasoning = TextEditingController();
    bool _isVisible = false;
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (dialogContext)
        {
          return StatefulBuilder(
              builder: (builder, setState) {
                return AlertDialog(
                    title: const Text('Delete Order', textAlign: TextAlign.center,),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              items
                          ),
                          Text(
                              'Quantity: $quantityEdit'
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() => _isVisible = !_isVisible);
                              }, child: Text(
                              'Give a reason'
                          )),
                          Visibility(
                              visible: _isVisible,
                              child: TextField(
                                controller: reasoning,
                                minLines: 1,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  prefixText: reason,
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter a reason',
                                ),
                              ))

                        ]),
                    actions: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(dialogContext).pop(),
                              child: const Text('Cancel'),
                            ),
                            SizedBox(width: 10,),

                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.red)),
                              onPressed: () {
                                if(reasoning.text.isNotEmpty)
                                {
                                  FDF().reasonResponse(orderId, reason+reasoning.text);
                                }
                                FDF().deleteOrder(
                                    orderId,
                                    ind,
                                    Item(
                                        item: itemEdit,
                                        quantity: quantity,
                                        trackingId: ''
                                    )
                                );
                                // onSubmit(reason,tracking);
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Delete'),
                            ),
                          ])
                    ]);
              });
        });
  }

}

class DropdownItemMenu extends StatefulWidget {


   DropdownItemMenu({super.key});

  @override
  State<DropdownItemMenu> createState() => _DropdownItemMenuState();
}

class _DropdownItemMenuState extends State<DropdownItemMenu>
{
  String itemEdit = itemsName.keys.first;
  @override
  Widget build(BuildContext context) {
    return
      Column(
          children: [
      DropdownButton<String>(
        value: itemEdit,
        items: itemsName.keys.map<DropdownMenuItem<String>>((String value){
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value){
          setState(() {
            itemEdit = value!;
          });
        }),
    ]);
  }

}


