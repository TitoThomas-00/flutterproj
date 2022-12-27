import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PartyInfo{

  final String title;
  //final String? type;
   final String location;
   final String description;
   final String address;
  // final double lat;
  // final double long;
  // final int value;
 // List<Markers> _userMarkers = [];

  PartyInfo(this.title,this.location,this.description,this.address);



  /*
  PartyInfo.fromMap(Map<String,dynamic> data){
    title = data['Party Name'];
    location = data['location'];
    description = data['description'];
    address = data['address'];
    lat = data['lat'];
    long = data['long'];
    value = data['value'];
  }

   */
}
