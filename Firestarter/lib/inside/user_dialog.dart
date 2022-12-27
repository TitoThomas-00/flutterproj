import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../inside/partyinfo.dart';
class AddUserDialog extends StatefulWidget {

  final Function(PartyInfo) addUser;

  AddUserDialog(this.addUser);

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {



  @override
  Widget build(BuildContext context) {

    var titleController = TextEditingController();
    var locationController = TextEditingController();
    var descriptionController = TextEditingController();
     var addressController = TextEditingController();

    List<String> options = <String>[
      'Public',
      'Private',
    ];
    String dropdownValue = 'Public';




    Future addPartyDetails(String title, String? type, String location,
        String description, String address) async {
      await FirebaseFirestore.instance.collection('locations').add({
        'party name': title,
        'party type': type,
        'location': location,
        'description': description,
        'address' : address,

      });
    }

    Future partyAdded() async {
      addPartyDetails(
        titleController.text.trim(),
        dropdownValue,
        locationController.text.trim(),
        descriptionController.text.trim(),
        addressController.text.trim(),

      );
    }


    return Container(
      padding: EdgeInsets.all(8),
      height: 600,
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Create an Event", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.black,
            ),
            ),
            SizedBox(height:10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black45,
                  ),
                ),
              ),
              controller: titleController,
            ),
            SizedBox(height:5),
            Row(
              children: <Widget>[
                const Text(" Type of Party :"),
                SizedBox(width:20),
                DropdownButton<String>(
                  onChanged: (String? val) {
                    setState(() {
                      dropdownValue = val!;
                    });
                  },
                  value: dropdownValue,
                  items: options.map<DropdownMenuItem<String>>(
                          (String value) {
                      return DropdownMenuItem<String>(
                        child: Text(value),
                        value: value,
                      );
                    },
                  ).toList(),
                ),
              ],

            ),
            SizedBox(height:10),

            TextField(
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black45,
                  ),
                ),
              ),
              controller: locationController,
            ),

            SizedBox(height:5),
            TextField(
              maxLength: 500,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                hintMaxLines: 500,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black45,
                  ),
                ),
              ),
              controller: descriptionController,
            ),
            ElevatedButton(
              onPressed: () {
                partyAdded();
                final party = PartyInfo(titleController.text, dropdownValue,locationController.text,
                    descriptionController.text);
                widget.addUser(party);
                Navigator.of(context).pop();
              },
              child: Text('Add Party'),
            ),
          ],
        ),
      ),
    );
  }
}

/*
class AddUserDialog extends StatefulWidget {

 final Function(PartyInfo) addParty;

 AddUserDialog(this.addParty);


  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
 /*
  Future addPartyDetails(String title, String? type, String location,
      String description ) async {
    await FirebaseFirestore.instance.collection('locations').add({
      'party name': title,
      'party type' : type,
      'location': location,
      'description': description,

    });
  }

  */
  Widget build(BuildContext context) {

    var titleController = TextEditingController();
    var locationController = TextEditingController();
    var descriptionController = TextEditingController();


    final options = ["Public", "Private"];
    String? dropdownValue = "Public";

    bool checkBoxValue = false;
   /*
    Future partyAdded() async {
      addPartyDetails(
        titleController.text.trim(),
        dropdownValue,
        locationController.text.trim(),
        descriptionController.text.trim(),


      );
    }

    */

    return Container(
      padding: EdgeInsets.all(8),
      height: 600,
      width: 500,
      child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Create an Event", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.black,
            ),
            ),
            SizedBox(height:10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black45,
                  ),
                ),
              ),
              controller: titleController,
            ),
            SizedBox(height:5),
            Row(
              children: <Widget>[
              const Text(" Type of Party :"),
              SizedBox(width:20),
              DropdownButton(
                value: dropdownValue,
                items: options.map(
                        (e) => DropdownMenuItem(child: Text(e), value: e,)
                ).toList(),
                onChanged: (val) {
                  setState(() {
                    dropdownValue = val as String;
                  });
                },

              ),
              ],

            ),
              SizedBox(height:10),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black45,
                    ),
                  ),
                ),
                controller: locationController,
              ),

              SizedBox(height:5),
              TextField(
                maxLength: 500,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintMaxLines: 500,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black45,
                    ),
                  ),
                ),
                controller: descriptionController,
              ),
              ElevatedButton(
                      onPressed:() => {
                        final party = PartyInfo()
                        //partyAdded(),


                        widget.addParty(user);
                        Navigator.of(context).pop();
                     },
                 child: Text('Add Party'),
            ),

          ],

        ),
      ),


    );
  }
}


*/

