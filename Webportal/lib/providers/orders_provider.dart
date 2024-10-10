import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  Stream<List<OrderModel>>? _ordersStream;
  Stream<List<OrderModel>>? get ordersStream => _ordersStream;
  List<OrderModel> get orders => _orders;



  OrdersProvider() {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      _ordersStream = FirebaseFirestore.instance
          .collection('orders')
          .snapshots()
          .map((list) => list.docs
              .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
              .toList());
      _ordersStream?.listen((orders) {
        _orders = orders;
        notifyListeners();
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
