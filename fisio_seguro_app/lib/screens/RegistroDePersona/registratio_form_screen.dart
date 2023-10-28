import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationFormScreenState createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  List<Map<String, dynamic>> persons = [];

  // Controllers for form inputs
  late String filePath;
  TextEditingController idController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController isDoctorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFilePath();
  }

  Future<void> _savepersons() async {
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
    if (!await file.exists()) {
      final String jsonString = await rootBundle.loadString('assets/persons.json');
      await file.writeAsString(jsonString);
    }

    _loadpersons();
  }

  Future<void> _loadpersons() async {
    if (filePath.isEmpty) return;

    final File file = File(filePath);
    final data = await file.readAsString();
    final List<Map<String, dynamic>> loadedpersons = List.from(json.decode(data));
    loadedpersons.sort((a, b) => a['idPersona'].compareTo(b['idPersona']));

    setState(() {
      persons = loadedpersons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('registro de personas')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            //
            child: Column(
              children: [
                // Form for adding new persons (nombre, apellido, telefono, email, cedula, checkbox is doctor)
                //make a form for the registration of a person
                // start then the name, then the last name, then the phone number, then the email, then the cedula number, then the checkbox for if it is a doctor or not
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'nombre',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: apellidoController,
                  decoration: const InputDecoration(
                    labelText: 'apellido',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'telefono',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'email',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cedulaController,
                  decoration: const InputDecoration(
                    labelText: 'cedula',
                  ),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text('Is Doctor'),
                  value: isDoctorController.text.isNotEmpty ? isDoctorController.text == 'true' : false,
                  onChanged: (value) {
                    setState(() {
                      isDoctorController.text = value.toString();
                    });
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addPerson,
                  child: const Text('Agregar persona'),
                ),
                const SizedBox(height: 20),
                // Table to display persons
                ListView.builder(
              itemCount: persons.length,
              shrinkWrap: true, // <-- This makes the ListView only take up the space it needs
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('nombre: ${persons[index]['nombre']} ${persons[index]['apellido']}'),
                  subtitle: Text('telefono: ${persons[index]['telefono']} \nemail: ${persons[index]['email']} \ncedula: ${persons[index]['cedula']} \nisDoctor: ${persons[index]['isDoctor']}'),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}


  void _addPerson() {
    if (nameController.text.isNotEmpty && apellidoController.text.isNotEmpty && telefonoController.text.isNotEmpty && emailController.text.isNotEmpty && cedulaController.text.isNotEmpty) {
      int newId = persons.isNotEmpty ? persons.last['idPersona'] + 1 : 1;

      setState(() {
        persons.add({
          'idPersona': newId,
          'nombre': nameController.text,
          'apellido': apellidoController.text,
          'telefono': telefonoController.text,
          'email': emailController.text,
          'cedula': cedulaController.text,
          'isDoctor': isDoctorController.text == 'true',
        });
        persons.sort((a, b) => b['idPersona'].compareTo(a['idPersona']));

        idController.clear();
        descripcionController.clear();
      });

      _savepersons(); // Save changes to file
    }
  }

  void _editPerson(int index) {
    final TextEditingController idEditController = TextEditingController(text: persons[index]['id'].toString());
    final TextEditingController descripcionEditController = TextEditingController(text: persons[index]['descripcion']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idEditController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Id Categoría',
              ),
            ),
            TextField(
              controller: descripcionEditController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final int newId = int.parse(idEditController.text);
              final String newDescripcion = descripcionEditController.text;

              // Check if updated ID is unique (excluding the current Person being edited)
              if (persons.where((Person) => Person['idPersona'] == newId && persons.indexOf(Person) != index).isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID already exists!')));
                return;
              }

              setState(() {
                persons[index] = {
                  'idPersona': newId,
                  'descripcion': newDescripcion,
                };
                persons.sort((a, b) => a['idPersona'].compareTo(b['idPersona']));
              });

              _savepersons(); // Save changes to file
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deletePerson(int index) {
    setState(() {
      persons.removeAt(index);
    });
    _savepersons(); // Save changes to file
  }
}
