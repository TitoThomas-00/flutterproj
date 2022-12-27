import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import '../auth/user.dart';
class UserProfile extends StatefulWidget {

  //final String documentId;

  UserProfile();

  @override
  State<UserProfile> createState() => _UserProfileState();
 // GetUserName(this.documentId);
}
class _UserProfileState extends State<UserProfile>   {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final user = FirebaseAuth.instance.currentUser!;

  String _name="";
  String _email = "";


final currentUser = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("Profile Page"
          ),
        backgroundColor: Colors.red,
        actions:[
            IconButton(
                onPressed: () =>{ FirebaseAuth.instance.signOut()},
                icon: Icon(Icons.logout)),
          ],
        ),
      body: Center(
       child: Column(
        children: [

        StreamBuilder(
            stream:
                    FirebaseFirestore.instance
                        .collection("users")
                        .where("email", isEqualTo: currentUser.currentUser!.email!)
                        .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data!.docs[index];
                      return Card(
                        child: Center(
                          heightFactor: 5,
                          child: Column(
                            children: <Widget>[
                              Text("Display Name:"+" "+ data['display name'],
                                  style: TextStyle(fontSize: 23.0)),
                              Text("First Name:"+" "+data['first name'],
                                  style: TextStyle(fontSize: 23.0)),
                              Text("Last Name:"+" "+data['last name'],
                                  style: TextStyle(fontSize: 23.0)),
                              Text("email:"+" "+data['email'],
                                  style: TextStyle(fontSize: 23.0)),
                            ],
                          ),
                        ),

                      );
                    });




              } else {
                return CircularProgressIndicator();
              }
            })

        ],
       ),


       ),



    );

  }

  }





