import 'package:fisio_seguro_app/models/user.dart';

class Physiotherapist extends GenericUser {
  String specialization;
  String licenseNumber;
  String yearsOfExperience;
  String hospitalAffiliation;

  Physiotherapist({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String phone,
    required this.specialization,
    required this.licenseNumber,
    required this.yearsOfExperience,
    required this.hospitalAffiliation,
  }) : super(fullName: fullName, userName: userName, email: email, password: password, phone: phone);

  String get getSpecialization => specialization;
  set setSpecialization(String value) => specialization = value;

  String get getLicenseNumber => licenseNumber;
  set setLicenseNumber(String value) => licenseNumber = value;

  String get getYearsOfExperience => yearsOfExperience;
  set setYearsOfExperience(String value) => yearsOfExperience = value;

  String get getHospitalAffiliation => hospitalAffiliation;
  set setHospitalAffiliation(String value) => hospitalAffiliation = value;

  Physiotherapist.fromMap(Map<String, dynamic> map)
      : specialization = map['specialization'],
        licenseNumber = map['licenseNumber'],
        yearsOfExperience = map['yearsOfExperience'],
        hospitalAffiliation = map['hospitalAffiliation'],
        super(
          fullName: map['fullName'],
          userName: map['userName'],
          email: map['email'],
          password: map['password'],
          phone: map['phone'],
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'password': password,
      'phone': phone,
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'yearsOfExperience': yearsOfExperience,
      'hospitalAffiliation': hospitalAffiliation,
    };
  }
}
