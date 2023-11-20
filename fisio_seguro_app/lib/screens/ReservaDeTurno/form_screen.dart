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
  List<Map<String, dynamic>> productos = [];//productos
  //List<Map<String, dynamic>> personas = [];//clientes del producto
  List<Map<String, dynamic>> categorias = [];//categorias del producto
  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  String? selectedCliente;
  String? selectedDoctor;
  String? selectedCategory;
  late String filePathTurno;
  
  TextEditingController codigoController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioVentaCoantroller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _initialize('categories');
    _initialize('productos');
  }

  Future<void> _saveturnos() async {
    final File file = File(filePathTurno);
    final String data = json.encode(productos);
    await file.writeAsString(data);
  }

//si el archivo no existe, lo crea y lo llena con el contenido del archivo persons.json
// si el archivo existe, lo carga
  Future<void> _initialize(String objeto) async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$objeto.json';
     if (objeto == 'productos') {
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
      }  else if (objeto == 'productos') {
        productos = loadedData;
      }
    });
  }

  List<DropdownMenuItem<String>> _listaCategorias() {
    List<DropdownMenuItem<String>> listaCategorias = categorias
      .map((categoria) {
        String nombre = categoria['Nombre'];
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
      appBar: AppBar(title: const Text('Administracion de productos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: codigoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Codigo',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: precioVentaCoantroller,
              decoration: const InputDecoration(
                labelText: 'Precio de venta',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
            value: selectedCategory, // El valor seleccionado (inicialmente null)
            hint: const Text('Selecciona una Categoria'), // Texto que se muestra cuando no se ha seleccionado nada
            items: _listaCategorias(),
            onChanged: (String? newValue) {
                        setState(() {
                          if(newValue != null) {
                            selectedCategory = newValue;
                          }
                        });
                      },
            ),
          ElevatedButton(
            onPressed: _addTurno,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today), // Icono para el botón de agendar reserva
                SizedBox(width: 8),
                Text('Agregar producto'),
              ],
            ),
          ),
            const SizedBox(height: 20),
            // Table to display productos
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('nombreProducto: ${productos[index]['nombreProducto']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Código: ${productos[index]['codigoProducto']}'),
                        Text('Categoría: ${categorias.firstWhere((categoria) => categoria['id'] == productos[index]['idCategoria'])['Nombre']}'),
                        Text('Precio de venta: ${productos[index]['precioVenta']}'),
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

  void _addTurno() {
    if (/* selectedCliente != null && selectedDoctor != null && selectedTime != null */ selectedCategory != null) {
      int newId =  productos.isNotEmpty ? productos.last['id'] + 1 : 1;
      
      setState(() {
        productos.add({
          'id': newId,
          'codigoProducto': codigoController.text,
          'nombreProducto': nombreController.text,
          'precioVenta': precioVentaCoantroller.text,
          'idCategoria': categorias[int.parse(selectedCategory!)-1]['id'],
        });

        codigoController.clear();
        nombreController.clear();
        precioVentaCoantroller.clear();
        selectedCategory = null;
      });

      _saveturnos(); // Save changes to file
    }
  }
}
