// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ConsultaScreen extends StatefulWidget {
  const ConsultaScreen({super.key});

  @override
  _ConsultaScreenState createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  List<Map<String, dynamic>> categories = [];

  // Controllers for form inputs
  late String filePath;
  TextEditingController idController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFilePath();
  }

  Future<void> _saveCategories() async {
    final File file = File(filePath);
    final String data = json.encode(categories);
    await file.writeAsString(data);
  }

  Future<void> _initializeFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    filePath = '${directory.path}/categories.json';

    final File file = File(filePath);
/*      final String jsonString = await rootBundle.loadString('assets/categories.json');
      await file.writeAsString(jsonString);  */
    if (!await file.exists()) {
      final String jsonString = await rootBundle.loadString('assets/categories.json');
      await file.writeAsString(jsonString);
    }

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    if (filePath.isEmpty) return;

    final File file = File(filePath);
    final data = await file.readAsString();
    final List<Map<String, dynamic>> loadedCategories = List.from(json.decode(data));
    loadedCategories.sort((a, b) => a['id'].compareTo(b['id']));

    setState(() {
      categories = loadedCategories;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categoria de productos')),
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
                labelText: 'Nombre',
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
                    subtitle: Text('Nombre: ${categories[index]['Nombre']}'),
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
      int newId = int.parse(idController.text);
      // Check if ID already exists
      bool idExists = categories.every((category) => category['id'] == newId);

      if (idExists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ya existe una categoria con ese ID')));
        return;
      }

      setState(() {
        categories.add({'id': newId, 'Nombre': descripcionController.text});
        categories.sort((a, b) => a['id'].compareTo(b['id']));

        idController.clear();
        descripcionController.clear();
      });

      _saveCategories(); // Save changes to file
    }
  }

  void _editCategory(int index) {
  final TextEditingController idEditController = TextEditingController(text: categories[index]['id'].toString());
  final TextEditingController descripcionEditController = TextEditingController(text: categories[index]['Nombre']);

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
              labelText: 'ID',
            ),
          ),
          TextField(
            controller: descripcionEditController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
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
            if (categories.where((category) => category['id'] == newId && categories.indexOf(category) != index).isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ya existe una categoria con ese ID')));
              return;
            }

            setState(() {
              categories[index] = {
                'id': newId,
                'Nombre': newDescripcion,
              };
              categories.sort((a, b) => a['id'].compareTo(b['id']));
            });

            _saveCategories(); // Save changes to file
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
      categories.removeAt(index);
    });
    _saveCategories(); // Save changes to file
  }
}
