import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class ListaDeFichasClinicasScreen extends StatefulWidget {
  const ListaDeFichasClinicasScreen({Key? key}) : super(key: key);

  @override
  _ListaDeFichasClinicasScreenState createState() =>_ListaDeFichasClinicasScreenState();
}

class _ListaDeFichasClinicasScreenState extends State<ListaDeFichasClinicasScreen> {
  List<Map<String, dynamic>> turnos = [];
  List<Map<String, dynamic>> personas = [];
  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> originalTurnos = [];
  List<Map<String, dynamic>> fichasClinicas = [];
  List<Map<String, dynamic>> originalFichasClinicas = [];
  DateTime selectedDateStart = DateTime.now();
  DateTime selectedDateEnd = DateTime.now();
  String? selectedPaciente;
  String? selectedDoctor;
  late String filePathFichaClinica;

  @override
  void initState() {
    super.initState();
    _initialize('categories');
    _initialize('persons');
    _initialize('turnos');
    _initialize('fichasClinicas');
  }

  Future<void> _savefichas() async {
    final File file = File(filePathFichaClinica);
    final String data = json.encode(fichasClinicas);
    await file.writeAsString(data);
  }

  void _filter() {
    List<Map<String, dynamic>> filteredList = originalFichasClinicas;

    if (selectedDoctor != null) {
      filteredList = filteredList
          .where((fichaClinica) =>
              fichaClinica['doctor']['idPersona'] == int.parse(selectedDoctor!))
          .toList();
    }
    if (selectedPaciente != null) {
      filteredList = filteredList
          .where((fichaClinica) =>
              fichaClinica['paciente']['idPersona'] == int.parse(selectedPaciente!))
          .toList();
    }

    DateTime selectedDateEndFilter =DateTime(
      selectedDateEnd.year, selectedDateEnd.month, selectedDateEnd.day, 23, 59, 59);
    DateTime selectedDateStartFilter = DateTime(
        selectedDateStart.year, selectedDateStart.month, selectedDateStart.day);
    filteredList = filteredList
        .where((fichaClinica) =>
            DateTime.parse(fichaClinica['fecha']).isAfter(selectedDateStartFilter) ||
            DateTime.parse(fichaClinica['fecha']).isAtSameMomentAs(selectedDateStartFilter))
        .toList();
    filteredList = filteredList
        .where((fichaClinica) =>
            DateTime.parse(fichaClinica['fecha']).isBefore(selectedDateEndFilter) ||
            DateTime.parse(fichaClinica['fecha']).isAtSameMomentAs(selectedDateEndFilter))
        .toList();

    setState(() {
      fichasClinicas = filteredList;
    });
  }

  Future<void> _initialize(String objeto) async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$objeto.json';
    if (objeto == 'fichasClinicas') {
      filePathFichaClinica = filePath;
    }
    final File file = File(filePath);

    if (!await file.exists()) {
      final String jsonString = 
        await rootBundle.loadString('assets/$objeto.json');
      await file.writeAsString(jsonString);
    }

