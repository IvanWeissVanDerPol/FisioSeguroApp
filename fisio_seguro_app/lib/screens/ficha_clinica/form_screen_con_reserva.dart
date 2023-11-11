import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';


class FichaClinicaFormScreenConReserva extends StatefulWidget {
  const FichaClinicaFormScreenConReserva({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FichaClinicaFormScreenConReserva createState() => _FichaClinicaFormScreenConReserva();
}

class _FichaClinicaFormScreenConReserva extends State<FichaClinicaFormScreenConReserva> {
  List<Map<String, dynamic>> turnos = [];
  List<Map<String, dynamic>> personas = [];
  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> fichas = [];
  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  String? selectedPaciente;
  String? selectedDoctor;
  String? selectedCategory;
  String? selectedTurnos;
  TextEditingController selectedMotivo = TextEditingController();
  TextEditingController selectedDiagnostico = TextEditingController();
  late String filePathFichas;

  @override
  void initState() {
    super.initState();
    _initialize('categories');
    _initialize('persons');
    _initialize('turnos');
    _initialize('fichasClinicas');
  }

  Future<void> _savefichas() async {
    final File file = File(filePathFichas);
    final String data = json.encode(fichas);
    await file.writeAsString(data);
  }

//si el archivo no existe, lo crea y lo llena con el contenido del archivo persons.json
// si el archivo existe, lo carga
  Future<void> _initialize(String objeto) async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$objeto.json';
    if (objeto == 'fichasClinicas') {
      filePathFichas = filePath;
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
      } else if (objeto == 'fichasClinicas') {
        fichas = loadedData;
      }
    });
  }

