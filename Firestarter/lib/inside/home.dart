import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/home_page.dart';
import '../inside/event.dart';


class UserHome extends StatefulWidget {
   UserHome({Key? key}) : super(key: key) {
    DocumentReference _documentReference = FirebaseFirestore.instance.collection('MarkersAdded').doc(data['id']);
    //_referenceMarkers = _documentReference.collection('markers');

  }
   Map data = {};

   late DocumentReference _documentReference;
    //late CollectionReference _referenceMarkers;
  @override
  State<UserHome> createState() => _CurrentLocationScreenState();

}

 class _CurrentLocationScreenState extends State<UserHome> {

   //late GoogleMapController googleMapController;
   //final user = FirebaseAuth.instance.currentUser!;
   Completer<GoogleMapController> _controller = Completer();

  final Stream<QuerySnapshot> markersAdd = FirebaseFirestore.instance.collection('MarkersAdded').snapshots();


   Uint8List? markerImage;

   List<String> images = [
     'assets/markers/PinkSize.png',
     'assets/markers/RedSize.png',
     'assets/markers/DarkRedSize.png',
     'assets/markers/BlueSize.png',
   ];

/*
   final List<Marker> _markers = <Marker>[
     Marker(markerId: MarkerId('5'), position: LatLng(40.71, -73.62))
   ];
   final List<LatLng> _latLang = <LatLng>[
     LatLng(40.7167, -73.5994), LatLng(40.7167, -73.5)
   ];
*/




   List<String> markerIds = [];
    List<Marker> _markers = <Marker>[
     Marker(
   markerId: MarkerId('23'),
   position: LatLng(46.1,-72.34)
   ),

         ];
  List<LatLng> _latLng = [
    LatLng(40.72, -73.7994),
    LatLng(40.7167, -75.5994),
    LatLng(40.7167, -73.4)];

/*
   Future getMarkerId() async {
     await FirebaseFirestore.instance.collection('MarkersAdded').get().then(
         (snapshot) => snapshot.docs.forEach(
             (document){
               print(document.reference);
               markerIds.add(document.reference.id);
             },
         ),
     );
   }

 */


   static const CameraPosition initialCameraPosition = CameraPosition(
     target: LatLng(40.7167, -73.5994),
     zoom: 12,
   );

   //BitmapDescriptor markerIcon;

/*
  @override
  void initState(){
    super.initState();
    addCustomIcon();
  }


  void addCustomIcon() async {
     markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.2),
        'assets/markers/First.png');

  }

 */
   /*
   Future intermediate() async {
   StreamBuilder(
       stream: markersAdd,
         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasData){
        ListView.builder(
   itemCount: snapshot.data!.docs.length,
   itemBuilder: (BuildContext context, int index){
   var data = snapshot.data!.docs[index];

   return addMarkers(
   data['party title'],
   data['description'],
   data['location'],
   data['lat'],
   data['long']);

   }
   );
   return Text('completed');

   }  else {
   return CircularProgressIndicator();
   }
   }),
 }



    Widget addMarkers(String title,String desc, String loc, double lat,double long)
   {
     _markers.add(
       Marker(markerId: MarkerId(title),
           position: LatLng(lat,long),
           infoWindow: InfoWindow(
               title: title,
             snippet: desc
           )
       ),
     );
     setState(() {

     });
     return Text('completed');

   }


    */

   Future<Uint8List> getByteFromAssets(String path, int width) async {
     ByteData data = await rootBundle.load(path);
     ui.Codec codec = await ui.instantiateImageCodec(
         data.buffer.asUint8List(), targetHeight: width);
     ui.FrameInfo fi = await codec.getNextFrame();
     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer
         .asUint8List();
   }

   @override
   void initState() {
     super.initState();

     loadData();
   }

   //late DocumentReference _documentReference = FirebaseFirestore.instance.collection('locations').get();

   loadData() async {
     AsyncSnapshot<QuerySnapshot> streamSnapshot;

     for (int i = 0; i < _latLng.length; i++) {

       //final DocumentSnapshot documentSnapshot =
       //streamSnapshot.data!.docs[i];
       final Uint8List markerIcon = await getByteFromAssets(images[0], 200);
       _markers.add(
         Marker(markerId: MarkerId(i.toString()),
           position: _latLng[i],
           icon: BitmapDescriptor.fromBytes(markerIcon),
           infoWindow: InfoWindow(
               title: 'Charles Party ',

           ),
         ),
       );
       setState(() {

       });
     }
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.red,

       ),
       body: SafeArea(
         child:
           GoogleMap(
           initialCameraPosition: initialCameraPosition,
           mapType: MapType.normal,
           myLocationButtonEnabled: true,
           markers: Set<Marker>.of(_markers),
           onMapCreated: (GoogleMapController controller) {
             _controller.complete(controller);
           },
         ),
       ),
       /*
       child: StreamBuilder(
             stream: FirebaseFirestore.instance.collection('location').snapshots(),
             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
             if(snapshot.hasData){
               itemCount: snapshot.data.docs.length,
               itemBuilder: (context, index) => Container(
                child:  _markers.add(
                     Marker(markerId: MarkerId(Text(snapshot.data.docs[index]['party title'])),
                        position: LatLng(snapshot.data.docs[index]['lat'], snapshot.data.docs[index]['long']),
                        icon: BitmapDescriptor.fromBytes(markerIcon),
                     infoWindow: InfoWindow(
                     title: Text(snapshot.data.docs[index]['party title']+"\n"+Text(snapshot.data.docs[index]['description']))
                   ),
                 ),
              ),

             } else {
               return _markers;
             }

        */
       floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
       floatingActionButton: FloatingActionButton.extended(
         onPressed: () async {
           Position position = await _determinePosition();

          final GoogleMapController controller = await _controller.future;
           controller
               .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
               target: LatLng(position.latitude, position.longitude),
               zoom: 14)));
           _markers.add(
               Marker(
                   markerId: MarkerId('CurrentLocation'),
                   position: LatLng(position.latitude, position.longitude),
                   infoWindow: InfoWindow(
                       title: 'My current location'
                   )
               )
           );
           setState(() {

           });
         },
         label: const Text("Current Location"),
         icon: const Icon(Icons.location_history),
       ),



     );

   }
 }





  /*
    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          title: Text('Welcome: ' + user.email!,
          ),
          backgroundColor: Colors.red,
          actions:[
            IconButton(
                onPressed: () =>{ FirebaseAuth.instance.signOut()},
                icon: Icon(Icons.logout)),
          ],
        ),
      body: GoogleMap(
       initialCameraPosition: initialCameraPosition,
       markers: _markers,
       zoomControlsEnabled: false,
       mapType: MapType.normal,
       onMapCreated: (GoogleMapController controller) {
         //googleMapController = controller;
        _controller.complete(controller);
         },
       ),

      floatingActionButton: FloatingActionButton.extended(
      onPressed: () async {
      Position position = await _determinePosition();

      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));


      _markers.clear();
       /*
      markers.add(
          Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(position.latitude, position.longitude),
               draggable: true,
              onDragEnd: (value){
              },
            icon: markerIcon
          ));
        */
      setState(() {
        _markers.add(
          Marker(
              markerId: MarkerId('<Marker_ID>'),
              position: LatLng(position.latitude, position.longitude),
              icon: markerIcon
          )
        );
      });

      },
         label: const Text("Current Location"),
         icon: const Icon(Icons.location_history),
      ),
      );
    }

   */




  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }


















