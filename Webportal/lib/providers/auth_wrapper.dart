import 'package:compain_app_web/pages/home_page.dart';
import 'package:compain_app_web/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import 'firebase_functions.dart';

enum AuthStatus { unknown, notLoggedIn, loggedIn }

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  AuthWrapperState createState() => AuthWrapperState();
}

class AuthWrapperState extends State<AuthWrapper> {
  AuthStatus _authStatus = AuthStatus.unknown;
  late String currentUid;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //get the state, check current User, set AuthStatus based on state
    User? authStream = context.watch<User?>();
    if (authStream != null) {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
        currentUid = authStream.email.toString();
      });
      print("Logged In");
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
      print("Not Logged In");

    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.unknown:
        return const LoginPage(); //replace with splash screen
      case AuthStatus.notLoggedIn:
        return const LoginPage(); //ui edits //LoginScreen()
      case AuthStatus.loggedIn:
        return MultiProvider(providers: [
          StreamProvider<UserModel>.value(
            value: FDF().getCurrentUser(currentUid),
            initialData: UserModel(),
          ),
        ], child: const HomePage());
      default:
        return Container();
    }
  }
}
