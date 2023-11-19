import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({Key? key}) : super(key: key);

  @override
  _RegistrationFormScreenState createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  List<Map<String, dynamic>> persons = [];
  bool isDoctor = false;

  late String filePath;
  TextEditingController nameController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController rucController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFilePath();
  }

  Future<void> _savePersons() async {
    final File file = File(filePath);
    final String data = json.encode(persons);
    await file.writeAsString(data);
  }

  Future<void> _initializeFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    filePath = '${directory.path}/persons.json';

    final File file = File(filePath);
    final String jsonString = await rootBundle.loadString('assets/persons.json');
    await file.writeAsString(jsonString);

    _loadPersons();
  }

  Future<void> _loadPersons() async {
    if (filePath.isEmpty) return;

    final File file = File(filePath);
    final data = await file.readAsString();
    final List<Map<String, dynamic>> loadedPersons = List.from(json.decode(data));
    loadedPersons.sort((a, b) => a['idPersona'].compareTo(b['idPersona']));

    setState(() {
      persons = loadedPersons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Clientes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: rucController,
              decoration: const InputDecoration(labelText: 'RUC'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: cedulaController,
              decoration: const InputDecoration(labelText: 'Cédula'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addPerson,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add), // Icono para el botón de agregar persona
                  SizedBox(width: 8),
                  Text('Agregar Persona'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Nombre: ${persons[index]['nombre']} ${persons[index]['apellido']}'),
                    subtitle: Text('RUC: ${persons[index]['RUC']} \nEmail: ${persons[index]['email']} \nCédula: ${persons[index]['cedula']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addPerson() {
    if (nameController.text.isNotEmpty &&
        apellidoController.text.isNotEmpty &&
        rucController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        cedulaController.text.isNotEmpty) {
      int newId = persons.isNotEmpty ? persons.last['idPersona'] + 1 : 1;

      setState(() {
        persons.add({
          'idPersona': newId,
          'nombre': nameController.text,
          'apellido': apellidoController.text,
          'RUC': rucController.text,
          'email': emailController.text,
          'cedula': cedulaController.text,
          'isDoctor': isDoctor,
        });
        persons.sort((a, b) => a['idPersona'].compareTo(b['idPersona']));
      });

      _savePersons(); // Save changes to file
    }
  }
}
