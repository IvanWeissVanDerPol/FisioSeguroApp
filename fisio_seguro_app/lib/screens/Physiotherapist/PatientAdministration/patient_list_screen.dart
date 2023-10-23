// Archivo: lib/screens/patient_list_screen.dart

import 'package:fisio_seguro_app/screens/Physiotherapist/PatientAdministration/patient_registration_screen.dart';
import 'package:flutter/material.dart';

class Patient {
  final int idPersona;
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final String cedula;
  final bool flag_es_doctor;

  Patient(this.idPersona, this.nombre, this.apellido, this.telefono, this.email, this.cedula, this.flag_es_doctor);
}

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({Key? key}) : super(key: key);

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<Patient> _allPatients = [
    Patient(1, 'John', 'Doe', '123456789', 'john.doe@example.com', '001-001', false),
    // ... otros pacientes
  ];

  List<Patient> _filteredPatients = [];
  String? _sortColumn;
  bool _sortAscending = true;


  @override
  void initState() {
    super.initState();
    _filteredPatients = _allPatients;
  }

  void _filterPatients(String query) {
    final List<Patient> filtered = _allPatients
        .where((patient) => patient.nombre.toLowerCase().contains(query.toLowerCase()) || patient.apellido.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredPatients = filtered;
    });
  }

  void _sort<T>(Comparable<T> Function(Patient p) getField, int columnIndex) {
    final isAscending = _sortColumn == columnIndex.toString() && _sortAscending;  // Modificado aquí
    _filteredPatients.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return isAscending ? Comparable.compare(bValue, aValue) : Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumn = columnIndex.toString();  // Modificado aquí
      _sortAscending = !isAscending;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar por nombre o apellido',
            border: InputBorder.none,
          ),
          onChanged: _filterPatients,
        ),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          sortColumnIndex: _sortColumn,
          sortAscending: _sortAscending,
          columns: const [
            DataColumn(label: Text('ID Persona'), numeric: true),
            DataColumn(label: Text('Nombre'), onSort: (int columnIndex, bool ascending) => _sort<String>((p) => p.nombre, columnIndex)),
            DataColumn(label: Text('Apellido'), onSort: (int columnIndex, bool ascending) => _sort<String>((p) => p.apellido, columnIndex)),
            DataColumn(label: Text('Telefono'), numeric: true),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Cedula')),
            DataColumn(label: Text('Es Doctor'), numeric: true),
            
          ],
          rows: _filteredPatients.map((Patient patient) {
            return DataRow(
              cells: [
                DataCell(Text('${patient.idPersona}')),
                DataCell(Text(patient.nombre)),
                DataCell(Text(patient.apellido)),
                DataCell(Text(patient.telefono)),
                DataCell(Text(patient.email)),
                DataCell(Text(patient.cedula)),
                DataCell(Text(patient.flag_es_doctor.toString())),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PatientRegistrationScreen()),
          );
        },
        tooltip: 'Agregar nuevo paciente',
        child: const Icon(Icons.add),
      ),
    );
  }
}
