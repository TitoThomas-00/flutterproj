import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compain_app_web/models/user_model.dart';
import 'package:compain_app_web/pages/inventory_page.dart';
import 'package:compain_app_web/pages/market_page.dart';
import 'package:compain_app_web/providers/auth_methods.dart';
import 'package:compain_app_web/providers/firebase_functions.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = "";
  String? role = "";
  String? name = "";

  // getting uid, email of current user
  void inputData() {
    final User? user = auth.currentUser;
    uid = user?.email;
  }

  // getting role of user
  void getUserData() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    firebaseFirestore.collection('users').doc(uid).get().then((value) {
      if (mounted)
        setState(() {
          role = value.data()!['role'];
          name = value.data()!['fullName'];
        });
    });
  }

  @override
  void initState() {
    inputData();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return role == ""
        ? loadingWidget()
        : role == "Inventory"
            ? InventoryPage()
            : role == "Marketing"
                ? MarketPage()
                : HomeWidget();
  }

  Widget loadingWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: Colors.blue.shade900,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Loading...",
                style: TextStyle(color: Colors.blue.shade900),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget HomeWidget() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        elevation: 0.0,
        title: const Text(
          'Admin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => {
                      AuthMethods().signOut(context),
                    },
                style: ElevatedButton.styleFrom(
                    elevation: 0.0, primary: Colors.blue.shade900),
                child: Text(
                  "logout",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 400),
                child: Text(
                  "Welcome ${name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
              SizedBox(height: 100),
              DelayedDisplay(
                delay: Duration(milliseconds: 600),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: ElevatedButton(
                            onPressed: () => {
                                  Navigator.pushReplacementNamed(
                                      context, '/createacc'),
                                },
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0, primary: Colors.blue.shade900),
                            child: Text(
                              "Create Accounts",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )),
                        height: 50,
                        width: MediaQuery.of(context).size.width / 4,
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 4,
                        child: ElevatedButton(
                          onPressed: () => {
                            Navigator.pushReplacementNamed(
                                context, '/requests'),
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0.0, primary: Colors.blue.shade900),
                          child: Text(
                            "Requests",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 800),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: ElevatedButton(
                            onPressed: () => {
                                  Navigator.pushReplacementNamed(
                                      context, '/inventory'),
                                },
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0, primary: Colors.blue.shade900),
                            child: Text(
                              "Inventory",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )),
                        height: 50,
                        width: MediaQuery.of(context).size.width / 4,
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 4,
                        child: ElevatedButton(
                            onPressed: () => {
                                  Navigator.pushReplacementNamed(
                                      context, '/marketing'),
                                },
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0, primary: Colors.blue.shade900),
                            child: Text(
                              "Marketing",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          child: ElevatedButton(
                              onPressed: () => {
                                    Navigator.pushReplacementNamed(
                                        context, '/sortit'),
                                  },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  primary: Colors.blue.shade900),
                              child: Text(
                                "Sorted by Kiosk ID",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                          height: 50,
                          width: MediaQuery.of(context).size.width / 4,
                        ),
                      ]),
                ),
              ),
            ])),
      ),
    );
  }
}
