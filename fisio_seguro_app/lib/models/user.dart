// ignore_for_file: unnecessary_getters_setters

abstract class GenericUser {
  String _fullName;
  String _userName;
  String _email;
  String _password;
  String _phone;

  GenericUser({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String phone,
  })  : _fullName = fullName,
        _userName = userName,
        _email = email,
        _password = password,
        _phone = phone;

  String get fullName => _fullName;
  set fullName(String value) => _fullName = value;

  String get userName => _userName;
  set userName(String value) => _userName = value;

  String get email => _email;
  set email(String value) => _email = value;

  String get password => _password;
  set password(String value) => _password = value;

  String get phone => _phone;
  set phone(String value) => _phone = value;

  Map<String, dynamic> toMap();
}

class Physician extends GenericUser {
  String _specialization;
  String _licenseNumber;
  String _yearsOfExperience;
  String _hospitalAffiliation;

  Physician({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String phone,
    required String specialization,
    required String licenseNumber,
    required String yearsOfExperience,
    required String hospitalAffiliation,
  })  : _specialization = specialization,
        _licenseNumber = licenseNumber,
        _yearsOfExperience = yearsOfExperience,
        _hospitalAffiliation = hospitalAffiliation,
        super(
          fullName: fullName,
          userName: userName,
          email: email,
          password: password,
          phone: phone,
        );

  String get specialization => _specialization;
  set specialization(String value) => _specialization = value;

  String get licenseNumber => _licenseNumber;
  set licenseNumber(String value) => _licenseNumber = value;

  String get yearsOfExperience => _yearsOfExperience;
  set yearsOfExperience(String value) => _yearsOfExperience = value;

  String get hospitalAffiliation => _hospitalAffiliation;
  set hospitalAffiliation(String value) => _hospitalAffiliation = value;

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

class Patient extends GenericUser {
  String _dateOfBirth;
  String _gender;
  String _age;
  String _address;
  String _knownAllergies;

  Patient({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String age,
    required String address,
    required String knownAllergies,
  })  : _dateOfBirth = dateOfBirth,
        _gender = gender,
        _age = age,
        _address = address,
        _knownAllergies = knownAllergies,
        super(
          fullName: fullName,
          userName: userName,
          email: email,
          password: password,
          phone: phone,
        );

  String get dateOfBirth => _dateOfBirth;

  set dateOfBirth(String value) => _dateOfBirth = value;

  String get gender => _gender;
  set gender(String value) => _gender = value;

  String get age => _age;
  set age(String value) => _age = value;

  String get address => _address;
  set address(String value) => _address = value;

  String get knownAllergies => _knownAllergies;
  set knownAllergies(String value) => _knownAllergies = value;

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

  factory Patient.fromMap(Map<String, dynamic> data) {
    return Patient(
      fullName: data['fullName'],
      userName: data['userName'],
      email: data['email'],
      password: data['password'],
      phone: data['phone'],
      dateOfBirth: data['dateOfBirth'],
      gender: data['gender'],
      age: data['age'],
      address: data['address'],
      knownAllergies: data['knownAllergies'],
    );
  }
}

