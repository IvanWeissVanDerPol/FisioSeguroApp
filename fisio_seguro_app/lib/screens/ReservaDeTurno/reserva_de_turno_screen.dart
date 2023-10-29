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
  DateTime selectedDate = DateTime.now();
  String? selectedTime = null;
  String? PacienteSeleccionado = null;
  String? pacienteId = null;
  List<String> pacientes = [];
  List<String> doctores = [];
  // Controllers for form inputs
  late String filePathTurno;
  late String filePathPersona;
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
    _initializefilePathPersona();
    _initializefilePathTurno();
  }

  Future<void> _saveturnos() async {
    final File file = File(filePathTurno);
    final String data = json.encode(turnos);
    await file.writeAsString(data);
  }

  Future<void> _initializefilePathTurno() async {
    final directory = await getApplicationDocumentsDirectory();
    filePathTurno = '${directory.path}/reservas.json';

    final File file = File(filePathTurno);
    final String jsonString = await rootBundle.loadString('assets/reservas.json');
    await file.writeAsString(jsonString);


    _loadReservasHoy();
  }

  Future<void> _initializefilePathPersona() async {
    final directory = await getApplicationDocumentsDirectory();
    filePathPersona = '${directory.path}/persons.json';

    final File file = File(filePathPersona);
    final String jsonString = await rootBundle.loadString('assets/persons.json');
    await file.writeAsString(jsonString);
    if (!await file.exists()) {
      final String jsonString = await rootBundle.loadString('assets/persons.json');
      await file.writeAsString(jsonString);
    }

    _loadpersons();
  }

  Future<void> _loadpersons() async {
    if (filePathPersona.isEmpty) return;

    final File file = File(filePathPersona);
    final data = await file.readAsString();
    final List<Map<String, dynamic>> loadedpersons = List.from(json.decode(data));
    loadedpersons.sort((a, b) => a['idPersona'].compareTo(b['idPersona']));

    setState(() {
      personas = loadedpersons;
    });
  }

  Future<void> _loadReservasHoy() async {
    if (filePathTurno.isEmpty) return;

    final File file = File(filePathTurno);
    final data = await file.readAsString();
    List<Map<String, dynamic>> loadedturnos = List.from(json.decode(data));
    loadedturnos.sort((a, b) => a['id'].compareTo(b['id']));


    setState(() {
      turnos = loadedturnos;
    });
  }

  List<DropdownMenuItem<String>> _listaPacientes() {
    List<DropdownMenuItem<String>> listaPacientes = turnos
      .where((turno) => turno.containsKey('paciente'))
      .map((turno) {
        String nombre = turno['paciente']['nombre'];
        String apellido = turno['paciente']['apellido'];
        String nombreCompleto = '$nombre $apellido';
        return DropdownMenuItem<String>(
          value: turno['paciente']['idPersona'].toString(),
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
            value: PacienteSeleccionado, // El valor seleccionado (inicialmente null)
            hint: const Text('Selecciona un paciente'), // Texto que se muestra cuando no se ha seleccionado nada
            items: _listaPacientes(),//[_listaPacientes()],
            onChanged: (String? newValue) {
                        setState(() {
                          pacienteId = newValue;
                          _addCategory();
                        });
                      },
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
    if (nameController.text.isNotEmpty && apellidoController.text.isNotEmpty && telefonoController.text.isNotEmpty && emailController.text.isNotEmpty && cedulaController.text.isNotEmpty && isDoctorController.text.isNotEmpty) {
      int newId =  turnos.isNotEmpty ? turnos.last['id'] + 1 : 1;
      
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
