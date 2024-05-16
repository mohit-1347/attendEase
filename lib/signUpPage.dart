import 'package:attendease/main.dart';
import 'package:attendease/uiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:attendease/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController prnController = TextEditingController();
//
//   register(String email, String password, String name, String prn) async {
//     if (email == "" || password == "" || name == "" || prn == "") {
//       UiHelper.CustomAlertBox(context, "Enter required credentials!");
//     } else {
//       try {
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//
//         User? user = FirebaseAuth.instance.currentUser;
//         if (user != null) {
//           await user.updateDisplayName(name);
//         }
//
//         await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
//           'email': email,
//           'name': name,
//           'prn': prn,
//         });
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const MyHomePage()),
//         );
//       } on FirebaseAuthException catch (ex) {
//         return UiHelper.CustomAlertBox(context, ex.code.toString());
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Register Page",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         toolbarHeight: 40,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset("assets/images/attendEaseLogo1.png", fit: BoxFit.cover,),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     UiHelper.CustomTextField(nameController, "Name", Icons.person, false),
//                     const SizedBox(height: 15),
//                     UiHelper.CustomTextField(prnController, "PRN", Icons.person_pin, false),
//                     const SizedBox(height: 15),
//                     UiHelper.CustomTextField(emailController, "Email", Icons.mail, false),
//                     const SizedBox(height: 15),
//                     UiHelper.CustomTextField(passwordController, "Password", Icons.password, true),
//                     const SizedBox(height: 30),
//                     UiHelper.CustomButton(() {
//                       register(
//                         emailController.text.toString(),
//                         passwordController.text.toString(),
//                         nameController.text.toString(),
//                         prnController.text.toString(),
//                       );
//                     }, "Register"),
//                     const SizedBox(height: 10,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Already have an account?",
//                           style: TextStyle(
//                             fontSize: 15,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: (){
//                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
//                           },
//                           child: const Text(
//                             "Login",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController prnController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  bool isTeacher = false;

  register(String email, String password, String name, String prn) async {
    String role = isTeacher ? "teacher" : "student";
    if (email == "" || password == "" || name == "" || prn == "") {
      UiHelper.CustomAlertBox(context, "Enter required credentials!");
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updateDisplayName(name);
        }

        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
            {
              'email': email,
              'name': name,
              'prn': prn,
              'role': role,
            });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } on FirebaseAuthException catch (ex) {
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  Widget _buildStudentForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UiHelper.CustomTextField(nameController, "Name", Icons.person, false),
        const SizedBox(height: 15),
        UiHelper.CustomTextField(prnController, "PRN", Icons.person_pin, false),
        const SizedBox(height: 15),
        UiHelper.CustomTextField(emailController, "Email", Icons.mail, false),
        const SizedBox(height: 15),
        UiHelper.CustomTextField(
            passwordController, "Password", Icons.password, true),
        const SizedBox(height: 30),
        UiHelper.CustomButton(() {
          register(
            emailController.text.toString(),
            passwordController.text.toString(),
            nameController.text.toString(),
            prnController.text.toString(),
          );
        }, "Register"),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account?",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeacherForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UiHelper.CustomTextField(nameController, "Name", Icons.person, false),
        const SizedBox(height: 15),
        UiHelper.CustomTextField(prnController, "ID", Icons.person_pin, false),
        // Assuming ID refers to teacher ID
        const SizedBox(height: 15),
        UiHelper.CustomTextField(emailController, "Email", Icons.mail, false),
        const SizedBox(height: 15),
        UiHelper.CustomTextField(
            passwordController, "Password", Icons.password, true),
        const SizedBox(height: 30),
        UiHelper.CustomButton(() {
          register(
            emailController.text.toString(),
            passwordController.text.toString(),
            nameController.text.toString(),
            prnController.text.toString(),
          );
        }, "Register"),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account?",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register Page",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 40,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // Align content at the top
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Image.asset(
                      "assets/images/attendEaseLogo1.png", fit: BoxFit.cover,),
                    const SizedBox(height: 10),
                    ToggleButtons(
                      children: const [
                        Text('Student'),
                        Text('Teacher'),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          isTeacher = index == 1;
                        });
                      },
                      isSelected: [!isTeacher, isTeacher],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (!isTeacher)
                  _buildStudentForm()
                else
                  _buildTeacherForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
