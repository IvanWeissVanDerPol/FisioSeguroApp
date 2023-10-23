// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisio_seguro_app/repository/user_repository/user_repository.dart';
import 'package:fisio_seguro_app/reusable_widgets/reusable_widget.dart';
import 'package:fisio_seguro_app/screens/auth/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
// import '../../models/PatientClass.dart';
// import '../../models/physicianClass.dart';

enum UserType { patient, physician }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final CollectionReference patientsCollection = AppColections().patientsCollection;
  final CollectionReference physiciansCollection = AppColections().physiciansCollection;

  UserType _selectedUserType = UserType.patient;
  // Common Information for both Patient and Physician
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Personal Information (Specific to Patient)
  // ignore: non_constant_identifier_names
  final TextEditingController _DOBController = TextEditingController(); // Date of Birth
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _knownAlergiesController = TextEditingController();

  // Professional Details (Specific to Physician)
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _yearsOfExperienceController = TextEditingController();
  final TextEditingController _hospitalAffiliationController = TextEditingController();

//dispose
  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _phoneController.dispose();
    _DOBController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _knownAlergiesController.dispose();
    _specializationController.dispose();
    _licenseNumberController.dispose();
    _yearsOfExperienceController.dispose();
    _hospitalAffiliationController.dispose();
    super.dispose();
  }

  bool passwordConfirmed() {
    return _passwordController.text.trim() == _passwordConfirmController.text.trim();
  }

  Future addPatientDetails() async {}

  Future<void> addUserDetails({
    required String userId,
    required GenericUser user,
}) async {
    try {
        CollectionReference targetCollection;
        Map<String, dynamic> formData = user.toMap();

        if (user is Patient) {
            targetCollection = patientsCollection;
        } else if (user is Physician) {
            targetCollection = physiciansCollection;
        } else {
            throw Exception('Invalid user type provided');
        }

        // Add/Update the user details in the respective collection
        await targetCollection.doc(userId).set(formData);
        if (kDebugMode) {
          print('User details added/updated successfully!');
          print(user.runtimeType);
          print(userId);
          print(formData);
        }
    } catch (error) {
        if (kDebugMode) {
          print('Failed to add user details: $error');
        }
        rethrow;
    }
}

  Future singUpFunc() async {
    if (passwordConfirmed()) {
      //create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));
        if (kDebugMode) {
          print(_selectedUserType);
        }
      }).onError((error, stackTrace) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(title: const Text("Error"), content: Text(error.toString()), actions: <Widget>[
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]));
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(title: const Text("Error"), content: const Text("Passwords do not match"), actions: <Widget>[
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]));
    }
    GenericUser user;
      if (_selectedUserType == UserType.patient) {
        user = Patient(
          fullName: _fullNameController.text.trim(),
          userName: _userNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim(),
          dateOfBirth: _DOBController.text.trim(),
          gender: _genderController.text.trim(),
          age: _ageController.text.trim(),
          address: _addressController.text.trim(),
          knownAllergies: _knownAlergiesController.text.trim(),
        );
      } else {
        user = Physician(
          fullName: _fullNameController.text.trim(),
          userName: _userNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim(),
          specialization: _specializationController.text.trim(),
          licenseNumber: _licenseNumberController.text.trim(),
          yearsOfExperience: _yearsOfExperienceController.text.trim(),
          hospitalAffiliation: _hospitalAffiliationController.text.trim(),
        );
      }

    // add user details
    await addUserDetails(userId: FirebaseAuth.instance.currentUser!.uid, user: user);
  }

  Widget _userTypeToggle(List<UserType> userTypes, List<String> titles) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(30.0),
        isSelected: userTypes.map((type) => type == _selectedUserType).toList(),
        onPressed: (int index) {
          setState(() {
            _selectedUserType = userTypes[index];
          });
        },
        children: titles
            .map((title) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(title, style: const TextStyle(fontSize: 16.0)),
                ))
            .toList(),
      ),
    );
  }

  Widget _spacing() => const SizedBox(height: 20);

  Widget _inputField(String hintText, IconData icon, bool isObscure, TextEditingController controller) {
    return Column(
      children: [
        ReusableTextField(hintText: hintText, leadingIcon: icon, isObscure: isObscure, controller: controller),
        _spacing(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //decoration: AppDecorations.linearGradient,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: [
                //welcome toggle
                Text("welcome to fisio seguro you are a $_selectedUserType", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                // User type toggle
                _userTypeToggle([UserType.patient, UserType.physician], ['Physician', 'Patient']),

                _spacing(),
                _inputField("Enter UserName", Icons.person_outline, false, _userNameController),
                _inputField("Enter Email Id", Icons.email_outlined, false, _emailController),
                _inputField("Enter Password", Icons.lock_outlined, true, _passwordController),
                _inputField("confirm Password", Icons.lock_outlined, true, _passwordConfirmController),
                _inputField("Enter Full Name", Icons.person_outline, false, _fullNameController),
                _inputField("Enter Phone", Icons.phone_outlined, false, _phoneController),

                if (_selectedUserType == UserType.patient) ...[
                  _inputField("Enter Date of Birth", Icons.calendar_today_outlined, false, _DOBController),
                  _inputField("Enter Gender", Icons.person_outline, false, _genderController),
                  _inputField("Enter Age", Icons.person_outline, false, _ageController),
                  _inputField("Enter Address", Icons.home_outlined, false, _addressController),
                  _inputField("Enter Known Allergies", Icons.medical_services_outlined, false, _knownAlergiesController),
                ] else if (_selectedUserType == UserType.physician) ...[
                  _inputField("Enter Specialization", Icons.local_hospital_outlined, false, _specializationController),
                  _inputField("Enter License Number", Icons.badge_outlined, false, _licenseNumberController),
                  _inputField("Enter Years of Experience", Icons.hourglass_empty_outlined, false, _yearsOfExperienceController),
                  _inputField("Enter Hospital Affiliation", Icons.local_hospital_outlined, false, _hospitalAffiliationController),
                ],
                //firebaseUIButton(context, "Sign Up", singUpFunc),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
