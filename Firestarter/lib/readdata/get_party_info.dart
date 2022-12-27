import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../inside/home.dart';
class GetPartyInfo extends StatelessWidget{
      final String documentId;

      GetPartyInfo({required this.documentId});

      @override
      Widget build(BuildContext context){

        //get the collection
        CollectionReference parties = FirebaseFirestore.instance.collection('user');

        return FutureBuilder<DocumentSnapshot>(
          future: parties.doc(documentId).get(),
          builder: ((context, snapshot){
          if(snapshot.connectionState == ConnectionState.done)  {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String,dynamic>;
              return Text('location: ${data['location']}');
            }
          return Text('loading...');
        }),
        );
      }
    }