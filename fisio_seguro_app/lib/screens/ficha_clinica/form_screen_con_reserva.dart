import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';


class FichaClinicaFormScreenConReserva extends StatefulWidget {
  const FichaClinicaFormScreenConReserva({super.key});

  @override
  _FichaClinicaFormScreenConReserva createState() => _FichaClinicaFormScreenConReserva();
}

class _FichaClinicaFormScreenConReserva extends State<FichaClinicaFormScreenConReserva> {
  List<Map<String, dynamic>> turnos = [];
/*   List<Map<String, dynamic>> personas = [];
  List<Map<String, dynamic>> categorias = []; */
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
/*       if (objeto == 'categories') {
        categorias = loadedData;
      } else if (objeto == 'persons') {
        personas = loadedData;
      } else  */if (objeto == 'turnos') {
        turnos = loadedData;
      } else if (objeto == 'fichasClinicas') {
        fichas = loadedData;
      }
    });
  }

List<DropdownMenuItem<String>> _listaTurnos() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reserva de fichas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedTurnos,
                hint: const Text('Selecciona una reserva de turno'),
                items: _listaTurnos(),
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      selectedTurnos = newValue;
                      selectedPaciente = turnos[int.parse(selectedTurnos!) - 1]['paciente']['idPersona'].toString();
                      selectedDoctor = turnos[int.parse(selectedTurnos!) - 1]['doctor']['idPersona'].toString();
                      selectedCategory = turnos[int.parse(selectedTurnos!) - 1]['categoria']['id'].toString();
                      selectedDate = DateTime.parse(turnos[int.parse(selectedTurnos!) - 1]['fecha']);
                      selectedTime = turnos[int.parse(selectedTurnos!) - 1]['hora'];
                    }
                  });
                },
              ),
            ),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description), // Icono para el botón de agregar ficha clínica
                  SizedBox(width: 8),
                  Text('Agregar Ficha Clínica'),
                ],
              ),
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

    setState(() {
      fichas.add({
        'id': newId,
        'doctor': {
          'idPersona': turnos[int.parse(selectedTurnos!) - 1]['doctor']['idPersona'],
          'nombre': turnos[int.parse(selectedTurnos!) - 1]['doctor']['nombre'],
          'apellido': turnos[int.parse(selectedTurnos!) - 1]['doctor']['apellido'],
          'RUC': turnos[int.parse(selectedTurnos!) - 1]['doctor']['RUC'],
          'email': turnos[int.parse(selectedTurnos!) - 1]['doctor']['email'],
          'cedula': turnos[int.parse(selectedTurnos!) - 1]['doctor']['cedula'],
          'isDoctor': turnos[int.parse(selectedTurnos!) - 1]['doctor']['isDoctor'],
          'isEditing': false
        },
        'paciente': {
          'idPersona': turnos[int.parse(selectedTurnos!) - 1]['paciente']['idPersona'],
          'nombre': turnos[int.parse(selectedTurnos!) - 1]['paciente']['nombre'],
          'apellido': turnos[int.parse(selectedTurnos!) - 1]['paciente']['apellido'],
          'RUC': turnos[int.parse(selectedTurnos!) - 1]['paciente']['RUC'],
          'email': turnos[int.parse(selectedTurnos!) - 1]['paciente']['email'],
          'cedula': turnos[int.parse(selectedTurnos!) - 1]['paciente']['cedula'],
          'isDoctor': turnos[int.parse(selectedTurnos!) - 1]['paciente']['isDoctor'],
          'isEditing': false
        },
        // 'fecha': DateFormat('yyyy-MM-dd').format(selectedDate),
        'fecha': DateFormat('yyyy-MM-dd').format(selectedDate),
        'hora': selectedTime,
        'categoria': {
          'id': turnos[int.parse(selectedTurnos!) - 1]['categoria']['id'],
          'descripcion': turnos[int.parse(selectedTurnos!) - 1]['categoria']['descripcion'],
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

}
