//file fisio_seguro_app/lib/screens/RegistroDePersona/form_screen.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';


class VentaFormScreenSinReserva extends StatefulWidget {
  const VentaFormScreenSinReserva({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VentaFormScreenSinReserva createState() => _VentaFormScreenSinReserva();
}

class _VentaFormScreenSinReserva extends State<VentaFormScreenSinReserva> {
  List<Map<String, dynamic>> productos = [];
  List<Map<String, dynamic>> personas = [];
  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> ventas = [];
  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  String? selectedCliente;
  String? selectedDoctor;
  String? selectedCategory;
  String? selectedProductos;
  TextEditingController selectedMotivo = TextEditingController();
  TextEditingController selectedDiagnostico = TextEditingController();
  late String filePathVentas;

  @override
  void initState() {
    super.initState();
    _initialize('categories');
    _initialize('persons');
    _initialize('productos');
    _initialize('ventas');
  }

  Future<void> _saveVentas() async {
    final File file = File(filePathVentas);
    final String data = json.encode(ventas);
    await file.writeAsString(data);
  }

//si el archivo no existe, lo crea y lo llena con el contenido del archivo persons.json
// si el archivo existe, lo carga
  Future<void> _initialize(String objeto) async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$objeto.json';
    if (objeto == 'ventas') {
      filePathVentas = filePath;
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
      } else if (objeto == 'productos') {
        productos = loadedData;
      } else if (objeto == 'ventas') {
        ventas = loadedData;
      }
    });
  }

  List<DropdownMenuItem<String>> _listaPersonas(bool isDoctor) {
    List<DropdownMenuItem<String>> listaClientes = personas
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
    return listaClientes;
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
      appBar: AppBar(title: const Text('registro de ventas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            DropdownButton<String>(
            value: selectedCliente, // El valor seleccionado (inicialmente null)
            hint: const Text('Selecciona un cliente'), // Texto que se muestra cuando no se ha seleccionado nada
            items: _listaPersonas(false),
            onChanged: (String? newValue) {
                        setState(() {
                          if(newValue != null) {
                            selectedCliente = newValue;
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

                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(text: selectedDate.toLocal().toString().split(' ')[0]),
              readOnly: true,
            ),
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
            TextField(
              controller: selectedMotivo,
              decoration: const InputDecoration(
                labelText: 'codigo de producto',
              ),
            ),
            TextField(
              controller: selectedDiagnostico,
              decoration: const InputDecoration(
                labelText: 'cantidad',
              ),
            ),
            ElevatedButton(
              onPressed: _addFicha,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description), // Icono para el botón de agregar ficha clínica
                  SizedBox(width: 8),
                  Text('Agregar Venta'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Table to display ventas
            Expanded(
              child: ListView.builder(
                itemCount: ventas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Cliente: ${ventas[index]['cliente']['nombre']} ${ventas[index]['cliente']['apellido']}'),
                    subtitle: Text('Fecha: ${
                      DateFormat('dd-MM-yyyy').format(DateTime.parse(ventas[index]['fecha']))}\t${ventas[index]['hora']}\nCategoria: ${
                        ventas[index]['categoria']['descripcion']}\nMotivo: ${ventas[index]['motivoConsulta']}\nDiagnostico: ${ventas[index]['diagnostico']}'),
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
  if (selectedCliente != null &&
      selectedDoctor != null &&
      selectedCategory != null &&
      selectedTime != null &&
      selectedMotivo.text.isNotEmpty &&
      selectedDiagnostico.text.isNotEmpty) {
    int newId = ventas.isNotEmpty ? ventas.last['id'] + 1 : 1;
    int clienteIndex = int.parse(selectedCliente!) - 1;
    int categoriaIndex = int.parse(selectedCategory!) - 1;

    setState(() {
      ventas.add({
        'id': newId,
        'cliente': {
          'idPersona': personas[clienteIndex]['idPersona'],
          'nombre': personas[clienteIndex]['nombre'],
          'apellido': personas[clienteIndex]['apellido'],
          'RUC': personas[clienteIndex]['RUC'],
          'email': personas[clienteIndex]['email'],
          'cedula': personas[clienteIndex]['cedula'],
          'isDoctor': personas[clienteIndex]['isDoctor'],
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

      selectedCliente = null;
      selectedDoctor = null;
      selectedDate = DateTime.now();
      selectedTime = null;
      selectedCategory = null;
      selectedMotivo.clear();
      selectedDiagnostico.clear();
    });

    _saveVentas(); // Save changes to file
  }
}

}
