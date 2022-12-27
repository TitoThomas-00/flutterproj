import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flame_on/auth/auth_page.dart';
import '../screens/home_page.dart';



class MainPage extends StatelessWidget {
  const MainPage({ Key? key}): super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context, snapshot){
          if(snapshot.hasData){
            return HomePage(); //checks if user in the system
              }
          else{
            return AuthPage();
            }
         }



        ),
    );
 }
}