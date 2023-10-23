import 'package:fisio_seguro_app/models/patient.dart';
import 'package:fisio_seguro_app/providers/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PatientListScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  PatientListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Enter patient name'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _controller.text;
              if (name.isNotEmpty) {
                Provider.of<PatientProvider>(context, listen: false).addPatient(Patient(fullName: name, age: 30, knownAllergies: '', address: '', userName: '', email: '', password: '', phone: '', dateOfBirth: '', gender: ''));
                _controller.clear();
              }
            },
            child: const Text('Add Patient'),
          ),
          Expanded(
            child: Consumer<PatientProvider>(
              builder: (context, patientProvider, child) {
                return ListView.builder(
                  itemCount: patientProvider.patients.length,
                  itemBuilder: (context, index) {
                    final patient = patientProvider.patients[index];
                    return ListTile(
                      title: Text('${patient.fullName}, ${patient.age} years old'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          patientProvider.removePatient(patient);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
