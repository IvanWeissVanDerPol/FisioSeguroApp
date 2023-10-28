import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ListaDePersonasScreen extends StatefulWidget {
  const ListaDePersonasScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListaDePersonasScreenState createState() => _ListaDePersonasScreenState();
}

class _ListaDePersonasScreenState extends State<ListaDePersonasScreen> {
  List<Map<String, dynamic>> persons = [];
  List<Map<String, dynamic>> originalPersons = []; // New variable

  // Controllers for form inputs
  late String filePath;
  TextEditingController nameController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
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
      originalPersons = List.from(loadedpersons); // Update originalPersons here
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
                onPressed: _filter,
                child: const Text('filter'),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editPerson(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePerson(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _filter() {
    List<Map<String, dynamic>> filteredList = List.from(originalPersons); // Start with the original list

    String filterName = nameController.text.trim();
    String filterApellido = apellidoController.text.trim();
    bool filterIsDoctor = isDoctorController.text == 'true';

    // Filter by name if it's not empty
    if (filterName.isNotEmpty) {
      filteredList = filteredList.where((person) => person['nombre'].toLowerCase().contains(filterName.toLowerCase())).toList();
    }

    // Filter by apellido if it's not empty
    if (filterApellido.isNotEmpty) {
      filteredList = filteredList.where((person) => person['apellido'].toLowerCase().contains(filterApellido.toLowerCase())).toList();
    }

    // Filter by 'Is Doctor' if the checkbox is checked
    if (filterIsDoctor) {
      filteredList = filteredList.where((person) => person['isDoctor'] == true).toList();
    }

    setState(() {
      persons = filteredList; // Update the persons list to the filtered list
    });
  }

  void _editPerson(int index) {
    final TextEditingController nameEditController = TextEditingController(text: persons[index]['nombre']);
    final TextEditingController apellidoEditController = TextEditingController(text: persons[index]['apellido']);
    final TextEditingController telefonoEditController = TextEditingController(text: persons[index]['telefono']);
    final TextEditingController emailEditController = TextEditingController(text: persons[index]['email']);
    final TextEditingController cedulaEditController = TextEditingController(text: persons[index]['cedula'].toString());
    bool isDoctor = persons[index]['isDoctor'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Person'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameEditController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              TextField(
                controller: apellidoEditController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                ),
              ),
              TextField(
                controller: telefonoEditController,
                decoration: const InputDecoration(
                  labelText: 'Telefono',
                ),
              ),
              TextField(
                controller: emailEditController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: cedulaEditController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cedula',
                ),
              ),
              CheckboxListTile(
                title: const Text('Is Doctor'),
                value: isDoctor,
                onChanged: (value) {
                  isDoctor = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                persons[index] = {
                  'nombre': nameEditController.text,
                  'apellido': apellidoEditController.text,
                  'telefono': telefonoEditController.text,
                  'email': emailEditController.text,
                  'cedula': cedulaEditController.text,
                  'isDoctor': isDoctor,
                };
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
