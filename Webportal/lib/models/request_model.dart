   // ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  String? uid;
  Map<String, dynamic>? items_quantity; //[(item: item, quantity: quantity)]
  String? address;
  String? status;
  String? statusDescription;
  Timestamp? orderCreated;

  RequestModel({
    this.uid,
    this.items_quantity,
    this.address,
    this.status,
    this.statusDescription,
    this.orderCreated,
  });
//Map for Firebase
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'items_quantity': items_quantity,
      'location': address,
      'status': status,
      'statusDescription': statusDescription,
      'orderCreated': orderCreated,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      //quantity: map['quantity'] != null ? map['quantity'] as String : null,
      //items: map['quantity'] != null ? map['quantity'] as String : null,
      items_quantity: map['item_quantity'] != null
          ? map['items_quantity'] as Map<String, dynamic>
          : null,
      address: map['address'] != null ? map['address'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      statusDescription: map['statusDescription'] != null
          ? map['statusDescription'] as String
          : null,
      orderCreated: Timestamp.fromDate(map['orderCreated']),
    );
  }
//Used in Firebase Func
  factory RequestModel.fromDocument(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    Map<String, dynamic>? itemsQuantity;
    String? address;
    String? status;
    Timestamp? orderCreated;
    String? statusDescription;

    try {
      var dat = doc.data();
      //items = dat!["items"];
      // quantity = dat["quantity"];
      itemsQuantity = dat!["item_quantity"];
      address = dat["address"];
      status = dat["status"];
      orderCreated = dat["orderCreated"];
      statusDescription = dat["statusDescription"];
    } catch (e) {
      log("error in RequestModel $e");
    }
    return RequestModel(
      uid: doc.id,
      items_quantity: itemsQuantity,
      address: address,
      status: status,
      statusDescription: statusDescription,
      orderCreated: orderCreated,
    );
  }
}
