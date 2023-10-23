// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ConsultasScreen(),
    );
  }
}

class ConsultasScreen extends StatefulWidget {
  const ConsultasScreen({super.key});

  @override
  _ConsultasScreenState createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends State<ConsultasScreen> {
  final ConsultaService consultaService = ConsultaService();

  Categoria newConsulta = Categoria(id: -1, descripcion: '', isEditing: false);
  List<Categoria> listaDeConsultas = [];

  TextEditingController idController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadConsultas();
  }

  void loadConsultas() {
    listaDeConsultas = consultaService.getConsultasSample();
  }

  void addConsulta() {
    setState(() {
      Categoria consulta = Categoria(
        id: int.parse(idController.text),
        descripcion: descripcionController.text,
        isEditing: false,
      );
      listaDeConsultas.add(consulta);
      // Clear the text fields
      idController.clear();
      descripcionController.clear();
    });
  }

  void editConsulta(Categoria consulta) {
    setState(() {
      consulta.isEditing = true;
    });
  }

  void updateConsulta(Categoria consulta, int index) {
    setState(() {
      listaDeConsultas[index] = consulta;
      consulta.isEditing = false;
    });
  }

  void deleteConsulta(int id) {
    setState(() {
      listaDeConsultas.removeWhere((consulta) => consulta.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categoria de Consultas'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulario
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'Id Categoría:',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción:',
              ),
            ),
            ElevatedButton(
              onPressed: addConsulta,
              child: const Text('Agregar Categoria'),
            ),
            // Tabla
            Expanded(
              child: ListView.builder(
                itemCount: listaDeConsultas.length,
                itemBuilder: (context, index) {
                  final consulta = listaDeConsultas[index];
                  return ListTile(
                    title: Text('Id: ${consulta.id}, Descripción: ${consulta.descripcion}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!consulta.isEditing)
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => editConsulta(consulta),
                          ),
                        if (consulta.isEditing)
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () => updateConsulta(consulta, index),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteConsulta(consulta.id),
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
}

class Categoria {
  bool isEditing;
  int id;
  String descripcion;

  Categoria({
    required this.isEditing,
    required this.id,
    required this.descripcion,
  });
}

class ConsultaService {
  List<Categoria> getConsultasSample() {
    // Suponiendo que tienes una lista inicial de consultas
    return [
      Categoria(id: 1, descripcion: 'Consulta 1', isEditing: false),
      Categoria(id: 2, descripcion: 'Consulta 2', isEditing: false),
      // ... otras consultas
    ];
  }
}
