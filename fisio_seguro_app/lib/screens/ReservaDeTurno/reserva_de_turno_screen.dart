import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';


class ReservaDeTurnosScreen extends StatefulWidget {
  const ReservaDeTurnosScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReservaDeTurnosScreenState createState() => _ReservaDeTurnosScreenState();
}

class _ReservaDeTurnosScreenState extends State<ReservaDeTurnosScreen> {
  List<Map<String, dynamic>> turnos = [];
  DateTime selectedDate = DateTime.now();
  String? selectedTime = null;
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

  Future<void> _saveturnos() async {
    final File file = File(filePath);
    final String data = json.encode(turnos);
    await file.writeAsString(data);
  }

  Future<void> _initializeFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    filePath = '${directory.path}/reservas.json';

    final File file = File(filePath);
    final String jsonString = await rootBundle.loadString('assets/reservas.json');
    await file.writeAsString(jsonString);


    _loadReservasHoy();
  }

  Future<void> _loadReservasHoy() async {
    if (filePath.isEmpty) return;

    final File file = File(filePath);
    final data = await file.readAsString();
    List<Map<String, dynamic>> loadedturnos = List.from(json.decode(data));
    loadedturnos.sort((a, b) => a['id'].compareTo(b['id']));


    setState(() {
      turnos = loadedturnos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reserva de turnos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form for adding new turnos (nombre, apellido, telefono, email, cedula, checkbox is doctor)
            //make a form for the registration of a person
            // start then the name, then the last name, then the phone number, then the email, then the cedula number, then the checkbox for if it is a doctor or not
            TextField(
              controller: nameController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Paciente',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: apellidoController,
              decoration: const InputDecoration(
                labelText: 'Doctor',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Selecciona una fecha',
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(text: selectedDate.toLocal().toString().split(' ')[0]),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedTime,
              hint: const Text('Selecciona una hora'),
              items: [
                "09:00 - 10:00",
                "10:00 - 11:00",
                "11:00 - 12:00",
                "12:00 - 13:00",
                "13:00 - 14:00",
                "14:00 - 15:00",
                "15:00 - 16:00",
                "16:00 - 17:00",
                "17:00 - 18:00",
                "18:00 - 19:00",
                "19:00 - 20:00",
                "20:00 - 21:00"
              ]
              .map((time) => DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  ))
              .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedTime = value;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: _addCategory,
              child: const Text('Agendar Reserva'),
            ),
            const SizedBox(height: 20),
            // Table to display turnos
            Expanded(
              child: ListView.builder(
                itemCount: turnos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Paciente: ${turnos[index]['nombre']} ${turnos[index]['apellido']}'),
                    //subtitle = telefono, email, cedula
                    subtitle: Text('Doctor: ${turnos[index]['nombre']} ${turnos[index]['apellido']}\nFecha: ${turnos[index]['fecha']}\nHora: ${turnos[index]['hora']}'),
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
    if (nameController.text.isNotEmpty && apellidoController.text.isNotEmpty && telefonoController.text.isNotEmpty && emailController.text.isNotEmpty && cedulaController.text.isNotEmpty && isDoctorController.text.isNotEmpty) {
      int newId =  turnos.isNotEmpty ? turnos.last['idPersona'] + 1 : 1;
      
      setState(() {
        turnos.add({
          'idPersona': newId,
          'nombre': nameController.text,
          'apellido': apellidoController.text,
          'telefono': telefonoController.text,
          'email': emailController.text,
          'cedula': cedulaController.text,
          'isDoctor': isDoctorController.text == 'true',
        });
        turnos.sort((a, b) => a['idPersona'].compareTo(b['idPersona']));

        idController.clear();
        descripcionController.clear();
      });

      _saveturnos(); // Save changes to file
    }
  }

  void _editCategory(int index) {
    final TextEditingController idEditController = TextEditingController(text: turnos[index]['id'].toString());
    final TextEditingController descripcionEditController = TextEditingController(text: turnos[index]['descripcion']);

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
              if (turnos.where((category) => category['idPersona'] == newId && turnos.indexOf(category) != index).isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID already exists!')));
                return;
              }

              setState(() {
                turnos[index] = {
                  'idPersona': newId,
                  'descripcion': newDescripcion,
                };
                turnos.sort((a, b) => a['idPersona'].compareTo(b['idPersona']));
              });

              _saveturnos(); // Save changes to file
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
      turnos.removeAt(index);
    });
    _saveturnos(); // Save changes to file
  }
}
