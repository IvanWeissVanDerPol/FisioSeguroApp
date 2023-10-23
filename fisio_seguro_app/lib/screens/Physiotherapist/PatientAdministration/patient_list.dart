import 'package:fisio_seguro_app/models/user.dart';
import 'package:flutter/material.dart';


class PatientList extends StatelessWidget {
  final List<Patient> patients;
  final ValueChanged<Patient> onPatientTap;

  const PatientList({
    Key? key,
    required this.patients,
    required this.onPatientTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return ListTile(
          title: Text('${patient.fullName} ${patient.userName}'),
          onTap: () => onPatientTap(patient),
        );
      },
    );
  }
}
