import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:geocoding/geocoding.dart';
import '../inside/home.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//Edit Version
class UserEvents extends StatefulWidget{
  const UserEvents({Key? key}) : super (key : key);

  @override
  _UserEventsState createState() => _UserEventsState();
}



class _UserEventsState extends State<UserEvents> {
  late DocumentReference _documentReference = FirebaseFirestore.instance.collection('user').doc(user.uid);
  late CollectionReference _referenceMarkers= _documentReference.collection('markers');


  late CollectionReference _markersAdd = FirebaseFirestore.instance.collection('MarkersAdded');


  CollectionReference _locations = FirebaseFirestore.instance.collection(
      'locations');


  final user = FirebaseAuth.instance.currentUser!;
  List<String> images = [
    'assets/markers/PinkSize.png',
    'assets/markers/RedSize.png',
    'assets/markers/DarkRedSize.png',
    'assets/markers/BlueSize.png',
  ];

  final TextEditingController _partyTitleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _partyDescController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();


  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _partyTitleController.text = documentSnapshot['party title'];
      _locationController.text = documentSnapshot['location'];
      _partyDescController.text = documentSnapshot['description'];
      _addressController.text = documentSnapshot['address'];
    }
    await showModalBottomSheet(
        backgroundColor: Colors.grey,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery
                    .of(ctx)
                    .viewInsets
                    .bottom + 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: crossAxisAlignment.start,
              children: [
                TextField(
                  controller: _partyTitleController,
                  decoration: const InputDecoration(labelText: 'Party Title'),
                ),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: _partyDescController,
                  decoration: const InputDecoration(
                      labelText: 'Party Description'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: '1000 Hempstead Tpke, Hempstead, NY 11549',
                  ),

                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String partyTitle = _partyTitleController.text;
                    final String location = _locationController.text;
                    final String descr = _partyDescController.text;
                    final String address = _addressController.text;

                    List<Location> locations = await locationFromAddress(address);
                    double stlongitude = locations.last.longitude;
                    double stlatitude = locations.last.latitude;

                    if (partyTitle != null) {
                      await _referenceMarkers
                          .doc(documentSnapshot!.id)
                          .update({
                        'uid': user.uid,
                        'party title' : _partyTitleController.text,
                        'location' : _locationController.text,
                        'description' : _partyDescController.text,
                        'address' : _addressController.text,
                        'lat': stlatitude,
                        'long': stlongitude,
                        'value' : 0,

                      });
                      _partyTitleController.text = '';
                      _locationController.text = '';
                      _partyDescController.text = '';
                      _addressController.text='';
                      Navigator.of(context).pop();

                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _partyTitleController.text = documentSnapshot['party title'];
      _locationController.text = documentSnapshot['location'];
      _partyDescController.text = documentSnapshot['description'];
      _addressController.text = documentSnapshot['address'];
    }
    await showModalBottomSheet(
        backgroundColor: Colors.grey,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery
                    .of(ctx)
                    .viewInsets
                    .bottom + 20),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: crossAxisAlignment.start,
              children: [
                const SizedBox(
                  height:50,
                ),

                TextField(
                  cursorColor: Colors.white,
                  controller: _partyTitleController,
                  decoration: const InputDecoration(
                      labelText: 'Party Title',
                      fillColor: Colors.white,),
                ),
                const SizedBox(
                  height:20,
                ),

                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(
                  height:20,
                ),
                TextField(
                  controller: _partyDescController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Party Description',
                      contentPadding: EdgeInsets.all(8),
                  ),
                  style: TextStyle(fontSize: 15),
                  maxLines: 5,
                  minLines: 1,
                ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                  labelText: 'Address',
                hintText: '1000 Hempstead Tpke, Hempstead, NY 11549',

              ),
            ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),

                    onPressed: () async {

                      final String partyTitle = _partyTitleController.text;
                      final String location = _locationController.text;
                      final String descr = _partyDescController.text;
                      final String address = _addressController.text;
                      //convertAddresstoGeo(address);
                      List<Location> locations = await locationFromAddress(address);
                      double stlongitude = locations.last.longitude;
                      double stlatitude = locations.last.latitude;



                      if (address != null) {

                        Map<String,dynamic> partiesToAdd = {
                          'uid': user.uid,
                          'party title' : _partyTitleController.text,
                           'location' : _locationController.text,
                           'description' : _partyDescController.text,
                          'address' : _addressController.text,
                          'lat': stlatitude,
                          'long': stlongitude,
                          'value' : 0,

                      };
                        _referenceMarkers.add(partiesToAdd);
                       _markersAdd.add(partiesToAdd);

                       /*
                        await _locations
                            .add({
                          'Party Name': partyTitle,
                          'location': location,
                          'Description': descr,
                          'Address': address,
                          'lat': stlatitude,
                          'long': stlongitude,
                          'value' : 1,

                        });
                        */
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('You have successfully created a party')));


                        /*
                        _markers.add(
                            Marker(markerId: MarkerId(partyTitle),
                                   position:LatLng(stlatitude,stlongitude),
                                     infoWindow: InfoWindow(
                                       title:partyTitle,
                                     ),
                            )
                        );

                         */

                        setState(() {





                        });


                       // _documentReference.add(partiesToAdd);

                        _partyTitleController.text = '';
                        _locationController.text = '';
                        _partyDescController.text = '';
                        _addressController.text='';
                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          );
        });
  }



  Future<void> _delete(String locId) async {
    await _referenceMarkers.doc(locId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a party')));
  }
  /*
  Future<void> _showMyDialog() async {
    return showDialog <void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(documents),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('you want to delete this party?')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Confirm'),
                onPressed: () => _delete(documentSnapshot.id)

            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

   */

  var borderRadius = const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add,
        color: Colors.red
        ),
        backgroundColor: Colors.white,
        hoverColor: Colors.white,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create a Party",
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              onPressed: () => { FirebaseAuth.instance.signOut()},
              icon: Icon(Icons.logout)),
        ],

      ),

      backgroundColor: Colors.black,

      body: StreamBuilder( //constant connection with firestore
          stream: _referenceMarkers.snapshots(),
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
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _update(documentSnapshot)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _delete(documentSnapshot.id),
                                //_showMyDialog(documentSnapshot.id);


                            )
                          ],
                        ),
                      ),


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
    );
  }
}


