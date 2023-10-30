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
  List<Map<String, dynamic>> personas = [];
  List<Map<String, dynamic>> categorias = [];
  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  String? pacienteSeleccionado;
  String? doctorSeleccionado;
  late String filePathTurno;
  List<String> pacientes = [];
  List<String> doctores = [];
  // Controllers for form inputs
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
    _initialize('categories');
    _initialize('persons');
    _initialize('turnos');
  }

  Future<void> _saveturnos() async {
    final File file = File(filePathTurno);
    final String data = json.encode(turnos);
    await file.writeAsString(data);
  }

//si el archivo no existe, lo crea y lo llena con el contenido del archivo persons.json
// si el archivo existe, lo carga
  Future<void> _initialize(String objeto) async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$objeto.json';
    if (objeto == 'turnos') {
      filePathTurno = filePath;
    }
    final File file = File(filePath);
    if (!await file.exists()) {
      final String jsonString = await rootBundle.loadString('assets/$objeto.json');
      await file.writeAsString(jsonString);
    }
    final data = await file.readAsString();
    final List<Map<String, dynamic>> loadedData = List.from(json.decode(data));
    setState(() {
      if (objeto == 'categories') {
        categorias = loadedData;
      } else if (objeto == 'persons') {
        personas = loadedData;
      } else if (objeto == 'turnos') {
        turnos = loadedData;
      }
    });
  }

  List<DropdownMenuItem<String>> _listaPersonas(bool isDoctor) {
    List<DropdownMenuItem<String>> listaPacientes = personas
      .where((persona) => persona['isDoctor'] == isDoctor)
      .map((persona) {
        String nombre = persona['nombre'];
        String apellido = persona['apellido'];
        String personaId = persona['idPersona'].toString();
        String nombreCompleto = '$nombre $apellido';
        return DropdownMenuItem<String>(
          value: personaId,
          child: Text(nombreCompleto),
        );
      })
      .toList();
    return listaPacientes;
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
            DropdownButton<String>(
            value: pacienteSeleccionado, // El valor seleccionado (inicialmente null)
            hint: const Text('Selecciona un paciente'), // Texto que se muestra cuando no se ha seleccionado nada
            items: _listaPersonas(false),
            onChanged: (String? newValue) {
                        setState(() {
                          if(newValue != null) {
                            pacienteSeleccionado = newValue;
                          }
                        });
                      },
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
            value: doctorSeleccionado, // El valor seleccionado (inicialmente null)
            hint: const Text('Selecciona un doctor'), // Texto que se muestra cuando no se ha seleccionado nada
            items: _listaPersonas(true),
            onChanged: (String? newValue) {
                        setState(() {
                          if(newValue != null) {
                            doctorSeleccionado = newValue;
                          }
                        });
                      },
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
                    title: Text('Paciente: ${turnos[index]['paciente']['nombre']} ${turnos[index]['paciente']['apellido']}'),
                    subtitle: Text('Doctor: ${turnos[index]['doctor']['nombre']} ${turnos[index]['doctor']['apellido']}\nFecha: ${
                      DateFormat('dd-MM-yyyy').format(DateTime.parse(turnos[index]['fecha']))}\nHora: ${turnos[index]['hora']}'),
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
    if (pacienteSeleccionado != null && doctorSeleccionado != null && selectedTime != null) {
      int newId =  turnos.isNotEmpty ? turnos.last['id'] + 1 : 1;
      
      setState(() {
        turnos.add({
          'id': newId,
          'doctor': {
            'idPersona': personas[int.parse(doctorSeleccionado!)]['idPersona'],
            'nombre': personas[int.parse(doctorSeleccionado!)]['nombre'],
            'apellido': personas[int.parse(doctorSeleccionado!)]['apellido'],
            'telefono': personas[int.parse(doctorSeleccionado!)]['telefono'],
            'email': personas[int.parse(doctorSeleccionado!)]['email'],
            'cedula': personas[int.parse(doctorSeleccionado!)]['cedula'],
            'isDoctor': personas[int.parse(doctorSeleccionado!)]['isDoctor'],
            'isEditing': false
          },
          'paciente': {
            'idPersona': personas[int.parse(pacienteSeleccionado!)]['idPersona'],
            'nombre': personas[int.parse(pacienteSeleccionado!)]['nombre'],
            'apellido': personas[int.parse(pacienteSeleccionado!)]['apellido'],
            'telefono': personas[int.parse(pacienteSeleccionado!)]['telefono'],
            'email': personas[int.parse(pacienteSeleccionado!)]['email'],
            'cedula': personas[int.parse(pacienteSeleccionado!)]['cedula'],
            'isDoctor': personas[int.parse(pacienteSeleccionado!)]['isDoctor'],
            'isEditing': false
          },
          'fecha': selectedDate,
          'hora': selectedTime,

          
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
