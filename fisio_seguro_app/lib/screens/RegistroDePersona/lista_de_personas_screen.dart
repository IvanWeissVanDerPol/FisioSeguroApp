import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ListaDePersonasScreen extends StatefulWidget {
  const ListaDePersonasScreen({Key? key}) : super(key: key);

  @override
  _ListaDePersonasScreenState createState() => _ListaDePersonasScreenState();
}

class _ListaDePersonasScreenState extends State<ListaDePersonasScreen> {
  List<Map<String, dynamic>> persons = [];
  List<Map<String, dynamic>> originalPersons = [];

  late String filePath;
  TextEditingController nameController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController isDoctorController = TextEditingController();

  bool filterPaciente = false;
  bool filterDoctor = false;

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

    if (!await file.exists()) {
      final String jsonString = await rootBundle.loadString('assets/persons.json');
      await file.writeAsString(jsonString);
    }

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
      originalPersons = List.from(loadedPersons);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Personas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _filter,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter), // Icono para el botón de filtrar
                    SizedBox(width: 8), // Espacio entre el icono y el texto
                    Text('Filtrar'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Nombre: ${persons[index]['nombre']} ${persons[index]['apellido']}'),
                    subtitle: Text('RUC: ${persons[index]['RUC']} \nEmail: ${persons[index]['email']} \nCédula: ${persons[index]['cedula']}'),
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
    List<Map<String, dynamic>> filteredList = List.from(originalPersons);

    String filterName = nameController.text.trim().toLowerCase();
    String filterApellido = apellidoController.text.trim().toLowerCase();

    if (filterPaciente && !filterDoctor) {
      filteredList = filteredList.where((person) => !person['isDoctor']).toList();
    } else if (!filterPaciente && filterDoctor) {
      filteredList = filteredList.where((person) => person['isDoctor']).toList();
    }

    if (filterName.isNotEmpty) {
      filteredList = filteredList.where((person) => person['nombre'].toLowerCase().contains(filterName)).toList();
    }

    if (filterApellido.isNotEmpty) {
      filteredList = filteredList.where((person) => person['apellido'].toLowerCase().contains(filterApellido)).toList();
    }

    setState(() {
      persons = filteredList;
    });
  }

  void _editPerson(int index) {
    final TextEditingController nameEditController = TextEditingController(text: persons[index]['nombre']);
    final TextEditingController apellidoEditController = TextEditingController(text: persons[index]['apellido']);
    final TextEditingController rucEditController = TextEditingController(text: persons[index]['RUC']);
    final TextEditingController emailEditController = TextEditingController(text: persons[index]['email']);
    final TextEditingController cedulaEditController = TextEditingController(text: persons[index]['cedula'].toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Persona'),
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
                controller: rucEditController,
                decoration: const InputDecoration(
                  labelText: 'RUC',
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
                  labelText: 'Cédula',
                ),
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
                  'RUC': rucEditController.text,
                  'email': emailEditController.text,
                  'cedula': cedulaEditController.text,
                };

                // Actualizar la misma entrada en originalPersons
                originalPersons[index] = persons[index];
              });

              _savePersons();
              Navigator.of(context).pop();
            },
            child: const Text('Actualizar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _deletePerson(int index) {
    setState(() {
      persons.removeAt(index);
      originalPersons.removeAt(index); // Eliminar también de originalPersons
    });
    _savePersons();
  }
}
