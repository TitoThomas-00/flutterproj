import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class GetLeaderBoard extends StatelessWidget {
  final String documentId;

  GetLeaderBoard({required this.documentId});




  @override
  Widget build(BuildContext context){

    // get the collection
    CollectionReference leaderboard = FirebaseFirestore.instance.collection('MarkersAdded');

    return FutureBuilder<DocumentSnapshot>(
      future: leaderboard.doc(documentId).get(),
      builder: ((context,snapshot){
      if(snapshot.connectionState == ConnectionState.done){
        Map<String,dynamic> data =
            snapshot.data!.data() as Map<String,dynamic>;
        return Text(' ${data['party title']}') ;
      }
      return Text('loading..');
    }),
    );




  }





}