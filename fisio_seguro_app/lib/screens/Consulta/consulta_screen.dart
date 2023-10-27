// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ConsultaScreen extends StatefulWidget {
  const ConsultaScreen({super.key});

  @override
  _ConsultaScreenState createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  // Mock data
  List<Map<String, dynamic>> categories = [
    {'id': 1, 'descripcion': 'Cardiología'},
    {'id': 2, 'descripcion': 'Dermatología'},
    // ... add more categories as needed
  ];

  // Controllers for form inputs
  TextEditingController idController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categoria de Consultas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form for adding new category
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Id Categoría',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addCategory,
              child: const Text('Agregar Categoria'),
            ),
            const SizedBox(height: 20),
            // Table to display categories
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Id: ${categories[index]['id']}'),
                    subtitle: Text('Descripción: ${categories[index]['descripcion']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editCategory(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCategory(index),
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

  void _addCategory() {
    if (idController.text.isNotEmpty && descripcionController.text.isNotEmpty) {
      setState(() {
        categories.add({
          'id': int.parse(idController.text),
          'descripcion': descripcionController.text
        });
        idController.clear();
        descripcionController.clear();
      });
    }
  }

  void _editCategory(int index) {
    // Function to handle category editing (can be implemented further based on requirements)
  }

  void _deleteCategory(int index) {
    setState(() {
      categories.removeAt(index);
    });
  }
}
