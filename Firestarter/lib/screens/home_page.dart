import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../inside/home.dart';
import '../inside/favorite.dart';
import '../inside/event.dart';
import '../inside/profile.dart';
import '../screens/register_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({ Key? key}) : super(key:key);

  @override
  State<HomePage> createState() => _HomePageState();

}




class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    UserHome(),
    leaderboard(),
    UserEvents(),
    UserProfile(),

  ];






  @override
  Widget build(BuildContext context){
    return Scaffold(

      //Replace with settings
      /*
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
      */

      ///////////////////
      body: Center(
        child: _pages.elementAt(_selectedIndex),
          ),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor:Colors.red[500],
        gap:8,
        padding: EdgeInsets.all(25),
        tabs: const[
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
              icon: Icons.favorite_border,
                  text: 'Favorites',
          ),
          GButton(
            icon: Icons.add_location,
            text: 'Events',
          ),
          GButton(
              icon: Icons.account_box,
                  text: 'Profile',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },




      ),






      ////////////////Sign_in/sign_out
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text('Signed In As: ' + user.email!),
      //      MaterialButton(
      //        onPressed: () {
      //          FirebaseAuth.instance.signOut();
      //        },
      //           color: Colors.red,
      //           child: Text('sign out'),
      //         ),
      //       ],
      //   ),
      // ),
    );

  }

}