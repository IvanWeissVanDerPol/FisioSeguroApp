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
  TextEditingController? idController = TextEditingController();
  TextEditingController? facturaController = TextEditingController();
  TextEditingController? totalController = TextEditingController();
  TextEditingController? codigoProductoController = TextEditingController();
  TextEditingController? cantidadProductoController = TextEditingController();

  late String filePathVentas;

  @override
  void initState() {
    super.initState();
    _initialize('categories');
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
      } else if (objeto == 'productos') {
        productos = loadedData;
      } else if (objeto == 'ventas') {
        ventas = loadedData;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('registro de ventas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Id Venta',
              ),
            ),
            TextField(
              controller: facturaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Numero de factura',
              ),
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
            TextField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total',
              ),
            ),
            TextField(
              controller: codigoProductoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'codigo de producto',
              ),
            ),
            TextField(
              controller: cantidadProductoController,
              keyboardType: TextInputType.number,
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
          ],
        ),
      ),
    );
  }

void _addFicha() {
  if (idController!.text.isNotEmpty && facturaController!.text.isNotEmpty && totalController!.text.isNotEmpty && codigoProductoController!.text.isNotEmpty && cantidadProductoController!.text.isNotEmpty) {
    int newId = int.parse(idController!.text);    


    // Check if ID already exists
    bool idExists = ventas.every((venta) => venta['header']['SaleId'] == newId);

    if (idExists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ya existe una venta con ese ID')));
      return;
    }

    // check if factura already exists
    bool facturaExists = ventas.every((venta) => venta['header']['factura'] == facturaController!.text);

    if (facturaExists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ya existe una factura con ese ID')));
      return;
    }

    setState(() {
      ventas.add({
        'header': {
          "saleId": newId,
          "factura": facturaController!.text,
          "date": selectedDate,
          "total": double.parse(totalController!.text),
        },
        'details': {
          "productId": int.parse(codigoProductoController!.text),
          "quantity": int.parse(cantidadProductoController!.text),
        }
        
      });

      selectedDate = DateTime.now();
      idController!.clear();
      facturaController!.clear();
      totalController!.clear();
      codigoProductoController!.clear();
      cantidadProductoController!.clear();

    });

    _saveVentas(); // Save changes to file
  }
}

}
