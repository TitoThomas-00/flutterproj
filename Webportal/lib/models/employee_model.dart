import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  String? uid;
  String? email;
  String? fullName;
  String? password;
  String? role;
  Timestamp? accountCreated;

  EmployeeModel({
    this.uid,
    this.email,
    this.fullName,
    this.password,
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
      'role': role,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      password: map['password'] as String,
      accountCreated: Timestamp.fromDate(map['accountCreated']),
      role: map['role'] as String,
    );
  }

  factory EmployeeModel.fromDocument(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    String? fullName;
    String? email;
    String? password;
    Timestamp? accountCreated;
    String? role;

    try {
      var dat = doc.data();
      fullName = dat!["fullName"];
      email = dat["email"];
      accountCreated = dat["accountCreated"];
      password = dat["password"];
      role = dat["role"];
    } catch (e) {
      log("error in UserModel $e");
    }

    return EmployeeModel(
      uid: doc.id,
      email: email,
      accountCreated: accountCreated,
      password: password,
      fullName: fullName,
      role: role,
    );
  }
}
