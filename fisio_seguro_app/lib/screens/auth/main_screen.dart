import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisio_seguro_app/screens/auth/login_screen.dart';
import 'package:fisio_seguro_app/screens/home/log_out_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
                return const LogOutScreen();
            } else {
                return const LoginScreen();
              }
          }),
    );
  }
}
