// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}




class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

Future resetPasswordFunc() async {
  try{
  await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailTextController.text.trim());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
          title: const Text("Sucess"),
          content: const Text("Pasword reset link sent? check your email "),
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]));
  } on FirebaseAuthException catch (e) {
    if (kDebugMode) {
      print(e);
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.message.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]));
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //decoration: AppDecorations.linearGradient,
          child: const SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                // reusableTextField("Enter Email Id", Icons.person_outline, false,
                //     _emailTextController),
                // const SizedBox(
                //   height: 20,
                // ),
                // firebaseUIButton(context, "Reset Password", resetPasswordFunc)
              ],
            ),
          ))),
    );
  }


}

