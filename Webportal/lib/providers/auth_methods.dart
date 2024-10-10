// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compain_app_web/models/employee_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/request_model.dart';
import '../models/user_model.dart';
import 'auth_wrapper.dart';
import 'firebase_functions.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  User get user => _auth.currentUser!;

  Stream<UserModel> get getCurrentUser {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.email)
        .snapshots()
        .map((docSnapshot) => UserModel.fromDocument(doc: docSnapshot));
  }

  Stream<RequestModel> get getCurrentRequest {
    return FirebaseFirestore.instance
        .collection('requests')
        .doc(_auth.currentUser!.email)
        .collection('orders')
        .doc()
        .snapshots()
        .map((docSnapshot) => RequestModel.fromDocument(doc: docSnapshot));
  }

  Future<void> submitForm({
    required String address,
    required String status,
    required Map<String, dynamic>? items_quantity,
    required String? statusDescription,
    required BuildContext context,
  }) async {
    try {
      RequestModel requestModel = RequestModel(
        uid: _auth.currentUser!.email,
        address: address,
        status: status,
        items_quantity: items_quantity,
        statusDescription: statusDescription,
        orderCreated: Timestamp.now(),
      );
      await FDF()
          .requestForm(requestModel, _auth.currentUser!.email.toString());
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> signUpEmployeeAcc({
     required String email,
     required String password,
     required String fullName,
     required String roles,
     required BuildContext context,
   }) async {
    try {

      print("email: ${email}");
      print("pass: ${password}");
      print("fullname: ${fullName}");
      print("roles: ${roles}");

      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      EmployeeModel employeeModel = EmployeeModel(
        uid: authResult.user!.email,
        email: authResult.user!.email,
        password: password.toString(),
        fullName: fullName.trim(),
        role: roles,
        accountCreated: Timestamp.now(),
      );
      await FDF().addEmployee(employeeModel);
      showSnackBar(context, 'Successfully Created Account');
      // await sendEmailVerification(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
              (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
      showSnackBar(context, e.message!); // Displaying the usual firebase error message
    }
  }



  //Email sign up
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String address,
    required String kioskid,
    required BuildContext context,
  }) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      UserModel userModel = UserModel(
        uid: authResult.user!.email,
        email: authResult.user!.email,
        password: password.toString(),
        fullName: fullName.trim(),
        address: address.trim(),
        accountCreated: Timestamp.now(),
        devices: kioskid,
      );
      await FDF().addUser(userModel);
      // await sendEmailVerification(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
      showSnackBar(
          context, e.message!); // Displaying the usual firebase error message
    }
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  /*
  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

   */

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();

      Navigator.pushReplacementNamed(context, '/login');


    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  resetPassword({required String email, required BuildContext context}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      showSnackBar(context, 'Reset password email has been sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
