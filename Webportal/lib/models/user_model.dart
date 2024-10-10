import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? fullName;
  String? address;
  String? password;
  String? devices;
  String? role;
  Timestamp? accountCreated;

  UserModel({
    this.uid,
    this.email,
    this.fullName,
    this.password,
    this.address,
    this.devices,
    this.role,
    this.accountCreated,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'accountCreated': accountCreated,
      'password': password,
      'address': address,
      'role': role,
      'devices': devices,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      password: map['password'] as String,
      accountCreated: Timestamp.fromDate(map['accountCreated']),
      address: map['address'],
      devices: map['devices'] as String,
      role: map['role'] as String,
    );
  }

  factory UserModel.fromDocument(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    String? fullName;
    String? email;
    String? devices;
    String? password;
    Timestamp? accountCreated;
    String? address;
    String? role;

    try {
      var dat = doc.data();
      fullName = dat!["fullName"];
      email = dat["email"];
      devices = dat["devices"];

      accountCreated = dat["accountCreated"];
      password = dat["password"];
      role = dat["role"];
    } catch (e) {
      log("error in UserModel $e");
    }

    return UserModel(
      uid: doc.id,
      email: email,
      accountCreated: accountCreated,
      password: password,
      fullName: fullName,
      address: address,
      devices: devices,
      role: role,
    );
  }
}