/*
class UserEvents extends StatefulWidget{
  const UserEvents({Key? key}) : super (key: key);

  @override
  _UserEventsState createState() => _UserEventsState();
}

class _UserEventsState extends State<UserEvents> {

  List<PartyInfo> userList =[];
  List<String> partyList = [];


  //get Locations
  Future getLocation() async{
    await FirebaseFirestore.instance.collection('locations').get().then(
          (snapshot) => snapshot.docs.forEach((element) {
        print(element.reference);
        partyList.add(element.reference.id );
      }),
    );
  }

  void addPartyData(PartyInfo user){
    setState(() {
      userList.add(user);
    });
  }

  void showUserDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: AddUserDialog(addPartyData),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text( "Create a Party",
        ),
        backgroundColor: Colors.red,
        actions:[
          IconButton(
              onPressed: () =>{ FirebaseAuth.instance.signOut()},
              icon: Icon(Icons.logout)),
        ],
      ),
      body:Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
                onPressed: showUserDialog,
                elevation: 0,
              child: Container(
                 height: 70,
                 width: 70,
                decoration: BoxDecoration(
                   color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [
                   BoxShadow(
                       color: Colors.redAccent.withOpacity(0.1),
                       spreadRadius: 3,
                       blurRadius: 3,
                       offset: Offset(0, 3),
                     ),
                  ],
                ),
              child: Icon(Icons.add),
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.red,
          ),
         Expanded(
    //height: 400, //MediaQuery.of(context).size.height*0.75,
            child:  FutureBuilder(
             future: getLocation(),
             builder: (context,snapshot){
             return ListView.builder(
               itemCount: partyList.length,
               itemBuilder: (context, index) {
               return ListTile(
                title: GetPartyInfo(documentId: partyList[index]),
                );
            },
          );
           },
            ),
          ),
        ],
        ),
      ),
     );
    }
  }




*/ //Current
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: showUserDialog,
        elevation: 0,
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 3),
               ),
             ],
           ),
            child: Icon(Icons.add),
            ),
              backgroundColor: Colors.black,
              foregroundColor: Colors.red,
           ),
      backgroundColor: Colors.red[200],
      Expanded(
        //height: 400, //MediaQuery.of(context).size.height*0.75,
        child:  FutureBuilder(
          future: getLocation(),
          builder: (context,snapshot){
             child: ListView.builder(
               itemCount: partyList.length,
               itemBuilder: (context, index) {
                 return ListTile(
                   title: Text(
                     partyList[index].title,
                     style: TextStyle(
                       fontSize: 22,
                       color: Colors.red[400],
                       fontWeight: FontWeight.w400,
                     ),
                   ),
                   subtitle: Text(
                     partyList[index].location,
                     style: TextStyle(
                       fontSize: 18,
                       color: Colors.black,
                       fontWeight: FontWeight.w400,

                     ),
                   ),
                   trailing: Text(
                     partyList[index].description,
                     style: TextStyle(
                       fontSize: 18,
                       color: Colors.black,
                       fontWeight: FontWeight.w400,
                     ),
                     ),
                   );
               },
            );
          },
         ),
      ),


    );
  }
}
*/ //Pervious