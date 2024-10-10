import 'package:compain_app_web/providers/auth_methods.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  late String _username, _password;
  String get username => _username;
  String get password => _password;

  
  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  Future<bool> login(context) async {
    AuthMethods()
        .loginWithEmail(email: _username, password: password, context: context);
    return Future.value(true);
  }
}
