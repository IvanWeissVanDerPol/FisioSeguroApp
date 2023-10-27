// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class RegistroDePersonasScreen extends StatefulWidget {
  const RegistroDePersonasScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistroDePersonasScreenState createState() => _RegistroDePersonasScreenState();
}

class _RegistroDePersonasScreenState extends State<RegistroDePersonasScreen> {
  // Sample data for personas
  List<Map<String, dynamic>> personas = [
    // Add example data or fetch from an API
  ];
  Map<String, dynamic> newPersona = {
    'nombre': '',
    'apellido': '',
    'telefono': '',
    'email': '',
    'cedula': '',
    'flag_es_doctor': false,
  };

  // Filter variables
  String nombreFilter = '';
  String apellidoFilter = '';
  String tipoFilter = 'todos';

  void addPersona() {
    // Logic to add a new persona
    setState(() {
      personas.add({...newPersona});
    });
  }

  void applyFilters() {
    // Logic to apply filters
  }

  // Other methods for edit, update, and delete can be added

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Filter section
            Column(
              children: [
                const Text('Filter Options', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                TextField(
                  decoration: const InputDecoration(labelText: 'Nombre:'),
                  onChanged: (value) {
                    nombreFilter = value;
                    applyFilters();
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Apellido:'),
                  onChanged: (value) {
                    apellidoFilter = value;
                    applyFilters();
                  },
                ),
                DropdownButton<String>(
                  value: tipoFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      tipoFilter = newValue!;
                      applyFilters();
                    });
                  },
                  items: <String>['todos', 'pacientes', 'doctores']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Add persona form
            Column(
              children: [
                const Text('Add Persona', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                TextField(
                  decoration: const InputDecoration(labelText: 'Nombre:'),
                  onChanged: (value) => newPersona['nombre'] = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Apellido:'),
                  onChanged: (value) => newPersona['apellido'] = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Teléfono:'),
                  onChanged: (value) => newPersona['telefono'] = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Email:'),
                  onChanged: (value) => newPersona['email'] = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Cédula:'),
                  onChanged: (value) => newPersona['cedula'] = value,
                ),
                CheckboxListTile(
                  title: const Text('Es Doctor?'),
                  value: newPersona['flag_es_doctor'],
                  onChanged: (bool? value) {
                    setState(() {
                      newPersona['flag_es_doctor'] = value;
                    });
                  },
                ),
                ElevatedButton(onPressed: addPersona, child: const Text('Add')),
              ],
            ),
            const SizedBox(height: 20.0),
            // Table for personas
            Expanded(
              child: ListView.builder(
                itemCount: personas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(personas[index]['nombre']),
                    subtitle: Text(personas[index]['apellido']),
                    // Add more details and action buttons as needed
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
