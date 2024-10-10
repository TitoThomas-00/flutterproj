// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? address;
  List<Item>? items_quantity;
  String? status;
  String? tracking;
  String? statusDescription;
  String? reason;
  String? id;
  String? email;
  Timestamp? orderCreated;



  OrderModel({
    this.address,
    this.items_quantity,
    this.status,
    this.tracking,
    this.statusDescription,
    this.reason,
    this.id,
    this.email,
    this.orderCreated,

  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'items_quantity': items_quantity?.map((x) => x.toMap()).toList(),
      'status': status,
      'tracking': tracking,
      'statusDescription': statusDescription,
      'reason': reason,
      'id': id,
      'email': email,
      'orderCreated': orderCreated
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      address: map['address'] != null ? map['address'] as String : null,
      items_quantity: map['items_quantity'] != null
          ? List<Item>.from(
              (map['items_quantity'] as List<dynamic>).map<Item?>(
                (x) => Item.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      tracking: map['tracking'] != null ? map['tracking'] as String : null,
      statusDescription: map['statusDescription'] != null
          ? map['statusDescription'] as String
          : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      orderCreated: Timestamp.fromDate(map['orderCreated'].toDate()),
      id: id,
    );
  }

  OrderModel.fromSnapshot(DocumentSnapshot map){
     OrderModel(
        address: map['address'],
    items_quantity: map['items_quantity'],
    status: map['status'],
    tracking: map['tracking'],
    statusDescription: map['statusDescription'],
    reason: map['reason'],
    orderCreated: map['orderCreated'],
    email: map['email']);
  }


  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source, id) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>, id);

  @override
  String toString() {
    return 'OrderModel(address: $address, items_quantity: $items_quantity, status: $status, tracking: $tracking, statusDescription: $statusDescription, reason: $reason, id: $id,email:$email)';
  }
}

class Item {
  String? item;
  int? quantity;
  String? trackingId;
  Item({
    this.item,
    this.quantity,
    this.trackingId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item': item,
      'quantity': quantity,
      'trackingId': trackingId,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      item: map['item'] != null ? map['item'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      trackingId:
          map['trackingId'] != null ? map['trackingId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Item(item: $item, quantity: $quantity, trackingId: $trackingId)';
}
