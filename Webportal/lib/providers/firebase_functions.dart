
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compain_app_web/models/employee_model.dart';
import 'package:compain_app_web/models/orders_model.dart';
import 'package:flutter/services.dart';

import '../models/request_model.dart';
import '../models/user_model.dart';

class FDF {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static String? userAddress;

  addUser(UserModel userModel) async {
    await firebaseFirestore
        .collection("users")
        .doc(userModel.uid)
        .set(userModel.toMap());
  }
  addEmployee(EmployeeModel employeeModel) async {
    await firebaseFirestore
          .collection("users")
          .doc(employeeModel.uid)
          .set(employeeModel.toMap());
  }

  Future<List<OrderModel>> getSortedData(String docId) async {
    var qn = await firebaseFirestore
        .collection('orders')
        .where('email', isEqualTo: docId)
        .orderBy('orderCreated', descending: true)
        .get()
        .then((list) => list.docs
              .map((doc) => OrderModel.fromMap(doc.data(),doc.id)).toList());
        return qn;
  }

  Stream<UserModel> getCurrentUser(user) {
    return firebaseFirestore
        .collection('users')
        .doc(user)
        .snapshots()
        .map((docSnapshot) => UserModel.fromDocument(doc: docSnapshot));
  }
  Stream<QuerySnapshot> getUsers() {
    return firebaseFirestore
        .collection('users')
        .snapshots();


}


  Stream<QuerySnapshot> getOrders(int filter) {
    return FirebaseFirestore.instance.collection('orders').snapshots();
  }

  requestForm(RequestModel requestModel, String user) async {
    await firebaseFirestore.collection("orders").add(requestModel.toMap());
  }

  respondRequest(String user, String docID, String status, String reason,
      String tracking) async {
    await firebaseFirestore
        .collection("orders")
        .doc(docID)
        .update({'status': status, 'reason': reason, 'tracking': tracking});
  }


  reasonResponse(String docId, String reason) async {
    var order = await firebaseFirestore.collection("orders").doc(docId).get();
    OrderModel orderModel = OrderModel.fromMap(order.data()!, order.id);
    String? reasonAdd = orderModel.reason;
    reasonAdd = (reasonAdd!+reason+', ')!;
    await firebaseFirestore
        .collection("orders")
        .doc(docId)
        .set({'reason':reasonAdd},SetOptions(merge: true));
  }



  addOrder(String docId, Item item)
  async {
    var order = await firebaseFirestore.collection("orders").doc(docId).get();
    OrderModel orderModel = OrderModel.fromMap(order.data()!, order.id);
    List<Item>? listItems = orderModel.items_quantity;
    listItems?.add(item);
    await firebaseFirestore
        .collection("orders")
        .doc(docId)
        .set({'items_quantity': listItems?.map((e) => e.toMap())},
        SetOptions(merge: true));
  }


  deleteOrder(String orderId, int id, Item item)
  async {
    var order = await firebaseFirestore.collection("orders").doc(orderId).get();
    OrderModel orderModel = OrderModel.fromMap(order.data()!, order.id);
    List<Item>? listItems = orderModel.items_quantity;
    listItems?.removeAt(id);
    await firebaseFirestore
        .collection("orders")
        .doc(orderId)
        .set({'items_quantity': listItems?.map((e) => e.toMap())},
        SetOptions(merge: true));
  }



  Future<DocumentSnapshot<Map<String, dynamic>>> getOrder(
      String orderID) async {
    var ref = await firebaseFirestore.collection("orders").doc(orderID).get();
    return ref;
  }

  editOrder(String orderID, int id, Item item) async {

    var order = await firebaseFirestore.collection("orders").doc(orderID).get();
    OrderModel orderModel = OrderModel.fromMap(order.data()!, order.id);
    List<Item>? listItems = orderModel.items_quantity;
    listItems![id] = item;
    await firebaseFirestore
        .collection("orders")
        .doc(orderID)
        .set({'items_quantity': listItems.map((e) => e.toMap())},SetOptions(merge: true));
  }


  
  
  
  
  
  
  
  
}
