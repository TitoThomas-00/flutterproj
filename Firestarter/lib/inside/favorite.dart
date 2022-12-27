import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../readdata/GetLeaderBoard.dart';
class leaderboard extends StatelessWidget {
  leaderboard({Key? key}) : super(key: key) {

  }
  List<String> favIDs = [];

  //late DocumentReference _documentReference = FirebaseFirestore.instance.collection('user');
  //late CollectionReference _referenceMarkers= _documentReference.collection('markers');
  List<String> images = [
    'assets/markers/PinkSize.png',
    'assets/markers/RedSize.png',
    'assets/markers/DarkRedSize.png',
    'assets/markers/BlueSize.png',
  ];
  Future getFav() async {
    await FirebaseFirestore.instance.collection('MarkersAdded').get()
        .then((snapshot) => snapshot.docs.forEach((documents) {
       favIDs.add(documents.reference.id);
    }),
    );
  }

  late CollectionReference marks = FirebaseFirestore.instance.collection(
      'MarkersAdded');


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Leaderboard'),
      backgroundColor: Colors.red,
      ),

      body: StreamBuilder( //constant connection with firestore
          stream: FirebaseFirestore.instance.collection("MarkersAdded").orderBy('value',descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
            return Center(
             child: CircularProgressIndicator(),
             );
         }
             return ListView(
               children: snapshot.data!.docs.map((document) {
                 return Column(
                   children:[
                     SizedBox(
                       height: 5.0,
                       width: 5.0,
                     ),
                   ExpansionTile(
                     backgroundColor: Colors.white,

                     leading: Image.asset(images[document['value']]),
                     title: Text(document['party title'],textAlign: TextAlign.center,),
                     children: [
                       ListTile(
                         title: Text(document['party title']),
                         subtitle: Text(document['description']),
                         trailing: Text("@"+document['location']),
                       ),
                     ],
                     ),




                    ]
                    );
                   }).toList(),
                  );
                },

              ),
      backgroundColor: Colors.white,
            );
            }
          }


         /*
         body: Column(
           children: <Widget>[
             FutureBuilder(
               future: getFav(),
               builder: (context, snap){
             return ListView.builder(
                itemCount:favIDs.length ,
                itemBuilder:(context,index){
               return ListTile(
                  title: GetPartyInfo(documentId: favIDs[index]),
            );
         },
       );


          },
             ),
         ],
         ),

          */
     /*
       body:StreamBuilder( //constant connection with firestore
        stream: _documentReference.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length, // number of rows
            itemBuilder: (context, index) {
            final DocumentSnapshot documentSnapshot =
            streamSnapshot.data!.docs[index];
            return Card(
              margin: const EdgeInsets.all(10),
               child: ListTile(
                shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.red,width: 5),
                  ),
                leading: SizedBox(
                  height: 60,
                  width: 60,
                 child: Image.asset(images[documentSnapshot['value']]
                  ),
                  ),
                   title: Text(documentSnapshot['party title']),
                   subtitle: Text(documentSnapshot['location']),
              ),
            );
            },
            );
           }
          return const Center(
            child: CircularProgressIndicator(),
           );
        }
      ),

      */