List<DropdownMenuItem<String>> _listaTurnos() {
  print('Longitud de la lista de turnos: ${turnos.length}'); // para revisar cuantos turnos hay
  List<DropdownMenuItem<String>> listaTurnos = turnos
    .map((turno) {
      String nombreDoctor = turno['doctor']['nombre'];
      String nombrePaciente = turno['paciente']['nombre'];
      String fecha = DateTime.parse(turno['fecha']).toLocal().toString().split(' ')[0];
      String hora = turno['hora'];
      String categoria = turno['categoria']['descripcion'];

      String displayText = '$nombreDoctor, $nombrePaciente, $fecha, $hora, $categoria';

      return DropdownMenuItem<String>(
        value: turno['id'].toString(),
        child: Text(displayText),
      );
    })
    .toList();
  return listaTurnos;
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

  List<DropdownMenuItem<String>> _listaCategorias() {
    List<DropdownMenuItem<String>> listaCategorias = categorias
      .map((categoria) {
        String nombre = categoria['descripcion'];
        String categoriaId = categoria['id'].toString();
        return DropdownMenuItem<String>(
          value: categoriaId,
          child: Text(nombre),
        );
      })
      .toList();
    return listaCategorias;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reserva de fichas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form for adding new turnos (nombre, apellido, telefono, email, cedula, checkbox is doctor)
            //make a form for the registration of a person
            // start then the name, then the last name, then the phone number, then the email, then the cedula number, then the checkbox for if it is a doctor or not
           Container(
              width: double.infinity,
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedTurnos,
                hint: const Text('Selecciona una reserva de'),
                items: _listaTurnos(),
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      selectedTurnos = newValue;
                    }
                  });
                },
              ),
            ),

            // DropdownButton<String>(
            // value: selectedPaciente, // El valor seleccionado (inicialmente null)
            // hint: const Text('Selecciona un paciente'), // Texto que se muestra cuando no se ha seleccionado nada
            // items: _listaPersonas(false),
            // onChanged: (String? newValue) {
            //             setState(() {
            //               if(newValue != null) {
            //                 selectedPaciente = newValue;
            //               }
            //             });
            //           },
            // ),
            // DropdownButton<String>(
            // value: selectedDoctor, // El valor seleccionado (inicialmente null)
            // hint: const Text('Selecciona un doctor'), // Texto que se muestra cuando no se ha seleccionado nada
            // items: _listaPersonas(true),
            // onChanged: (String? newValue) {
            //             setState(() {
            //               if(newValue != null) {
            //                 selectedDoctor = newValue;
            //               }
            //             });
            //           },
            // ),
            // TextFormField(
            //   decoration: const InputDecoration(
            //     hintText: 'Selecciona una fecha',
            //   ),
            //   onTap: () async {
            //     DateTime? pickedDate = await showDatePicker(
            //       context: context,
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime(2000),
            //       lastDate: DateTime(2100),
            //     );

            //     if (pickedDate != null && pickedDate != selectedDate) {
            //       setState(() {
            //         selectedDate = pickedDate;
            //       });
            //     }
            //   },
            //   controller: TextEditingController(text: selectedDate.toLocal().toString().split(' ')[0]),
            //   readOnly: true,
            // ),
            // DropdownButton<String>(
            //   value: selectedTime,
            //   hint: const Text('Selecciona una hora'),
            //   items: [
            //     "09:00 - 10:00",
            //     "10:00 - 11:00",
            //     "11:00 - 12:00",
            //     "12:00 - 13:00",
            //     "13:00 - 14:00",
            //     "14:00 - 15:00",
            //     "15:00 - 16:00",
            //     "16:00 - 17:00",
            //     "17:00 - 18:00",
            //     "18:00 - 19:00",
            //     "19:00 - 20:00",
            //     "20:00 - 21:00"
            //   ]
            //   .map((time) => DropdownMenuItem<String>(
            //         value: time,
            //         child: Text(time),
            //       ))
            //   .toList(),
            //   onChanged: (String? value) {
            //     if (value != null) {
            //       setState(() {
            //         selectedTime = value;
            //       });
            //     }
            //   },
            // ),
            // DropdownButton<String>(
            // value: selectedCategory, // El valor seleccionado (inicialmente null)
            // hint: const Text('Selecciona una Categoria'), // Texto que se muestra cuando no se ha seleccionado nada
            // items: _listaCategorias(),
            // onChanged: (String? newValue) {
            //             setState(() {
            //               if(newValue != null) {
            //                 selectedCategory = newValue;
            //               }
            //             });
            //           },
            // ),
            TextField(
              controller: selectedMotivo,
              decoration: const InputDecoration(
                labelText: 'Motivo de la consulta',
              ),
            ),
            TextField(
              controller: selectedDiagnostico,
              decoration: const InputDecoration(
                labelText: 'Diagnostico',
              ),
            ),
            ElevatedButton(
              onPressed: _addFicha,
              child: const Text('Agendar Ficha Clinica'),
            ),
            const SizedBox(height: 20),
            // Table to display fichas
            Expanded(
              child: ListView.builder(
                itemCount: fichas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Paciente: ${fichas[index]['paciente']['nombre']} ${fichas[index]['paciente']['apellido']}'),
                    subtitle: Text('Doctor: ${fichas[index]['doctor']['nombre']} ${fichas[index]['doctor']['apellido']}\nFecha: ${
                      DateFormat('dd-MM-yyyy').format(DateTime.parse(fichas[index]['fecha']))}\t${fichas[index]['hora']}\nCategoria: ${
                        fichas[index]['categoria']['descripcion']}\nMotivo: ${fichas[index]['motivoConsulta']}\nDiagnostico: ${fichas[index]['diagnostico']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editTurno(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteFicha(index),
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

void _addFicha() {
  if (selectedPaciente != null &&
      selectedDoctor != null &&
      selectedCategory != null &&
      selectedTime != null &&
      selectedMotivo.text.isNotEmpty &&
      selectedDiagnostico.text.isNotEmpty) {
    int newId = fichas.isNotEmpty ? fichas.last['id'] + 1 : 1;
    int doctorIndex = int.parse(selectedDoctor!) - 1;
    int pacienteIndex = int.parse(selectedPaciente!) - 1;
    int categoriaIndex = int.parse(selectedCategory!) - 1;

    setState(() {
      fichas.add({
        'id': newId,
        'doctor': {
          'idPersona': personas[doctorIndex]['idPersona'],
          'nombre': personas[doctorIndex]['nombre'],
          'apellido': personas[doctorIndex]['apellido'],
          'telefono': personas[doctorIndex]['telefono'],
          'email': personas[doctorIndex]['email'],
          'cedula': personas[doctorIndex]['cedula'],
          'isDoctor': personas[doctorIndex]['isDoctor'],
          'isEditing': false
        },
        'paciente': {
          'idPersona': personas[pacienteIndex]['idPersona'],
          'nombre': personas[pacienteIndex]['nombre'],
          'apellido': personas[pacienteIndex]['apellido'],
          'telefono': personas[pacienteIndex]['telefono'],
          'email': personas[pacienteIndex]['email'],
          'cedula': personas[pacienteIndex]['cedula'],
          'isDoctor': personas[pacienteIndex]['isDoctor'],
          'isEditing': false
        },
        'fecha': DateFormat('yyyy-MM-dd').format(selectedDate), // Format the date
        'hora': selectedTime,
        'categoria': {
          'id': categorias[int.parse(selectedCategory!) - 1]['id'],
          'descripcion': categorias[categoriaIndex]['descripcion'],
        },
        "motivoConsulta": selectedMotivo.text,
        "diagnostico": selectedDiagnostico.text,
      });

      selectedPaciente = null;
      selectedDoctor = null;
      selectedDate = DateTime.now();
      selectedTime = null;
      selectedCategory = null;
      selectedMotivo.clear();
      selectedDiagnostico.clear();
    });

    _savefichas(); // Save changes to file
  }
}


  void _editTurno(int index) {
    DateTime EditedDate = selectedDate;
    String? EditedTime = selectedTime;
    String? EditedPaciente = selectedPaciente;
    String? EditedDoctor = selectedDoctor;
    String? EditedCategory = selectedCategory;
    TextEditingController EditedMotivo = TextEditingController(text: selectedMotivo.text);
    TextEditingController EditedDiagnostico = TextEditingController(text: selectedDiagnostico.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Turno'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
            value: EditedPaciente, // El valor seleccionado (inicialmente null)
            hint: const Text('Selecciona un paciente'), // Texto que se muestra cuando no se ha seleccionado nada
            items: _listaPersonas(false),
            onChanged: (String? newValue) {
                        setState(() {
                          if(newValue != null) {
                            EditedPaciente = newValue;
                          }
                        });
                      },
            ),
            DropdownButton<String>(
            value: EditedDoctor, // El valor seleccionado (inicialmente null)
            hint: const Text('Selecciona un doctor'), // Texto que se muestra cuando no se ha seleccionado nada
            items: _listaPersonas(true),
            onChanged: (String? newValue) {
                        setState(() {
                          if(newValue != null) {
                            EditedDoctor = newValue;
                          }
                        });
                      },
            ),
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

                if (pickedDate != null && pickedDate != EditedDate) {
                  setState(() {
                    EditedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(text: EditedDate.toLocal().toString().split(' ')[0]),
              readOnly: true,
            ),
            DropdownButton<String>(
              value: EditedTime,
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
                    EditedTime = value;
                  });
                }
              },
            ),
            DropdownButton<String>(
            value: EditedCategory, // El valor seleccionado (inicialmente null)
            hint: const Text('Selecciona una Categoria'), // Texto que se muestra cuando no se ha seleccionado nada
            items: _listaCategorias(),
            onChanged: (String? newValue) {
                        setState(() {
                          if(newValue != null) {
                            EditedCategory = newValue;
                          }
                        });
                      },
            ),
            TextField(
              controller: EditedMotivo,
              decoration: const InputDecoration(
                labelText: 'Motivo de la consulta',
              ),
            ),
            TextField(
              controller: EditedDiagnostico,
              decoration: const InputDecoration(
                labelText: 'Diagnostico',
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {

              EditedTime ??= selectedTime;
              EditedPaciente ??= selectedPaciente;
              EditedDoctor ??= selectedDoctor;
              EditedCategory ??= selectedCategory;

              setState(() {
                turnos[index] = {
                  'doctor': {
                    'idPersona': personas[int.parse(EditedDoctor!) - 1]['idPersona'],
                    'nombre': personas[int.parse(EditedDoctor!) - 1]['nombre'],
                    'apellido': personas[int.parse(EditedDoctor!) - 1]['apellido'],
                    'telefono': personas[int.parse(EditedDoctor!) - 1]['telefono'],
                    'email': personas[int.parse(EditedDoctor!) - 1]['email'],
                    'cedula': personas[int.parse(EditedDoctor!) - 1]['cedula'],
                    'isDoctor': personas[int.parse(EditedDoctor!) - 1]['isDoctor'],
                    'isEditing': false
                  },
                  'paciente': {
                    'idPersona': personas[int.parse(EditedPaciente!) - 1]['idPersona'],
                    'nombre': personas[int.parse(EditedPaciente!) - 1]['nombre'],
                    'apellido': personas[int.parse(EditedPaciente!) - 1]['apellido'],
                    'telefono': personas[int.parse(EditedPaciente!) - 1]['telefono'],
                    'email': personas[int.parse(EditedPaciente!) - 1]['email'],
                    'cedula': personas[int.parse(EditedPaciente!) - 1]['cedula'],
                    'isDoctor': personas[int.parse(EditedPaciente!) - 1]['isDoctor'],
                    'isEditing': false
                  },
                  // 'fecha' : selectedDate to string
                  'fecha': EditedDate.toString(),
                  'hora': EditedTime,
                  'categoria': {
                    'id': categorias[int.parse(EditedCategory!) - 1]['id'],
                    'descripcion': categorias[int.parse(EditedCategory!) - 1]['descripcion'],
                  },
                  "motivoConsulta": EditedMotivo.text,
                  "diagnostico": EditedDiagnostico.text,
                };
              });

              _savefichas(); // Save changes to file
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

  void _deleteFicha(int index) {
    setState(() {
      fichas.removeAt(index);
    });
    _savefichas(); // Save changes to file
  }
}
