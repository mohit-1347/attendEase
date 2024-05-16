import 'package:attendease/signUpPage.dart';
import 'package:attendease/uiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login(String email, String password) async{
    if((email=="" && password=="") || email=="" || password==""){
      UiHelper.CustomAlertBox(context, "Enter required credentials!");
    }
    else {
      UserCredential? usercredential;
      try {
        usercredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyHomePage()));
          return null;
        });
      }
      on FirebaseAuthException catch(ex){
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/attendEaseLogo1.png", fit: BoxFit.cover,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UiHelper.CustomTextField(emailController, "Email", Icons.mail, false),
                      const SizedBox(height: 15),
                      UiHelper.CustomTextField(passwordController, "Password", Icons.password, true),
                      const SizedBox(height: 30),
                      UiHelper.CustomButton(() {
                        login(emailController.text.toString(), passwordController.text.toString());
                      }, "Login"),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Create an account?",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignUpPage()));
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                          )
                        ],
                      )
                    ],
                  ),
                ],
              )
          ),
          ),
        ),
      );
  }
}