/*

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(40.730610, -73.935242),
    zoom: 11.5,
  ); //initial

  GoogleMapController? _googleMapController;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Location location = new Location();
 _serviceEnabled = await location.serviceEnabled();
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
  if(!_serviceEnabled){
    return;
    }
  }

_permissionGranted = await location.hasPermission();
if(_permissionGranted == PermissionStatus.denied){
  _permissionGranted = await location.requestPermission();
  if(_permissionGranted != PermissionStatus.granted){
    return;
   }
  }
 _locationData = await location.getLocation();
  @override
   void dispose() {
    _googleMapController?.dispose();
    super.dispose();
   }




  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        //mapType: MapType.hybrid,
        initialCameraPosition: _initialCameraPosition,
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) => _googleMapController = controller,
           ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        //onPressed: () {getCurrentLocation();},
        onPressed: () => _googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            target: LatLng(pos['latitude'], pos['longitude']),
            zoom: 17.0,
          ),
          ),
            ),


      );








  }

}

 */
/*
_animateToUser() async{
  var pos = await location.getLocation();
  _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      target: LatLng(pos['latitude'],pos['longitude']),
      zoom: 17.0,
    ),
  ),
  )

}

_addMarker() {
  var marker = MarkerOptions(
      position: _googleMapController.cameraPosition.target,
      icon: BitmapDescriptor.defaultMarker,
      infoWindowText: InfoWindow('Tester')
  );
}

 */