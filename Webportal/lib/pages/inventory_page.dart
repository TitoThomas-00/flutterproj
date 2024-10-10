import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compain_app_web/pages/inventory_item.dart';
import 'package:compain_app_web/pages/list_of_items.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/orders_model.dart';
import '../providers/auth_methods.dart';
import '../providers/orders_provider.dart';
import '../widget/flutter_text_field_fab.dart';
import 'order_item.dart';
import 'orders_page.dart';

class InventoryPage extends StatefulWidget {
  @override
  InventoryPageState createState() => InventoryPageState();
}

class InventoryPageState extends State<InventoryPage> {
  // const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    String searchTxt = '';
    return ChangeNotifierProvider(
      create: (context) => OrdersProvider(),
      child: Consumer(builder: (context, OrdersProvider ordersProvider, child) {
        return DefaultTabController(
          initialIndex: 1,
          length: 2,
          child: Scaffold(
            floatingActionButton: DraggableFab(
              child: TextFieldFloatingActionButton(
                label: 'Search Order...',
                icon: Icons.search,
                onChange: (String query) {
                  setState(() {
                    searchTxt = query;
                  });
                },
                onSubmit: (String) {},
                onClear: () {},
                backgroundColor: Colors.red,
                iconColor: Colors.black,
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.purple[900],
              title: const Text('Inventory'),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.check),
                    text: 'Completed',
                  ),
                  Tab(
                    text: 'Queue',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  child:
                      const Text("Home", style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => {
                    AuthMethods().signOut(context),
                    Navigator.pushReplacementNamed(context, '/login'),

                  },
                  child: const Text("Logout",
                      style: TextStyle(color: Colors.white)),
                )
              ],
            ),
            body: StreamBuilder<List<OrderModel>>(
              stream: ordersProvider.ordersStream,
              builder: (context, snapshot) {
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

                final completeOrders = orders
                    ?.where((order) => order.tracking?.isNotEmpty == true)
                    .toList();

                final queueOrders = orders
                    ?.where((order) => order.status == 'Approved')
                    .toList();

                return TabBarView(
                  children: [
                    ListView.builder(
                      itemCount: completeOrders?.length,
                      itemBuilder: (context, index) {
                        var order = completeOrders![index];
                        return InventoryItem(order: order, index: index, route: 'complete',);
                      },
                    ),
                    ListView.builder(
                      itemCount: queueOrders?.length,
                      itemBuilder: (context, index) {
                        final order = queueOrders![index];


                        return InventoryItem(order: order, index: index, route: 'queue',);
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
