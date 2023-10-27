import 'package:flutter/material.dart';
import 'person_widgets.dart'; // Import the PersonWidgets mixin

class ListaDePersonasScreen extends StatefulWidget {
  const ListaDePersonasScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PersonRegistryState createState() => _PersonRegistryState();
}

class _PersonRegistryState extends State<ListaDePersonasScreen> with PersonWidgets<ListaDePersonasScreen> { // Use the mixin here
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person Registry'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: sortColumnIndex,
            sortAscending: sortAscending,
            columns: getColumns(),  // Use the methods from the mixin
            rows: getRows(),
          ),
        ),
      ),
    );
  }
}
