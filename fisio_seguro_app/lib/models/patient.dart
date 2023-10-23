// ignore: file_names
import 'package:fisio_seguro_app/models/user.dart';

class Patient extends GenericUser {
  final String dateOfBirth;
  final String gender;
  final int age;
  final String address;
  final String knownAllergies;

  Patient({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String phone,
    required this.dateOfBirth,
    required this.gender,
    required this.age,
    required this.address,
    required this.knownAllergies,
  }) : super(
            fullName: fullName,
            userName: userName,
            email: email,
            password: password,
            phone: phone);


  @override
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'password': password,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'age': age,
      'address': address,
      'knownAllergies': knownAllergies,
    };
  }
}

