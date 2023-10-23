import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userType;

  String? get token => _token;
  String? get userType => _userType;

  CollectionReference get physiotherapistCollection {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc('Physicians')
          .collection('PhysiciansCollection')
          .doc(user.uid)
          .collection('data');
    }
    throw FirebaseAuthException(
        message: 'No user logged in', code: 'NO_USER');
  }


  Future<void> login(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email, password: password);

    String uuid = userCredential.user!.uid;

    //Buscamos el tipo de usuario
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc('Physicians')
        .collection('PhysiciansCollection')
        .doc(uuid)
        .get();

    DocumentSnapshot snapshotPatient = await FirebaseFirestore.instance
        .collection('Users')
        .doc('Patients')
        .collection('PatientsCollection')
        .doc(uuid)
        .get();

    if (snapshot.exists) {
      _userType = 'Physician';
    } else if (snapshotPatient.exists) {
      _userType = 'Patient';
    } else {
      _userType = 'Unknown';
      }
    notifyListeners(); // Notify listeners that user has changed
  }

  void setUserType(String userType) {
    _userType = userType;
    notifyListeners(); // Notify listeners that user type has changed
  }

  Future<void> logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    notifyListeners(); // Notify listeners that user has changed
  }
}
