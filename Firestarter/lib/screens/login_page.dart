import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/forgot_pw_page.dart';
class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key:key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:_emailController.text.trim(),
        password:_passwordController.text.trim(),
    );
  }
@override
void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child:SingleChildScrollView(
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(top:10,left:25,right:25),
                   child:Image.asset(
                    'assets/tpredflame.png',
                    height: 250,
                    width: 250,
                     fit: BoxFit.cover,
                   ),
                 ),

                //Hello Again
                Text('FireStarter',
                  style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                     ),
                    ),

            SizedBox(height: 10),
            Text(
              'Welcome back !!!',
              style: TextStyle(
                fontSize: 20,
              ),
             ),
          SizedBox(height: 50),

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
       Padding(
         padding: const EdgeInsets.symmetric(horizontal:25.0),
          child: Row(
                  mainAxisAlignment:MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return ForgotPasswordPage();

                        },
                            ),
                        );
                      },
                  child: Text('Forgot Password?',
                      style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                     ),
                     ),
                    ),
                ],
          ),
       ),
     SizedBox(height:25),
      //Sign in
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child : GestureDetector(
            onTap: signIn,

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
                   'Not a member? ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                    )
                 ),

            GestureDetector(
              onTap: widget.showRegisterPage ,
              child: Text(
                 'Register now',
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