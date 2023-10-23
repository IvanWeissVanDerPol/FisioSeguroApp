import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisio_seguro_app/models/clinitian_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColections {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get patientsCollection => firestore.collection('Users').doc('Patients').collection('PatientsCollection');
  CollectionReference get physiciansCollection => firestore.collection('Users').doc('Physicians').collection('PhysiciansCollection');
}

class UserRepository extends GetxController {
  static UserRepository get to => Get.find();
  final _db = FirebaseFirestore.instance;
  createusers(ClinicianModel user) async {
    await _db
        .collection("users")
        .add(user.toJson())
        .whenComplete(() => Get.snackbar(
              "Success",
              "User Created",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green,
            ))
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      if (kDebugMode) {
        print("Error ${error.toString()}");
      }
      // Rethrow the error to propagate it further
      throw error;
    });
  }
}