    final data = await file.readAsString();
    final List<Map<String, dynamic>> loadedData = List.from(json.decode(data));
    setState(() {
      if (objeto == 'categories') {
        categorias = loadedData;
      } else if (objeto == 'persons') {
        personas = loadedData;
      } else if (objeto == 'fichasClinicas') {
        originalFichasClinicas = loadedData;
        _filter();
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
    }).toList();
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
    }).toList();
    return listaCategorias;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ficha Clínicas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedPaciente,
                hint: const Text('Selecciona un paciente'),
                items: _listaPersonas(false),
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      selectedPaciente = newValue;
                    }
                  });
                },
              ),
              DropdownButton<String>(
                value: selectedDoctor,
                hint: const Text('Selecciona un doctor'),
                items: _listaPersonas(true),
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      selectedDoctor = newValue;
                    }
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Desde',
                ),
                onTap: () async {
                  DateTime? pickedDateStart = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDateStart != null &&
                      pickedDateStart != selectedDateStart) {
                    setState(() {
                      selectedDateStart = pickedDateStart;
                    });
                  }
                },
                controller: TextEditingController(
                    text: selectedDateStart.toLocal().toString().split(' ')[0]),
                readOnly: true,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Hasta',
                ),
                onTap: () async {
                  DateTime? pickedDateEnd = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDateEnd != null &&
                      pickedDateEnd != selectedDateEnd) {
                    setState(() {
                      selectedDateEnd = pickedDateEnd;
                    });
                  }
                },
                controller: TextEditingController(
                    text: selectedDateEnd.toLocal().toString().split(' ')[0]),
                readOnly: true,
              ),
              ElevatedButton(
                onPressed: _filter,
                child: const Text('Filtrar'),
              ),
              ElevatedButton(
                onPressed: _exportToPDF,
                child: const Text('PDF'),
              ),
              ElevatedButton(
                onPressed: _exportToExcel,
                child: const Text('Excel'),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: fichasClinicas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        'Paciente: ${fichasClinicas[index]['paciente']['nombre']} ${fichasClinicas[index]['paciente']['apellido']}'),
                    subtitle: Text(
                        'Doctor: ${fichasClinicas[index]['doctor']['nombre']} ${fichasClinicas[index]['doctor']['apellido']}\nFecha: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(fichasClinicas[index]['fecha']))}\t${fichasClinicas[index]['hora']}\nCategoria: ${fichasClinicas[index]['categoria']['descripcion']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editaFicha(index),
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
            ],
          ),
        ),
      ),
    );
  }

  pw.Widget _buildText(String label, String value) {
    return pw.Container(
      margin: pw.EdgeInsets.only(bottom: 10),
      child: pw.RichText(
        text: pw.TextSpan(
          style: pw.TextStyle(
            fontSize: 14,
            color: PdfColors.black,
          ),
          children: [
            pw.TextSpan(
              text: '$label',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: '\n$value'),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToPDF() async {
    print("entre");
    await requestStoragePermission();
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 20),
              pw.Text(
                'Fichas Clínicas',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              for (final ficha in fichasClinicas)
                pw.Container(
                  margin: pw.EdgeInsets.only(bottom: 20),
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildText('Paciente: ', '${ficha['paciente']['nombre']} ${ficha['paciente']['apellido']}'),
                      _buildText('Doctor: ', '${ficha['doctor']['nombre']} ${ficha['doctor']['apellido']}'),
                      _buildText('Fecha: ', '${DateFormat('dd-MM-yyyy').format(DateTime.parse(ficha['fecha']))} ${ficha['hora']}'),
                      _buildText('Categoria: ', '${ficha['categoria']['descripcion']}'),
                      _buildText('Motivo: ', '${ficha['motivoConsulta']}'),
                      _buildText('Diagnóstico: ', '${ficha['diagnostico']}'),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
    final directory = await getExternalStorageDirectory();
    final path = directory?.path ?? (await getApplicationDocumentsDirectory()).path;
    final file = File('$path/fichas.pdf');
    print(file.path);
    await file.writeAsBytes(await pdf.save());
  }

  Future<void> _exportToExcel() async {
    print("entre");
    await requestStoragePermission();
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    for (var i = 0; i < turnos.length; i++) {
      var turno = turnos[i];
      sheetObject.cell(CellIndex.indexByString("A${i + 1}")).value =
          '${turno['paciente']['nombre']} ${turno['paciente']['apellido']}';
      // Agrega más celdas según sea necesario
    }

    //final directory = await getApplicationDocumentsDirectory();
    //final file = File('${directory.path}/turnos.xlsx');
    final directory =
        await getExternalStorageDirectory(); // Obtiene la carpeta de descargas
    final path =
        directory?.path ?? (await getApplicationDocumentsDirectory()).path;
    final file = File('$path/fichas.xlsx');
    //await file.writeAsBytes(excel.save());
    // Asegúrate de que el resultado de save() no sea nulo
    final bytes = await excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    } else {
      // Manejar el caso en que bytes es nulo
      print("No se pudo generar el archivo Excel");
    }
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  void _editaFicha(int index) {
    DateTime EditedDate = DateTime.parse(fichasClinicas[index]['fecha']);
    String? EditedTime = fichasClinicas[index]['hora'];
    String? EditedPaciente = fichasClinicas[index]['paciente']['idPersona'];
    String? EditedDoctor = fichasClinicas[index]['doctor']['idPersona'];
    String? EditedCategory = fichasClinicas[index]['categoria']['id'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editat Ficha Clinica'),
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
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                fichasClinicas[index] = {
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
                  }
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
      fichasClinicas.removeAt(index);
    });
    _savefichas(); // Save changes to file
  }
}
