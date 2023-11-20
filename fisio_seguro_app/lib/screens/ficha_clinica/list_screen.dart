//file fisio_seguro_app/lib/screens/ficha_clinica/list_screen.dart
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


class ListaDeVentasScreen extends StatefulWidget {
  const ListaDeVentasScreen({Key? key}) : super(key: key);

  @override
  _ListaDeVentasScreenState createState() =>_ListaDeVentasScreenState();
}

class _ListaDeVentasScreenState extends State<ListaDeVentasScreen> {
  List<Map<String, dynamic>> turnos = [];
  List<Map<String, dynamic>> productos = [];
  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> originalTurnos = [];
  List<Map<String, dynamic>> ventas = [];
  List<Map<String, dynamic>> originalVentas = [];
  DateTime selectedDateStart = DateTime.now();
  DateTime selectedDateEnd = DateTime.now();
  String? selectedCliente;
  String? selectedDoctor;
  late String filePathVenta;

  @override
  void initState() {
    super.initState();
    
    _initialize('ventas');
    _initialize('categories');
    _initialize('productos');
    // _initialize('turnos');
  }

  Future<void> _savefichas() async {
    final File file = File(filePathVenta);
    final String data = json.encode(ventas);
    await file.writeAsString(data);
  }

  void _filter() {
  DateTime selectedDateEndFilter = DateTime(selectedDateEnd.year, selectedDateEnd.month, selectedDateEnd.day, 23, 59, 59);
  DateTime selectedDateStartFilter = DateTime(selectedDateStart.year, selectedDateStart.month, selectedDateStart.day);

  // Filtering based on the selected date range
  List<Map<String, dynamic>> filteredList = originalVentas.where((venta) {
    DateTime saleDate = DateTime.parse(venta['header']['date']);
    return saleDate.isAfter(selectedDateStartFilter) && saleDate.isBefore(selectedDateEndFilter);
  }).toList();

  setState(() {
    ventas = filteredList;
  });
}


  Future<void> _initialize(String objeto) async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$objeto.json';
    if (objeto == 'ventas') {
      filePathVenta = filePath;
    }
    final File file = File(filePath);
    final String jsonString = await rootBundle.loadString('assets/$objeto.json');
    await file.writeAsString(jsonString);
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
        originalVentas = loadedData;
        _filter();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ventas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter), // Icono para el botón de filtrar
                    SizedBox(width: 8), // Espacio entre el icono y el texto
                    Text('Filtrar'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _exportToPDF,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf), // Icono para el botón de PDF
                  SizedBox(width: 8),
                  Text('PDF'),
                ],
              ),
              ),
              ElevatedButton(
                onPressed: _exportToExcel,
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.table_chart), // Icono para el botón de Excel
                      SizedBox(width: 8),
                      Text('Excel'),
                    ],
                  ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: ventas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        'Cabezera: ${ventas[index]['header']['saleId']} ${ventas[index]['header']['invoiceNumber']} ${ventas[index]['header']['date']} ${ventas[index]['header']['total']}'),                                            );
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
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.RichText(
        text: pw.TextSpan(
          style: const pw.TextStyle(
            fontSize: 14,
            color: PdfColors.black,
          ),
          children: [
            pw.TextSpan(
              text: label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: '\n$value'),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToPDF() async {
    await requestStoragePermission();
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Fichas Clínicas'),
            ),
            pw.Table.fromTextArray(
              border: null,
              headers: ['saleId', 'invoiceNumber', 'date', 'total'],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold), // Añadir estilo a los encabezados
              cellAlignments: {
                0: pw.Alignment.centerLeft, 
                1: pw.Alignment.centerLeft,
              },
              cellStyle: const pw.TextStyle(
                fontSize: 10, 
              ),
              cellPadding: const pw.EdgeInsets.all(5), // Ajustar el relleno de la celda
              data: [
                for (final venta in ventas)
                  [
                    '${venta['paciente']['nombre']} ${venta['paciente']['apellido']}',
                    '${venta['doctor']['nombre']} ${venta['doctor']['apellido']}',
                    (DateFormat('dd-MM-yyyy').format(DateTime.parse(venta['fecha']))),
                    '${venta['hora']}',
                    '${venta['categoria']['descripcion']}',
                    '${venta['motivoConsulta']}',
                    '${venta['diagnostico']}',
                  ],
              ],
            ),
          ];
        },
      ),
    );
    final directory = await getExternalStorageDirectory();
    final path = directory?.path ?? (await getApplicationDocumentsDirectory()).path;
    final file = File('$path/fichas.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  Future<void> _exportToExcel() async {
    await requestStoragePermission();
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    sheetObject.cell(CellIndex.indexByString("A1")).value = 'Cliente';
    sheetObject.cell(CellIndex.indexByString("B1")).value = 'Doctor';
    sheetObject.cell(CellIndex.indexByString("C1")).value = 'Fecha';
    sheetObject.cell(CellIndex.indexByString("D1")).value = 'Hora';
    sheetObject.cell(CellIndex.indexByString("E1")).value = 'Categoria';
    sheetObject.cell(CellIndex.indexByString("F1")).value = 'Motivo';
    sheetObject.cell(CellIndex.indexByString("G1")).value = 'Diagnostico';

    for (var i = 0; i < ventas.length; i++) {
      var ficha = ventas[i];
      sheetObject.cell(CellIndex.indexByString("A${i + 2}")).value =
          '${ficha['paciente']['nombre']} ${ficha['paciente']['apellido']}';
      sheetObject.cell(CellIndex.indexByString("B${i + 2}")).value =
          '${ficha['doctor']['nombre']} ${ficha['doctor']['apellido']}';
      sheetObject.cell(CellIndex.indexByString("C${i + 2}")).value =
          (DateFormat('dd-MM-yyyy').format(DateTime.parse(ficha['fecha'])));
      sheetObject.cell(CellIndex.indexByString("D${i + 2}")).value =
          '${ficha['hora']}';
      sheetObject.cell(CellIndex.indexByString("E${i + 2}")).value =
          '${ficha['categoria']['descripcion']}';
      sheetObject.cell(CellIndex.indexByString("F${i + 2}")).value =
          '${ficha['motivoConsulta']}';
      sheetObject.cell(CellIndex.indexByString("G${i + 2}")).value = 
          '${ficha['diagnostico']}';
          
          

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
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    } else {
      // Manejar el caso en que bytes es nulo
    }
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

}
