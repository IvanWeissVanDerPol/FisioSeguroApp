//file  lib/models/Clinitian_profile.dart
class ClinicianModel {
  final String id; // Unique ID (could be from Firebase)
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String specialization; // e.g., Cardiologist, Dentist, etc.
  final String licenseNumber; // Professional license number
  final DateTime joiningDate; // Date when the clinician joined the clinic/hospital
  final String profileImageUrl;
  final String phoneNumber;
  final List<String> languagesSpoken;
  final List<String> certifications;
  // You can add more fields as per your requirements

  ClinicianModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.specialization,
    required this.licenseNumber,
    required this.joiningDate,
    required this.profileImageUrl,
    required this.phoneNumber,
    required this.languagesSpoken,
    required this.certifications,
  });

  toJson(){
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "specialization": specialization,
      "licenseNumber": licenseNumber,
      "joiningDate": joiningDate,
      "profileImageUrl": profileImageUrl,
      "phoneNumber": phoneNumber,
      "languagesSpoken": languagesSpoken,
      "certifications": certifications,
    };
  }

  // Factory method to create an instance of Clinician from a map (e.g., from Firestore)
  factory ClinicianModel.fromMap(Map<String, dynamic> data) {
    return ClinicianModel(
      id: data['id'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      password: data['password'],
      specialization: data['specialization'],
      licenseNumber: data['licenseNumber'],
      joiningDate: DateTime.parse(data['joiningDate']),
      profileImageUrl: data['profileImageUrl'],
      phoneNumber: data['phoneNumber'],
      languagesSpoken: List<String>.from(data['languagesSpoken']),
      certifications: List<String>.from(data['certifications']),
    );
  }

  // Method to convert Clinician instance to map (e.g., to save to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'joiningDate': joiningDate.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'languagesSpoken': languagesSpoken,
      'certifications': certifications,
    };
  }
}
