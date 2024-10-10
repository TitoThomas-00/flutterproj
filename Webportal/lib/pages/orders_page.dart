// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compain_app_web/models/orders_model.dart';
import 'package:compain_app_web/widget/flutter_text_field_fab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:draggable_fab/draggable_fab.dart';


import '../providers/firebase_functions.dart';
import '../providers/orders_provider.dart';
import 'order_item.dart';

class OrdersPage extends StatefulWidget {
  @override
  OrdersPageState createState() => OrdersPageState();
}
class OrdersPageState extends State<OrdersPage> {
  // const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    String searchTxt= '';
    return ChangeNotifierProvider(
      create: (context) => OrdersProvider(),
      child: Consumer(builder: (context, OrdersProvider ordersProvider, child) {
        return DefaultTabController(
          initialIndex: 1,
          length: 3,
          child: Scaffold(
            floatingActionButton: DraggableFab(
              child: TextFieldFloatingActionButton(
                label: 'Search Order...',
                icon: Icons.search,
                onChange: (String query) {
                  setState(() {
                    searchTxt = query;
                    log(searchTxt);
                  });

                },
                onSubmit: (String ) {  },
                onClear: (){},
                backgroundColor: Colors.blue,
                iconColor: Colors.black,

             ),
            ),
            appBar: AppBar(
              leading:  TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/home'), //change
                child:
                const Text("Home", style: TextStyle(color: Colors.white)),
              ),
              title: const Text('Orders'),
              centerTitle: true,
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'Approved',
                  ),
                  Tab(
                    text: 'Pending',
                  ),
                  Tab(
                    text: 'Declined',
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/inventory'), //change
                  child:
                  const Text("Inventory", style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/marketing'), //change
                  child:
                      const Text("Marketing", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
            body: StreamBuilder<List<OrderModel>>(
              stream: ordersProvider.ordersStream,
              builder: (context, snapshot) {
                log(snapshot.toString());
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        Text("data is being loaded")
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final orders = snapshot.data;

                final pendingOrders = orders
                    ?.where((order) => order.status == 'pending').toList();


                //********SEARCH*************************
                // List<OrderModel>? _getFilteredList(){
                //   if(searchTxt == null|| searchTxt.isEmpty)
                //     {
                //       log('if');
                //       return pendingOrders;
                //     }
                //   else{
                //     log('else');
                //     return pendingOrders
                //         ?.where((order) => order.email.toString().toLowerCase().contains(searchTxt.toLowerCase())==true)
                //         .toList();
                //   }
                // }



                final approvedOrders = orders
                    ?.where((order) => order.status == 'Approved')
                    .toList();
                final declinedOrders = orders
                    ?.where((order) => order.status == 'Declined')
                    .toList();

                return TabBarView(
                  children: [
                    ListView.builder(
                      itemCount: approvedOrders?.length,
                      itemBuilder: (context, index) {
                        final order = approvedOrders![index];
                        return OrderItem(order: order);
                      },
                    ),
                    ListView.builder(
                      itemCount: pendingOrders?.length,
                      itemBuilder: (context, index) {
                          var order = pendingOrders![index];
                          return OrderItem(order: order);

                      },
                    ),
                    ListView.builder(
                      itemCount: declinedOrders?.length,
                      itemBuilder: (context, index) {
                        final order = declinedOrders![index];
                        return OrderItem(order: order);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}




