import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/user.dart';


class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
   required this.showLoginPage,

}) : super(key:key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage> {
  //create user obj
  //final user = FirebaseAuth.instance.currentUser!;



  //text controller
  final _displaynameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    _displaynameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    //authenicate user
    if(passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),

      );
      //add user details
      addUserDetails(
          _displaynameController.text.trim(),
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
           int.parse(_ageController.text.trim()),
       );
      UserData(_displaynameController.text, _firstNameController.text, _lastNameController.text, _emailController.text, int.parse(_ageController.text));
     // userSetup(_displaynameController.text.trim());


    }
  }

  Future addUserDetails(String displayName, String firstName, String lastName, String email, int age) async {
    await FirebaseFirestore.instance.collection('users').add({
      'display name' : displayName,
      'first name': firstName,
      'last name' : lastName,
      'age': age,
      'email': email,
    });
  }


  bool passwordConfirmed() {

    if(_passwordController.text.trim()==_confirmpasswordController.text.trim()){
      return true;
    }
    else{
      return false;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              //Hello Again
              Text('Hey There, Ugly',
              style: GoogleFonts.bebasNeue(
                fontSize: 52,
              ),
            ),

            SizedBox(height: 10),
            Text(
              'Register below ',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 50),
                //firstname
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color:Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'First Name',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:10),
                //lastname
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color:Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Last Name',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color:Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Age',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:10),

                //Displayname
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color:Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _displaynameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Display Name',
                        ),
                      ),
                    ),
                  ),
                ),
            SizedBox(height:10),
            //email textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color:Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    ),

                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            //Password textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color:Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                  ),
                ),
              ),
            ),
                SizedBox(height:10),
                // confirm password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color:Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _confirmpasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Confirm Password',
                        ),
                      ),
                    ),
                  ),
                ),



              SizedBox(height:25),
            //Sign Up
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child : GestureDetector(
                onTap: signUp,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(color:Colors.black),
                    ),
                  ),
                ),
              ),
            ),


            SizedBox(height:10),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                'I am a member ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  )
               ),

            GestureDetector(
              onTap: widget.showLoginPage ,
              child: Text(
                'Login in!',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                 ),
                 ),
                ),
              ],


             ),
            ],
          ),


         ),
       ),
     ),
    );

  }

}