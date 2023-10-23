import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisio_seguro_app/screens/Physiotherapist/PatientAdministration/patient_list_screen.dart';
import 'package:fisio_seguro_app/screens/auth/login_screen.dart';
import 'package:fisio_seguro_app/screens/home/home_patient_screen.dart';
import 'package:fisio_seguro_app/screens/home/home_physiotherapist_screen.dart';
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
              // if user is a physiotherapist show home screen for physiotherapists else show home screen for patients
              if (snapshot.data!.uid == '1') {
                return const HomePhysiotherapistsScreen();
              } else if (snapshot.data!.uid == '2') {
                return const HomePatientScreen();
              } else {
                return const LoginScreen();
              }
            } else {
                return const LoginScreen();
              }
          }),
    );
  }
}
