import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compain_app_web/pages/kioskdata_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../providers/firebase_functions.dart';

class SortPage extends StatefulWidget {
  @override
  SortPageState createState() => SortPageState();
}

class SortPageState extends State<SortPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: Text('Home',style: TextStyle(color: Colors.white),),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          }
        ),
        backgroundColor: Color(0xFF12264F),
        title: Text('Kiosk Email'),
      ),
      body: StreamBuilder(
        stream: FDF().getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  Text("loading...")
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data;
          return ListView.builder(
                itemCount: users?.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return TextButton(child: Text('${data.id}'), onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => kioskData(docID: data.id)));

                  },);
                },
              );



        },
      ),
    );


  }

}