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
      appBar: AppBar(title: const Text('Categoria de Consultas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form for adding new category
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Id Categoría',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addCategory,
              child: const Text('Agregar Categoria'),
            ),
            const SizedBox(height: 20),
            // Table to display persons
            Expanded(
              child: ListView.builder(
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('nombre: ${persons[index]['nombre']} ${persons[index]['apellido']}'),
                    //subtitle = telefono, email, cedula
                    subtitle: Text('telefono: ${persons[index]['telefono']} email: ${persons[index]['email']} cedula: ${persons[index]['cedula']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editCategory(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCategory(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addCategory() {
    if (idController.text.isNotEmpty && descripcionController.text.isNotEmpty) {
      int newId = int.parse(idController.text);
      // Check if ID already exists
      bool idExists = persons.any((category) => category['id'] == newId);

      if (idExists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID already exists!')));
        return;
      }

      setState(() {
        persons.add({'id': newId, 'descripcion': descripcionController.text});
        persons.sort((a, b) => a['idPersona'].compareTo(b['idPersona']));

        idController.clear();
        descripcionController.clear();
      });

      _savepersons(); // Save changes to file
    }
  }

  void _editCategory(int index) {
  final TextEditingController idEditController = TextEditingController(text: persons[index]['id'].toString());
  final TextEditingController descripcionEditController = TextEditingController(text: persons[index]['descripcion']);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Category'),
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

            // Check if updated ID is unique (excluding the current category being edited)
            if (persons.where((category) => category['idPersona'] == newId && persons.indexOf(category) != index).isNotEmpty) {
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


  void _deleteCategory(int index) {
    setState(() {
      persons.removeAt(index);
    });
    _savepersons(); // Save changes to file
  }
}

