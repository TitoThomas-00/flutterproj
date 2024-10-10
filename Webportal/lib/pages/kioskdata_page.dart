import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/orders_model.dart';
import '../providers/firebase_functions.dart';

class kioskData extends StatelessWidget
{
   kioskData({super.key, required this.docID});

final String docID;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF12264F),
        title: Text('${docID}'),
      ),
      body:  FutureBuilder<List<OrderModel>>(
        future: FDF().getSortedData(docID),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  Text("loading...")
                ],
              ),
            );
          }
          else if (snapshot.data?.length == 0)
          {
            return Center(
              child: Text('No Orders...', style: TextStyle(fontSize: 24),),
            );

          }
          else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                var orderItems = snapshot.data?[index].items_quantity;
                  return Card(
                    shadowColor: Colors.grey,
                       child:SizedBox(

                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5),
                   child: Column(
                    children: [
                   Text('${snapshot.data?[index].id}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Text('${snapshot.data?[index].orderCreated?.toDate().month}/${snapshot.data?[index].orderCreated?.toDate().day}/${snapshot.data?[index].orderCreated?.toDate().year}'),
                      //Text('${snapshot.data?[index].status}'),

                      if(snapshot.data?[index].status == 'pending') ... [
                        Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text('${snapshot.data?[index].status}'),
                         SizedBox(width: 5,),
                         Container(
                             width: 8,
                             height: 8,
                             decoration: BoxDecoration(
                                 color: Colors.yellow,
                                 shape: BoxShape.circle))
                          ]),
                      ],
                      if(snapshot.data?[index].status == 'Approved') ... [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${snapshot.data?[index].status}'),
                              SizedBox(width: 5,),
                              Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle))
                            ]),
                      ],
                      if(snapshot.data?[index].status == 'Declined') ... [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${snapshot.data?[index].status}'),
                              SizedBox(width: 5,),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle))
                            ]),
                      ],
                      ExpansionTile(
                        title: const Text('Items'),
                        children: [
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ListView.builder(
                                  itemCount: orderItems?.length,
                                  itemBuilder: (context, index) =>
                                      ListTile(
                                        title: Text('${orderItems![index].item}\n Quantity: ${orderItems[index].quantity}\n ',style: TextStyle(fontSize: 15),),
                                        trailing: Text('Tracking Id: ${orderItems[index].trackingId}'),

                                      )),

                            ),


                        ],
                      ),
                  ])
                )));
              },


            );
          }
        },

      ),
    );

  }
}