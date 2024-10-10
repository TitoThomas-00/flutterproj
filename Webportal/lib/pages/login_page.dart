import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final usernameController =
        TextEditingController(text: "test09@maxsiptel.com");
    final passwordController = TextEditingController(text: "password");
    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            width: 400,
            height: 400,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    loginProvider.setUsername(usernameController.text);
                    loginProvider.setPassword(passwordController.text);
                    // ignore: use_build_context_synchronously
                    if (await loginProvider.login(context)) {
                      // ignore: use_build_context_synchronously
                    } else {
                      // Show error message
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class LoginForm extends StatelessWidget {
//   final _usernameController =
//       TextEditingController(text: "test09@maxsiptel.com");
//   final _passwordController = TextEditingController(text: "password");

//   LoginForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: Column(
//         children: [
//           TextFormField(
//             controller: _usernameController,
//             decoration: const InputDecoration(labelText: 'Username'),
//             validator: (value) {
//               if (value == null) {
//                 return 'Please enter your username';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             controller: _passwordController,
//             decoration: const InputDecoration(labelText: 'Password'),
//             obscureText: true,
//             validator: (value) {
//               if (value == null) {
//                 return 'Please enter your password';
//               }
//               return null;
//             },
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               loginViewModel.setUsername(_usernameController.text);
//               loginViewModel.setPassword(_passwordController.text);
//               if (await loginViewModel.login()) {
//                 // ignore: use_build_context_synchronously
//                 Navigator.of(context).pushReplacementNamed('/home');
//               } else {
//                 // Show error message
//               }
//             },
//             child: const Text('Login'),
//           ),
//         ],
//       ),
//     );
//   }
// }
