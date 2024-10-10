import 'dart:developer';

import 'package:compain_app_web/models/employee_model.dart';
import 'package:compain_app_web/providers/auth_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/firebase_functions.dart';
import '../providers/orders_provider.dart';

const List<Widget> widRoles = <Widget>[
  Text('Admin'),
  Text('Inventory'),
  Text('Marketing')
];

const List<String> striRoles = <String>[
  'Admin',
  'Inventory',
  'Marketing',
];





class CreateAcc extends StatefulWidget {
  @override
  CreateAccState createState() => CreateAccState();
}

  class CreateAccState extends State<CreateAcc> {
    final List<bool> _selectedRoles = <bool>[true, false, false];
    bool vertical = false;
    String fullName = '';
    String password = '';
    String email = '';
    String role_call = striRoles[0];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar:AppBar(
          leading: TextButton(
          onPressed: () =>
          Navigator.pushReplacementNamed(context, '/home'),
      //change
      child:
      const Text("Home", style: TextStyle(color: Colors.white)),
      ),
      title: const Text('Create Account'),
      centerTitle: true
      ),
            body: Center(
              child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    decoration:
                    const InputDecoration(hintText: 'Full Name '),
                    onChanged: (value) => fullName = value,
                  ),
                  TextField(
                    decoration:
                    const InputDecoration(hintText: 'Email'),
                    onChanged: (value) => email = value,
                  ),
                  TextField(
                    decoration:
                    const InputDecoration(hintText: 'Password'),
                    onChanged: (value) => password = value,
                  ),
                 SizedBox(height: 10,),
                 Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children:[
                   Text('Roles: '),
                 ToggleButtons(
                    direction: vertical ? Axis.vertical : Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < _selectedRoles.length; i++) {
                          _selectedRoles[i] = i == index;
                          if(_selectedRoles[i] == true)
                            {
                              role_call = striRoles[i];
                              log(role_call);

                            }
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.blue[700],
                    selectedColor: Colors.white,
                    fillColor: Colors.blue[200],
                    color: Colors.blue[400],
                    constraints: const BoxConstraints(
                      minHeight: 50.0,
                      minWidth: 150,
                    ),
                    isSelected: _selectedRoles,
                    children: widRoles,
                   ),

                   ]),

                  SizedBox(height: 25,),

                  SizedBox(
                    height: 75,
                      width: 200,
                      child: TextButton(
                    style: TextButton.styleFrom(
                      side: BorderSide(width: 2.0,color: Colors.blue),

                    ),
                      onPressed: ()=>{
                      AuthMethods().signUpEmployeeAcc(
                          email: email,
                          password: password,
                          fullName: fullName,
                          roles: role_call,
                          context: context),
                      },
                      child: Text('Submit',style: TextStyle(fontSize: 36,color:Colors.blue)
                      )
                  ),
                  )])
      ),
            ),
      );
    }
  }