// ignore: file_names
// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisio_seguro_app/reusable_widgets/reusable_widget.dart';
import 'package:fisio_seguro_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePatientScreen extends StatefulWidget {
  const HomePatientScreen({Key? key}) : super(key: key);

  @override
  _HomePatientScreenState createState() => _HomePatientScreenState();
}

class _HomePatientScreenState extends State<HomePatientScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fisio Seguro',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //decoration: AppDecorations.linearGradient,
        child:  SingleChildScrollView(
          child: Padding(
            padding: const  EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 const Text('Bienvenido al Sistema de Seguimiento de Pacientes'),
                 const SizedBox(height: 20.0),
                 //ActionCard(title: '', description: '', onTap: () {  },),
                  ActionCard(title: 'Consultas', description: 'Administrar Consultas', onTap: () { context.push('/ConsultasScreen'); },),
                  const SizedBox(height: 20.0),
                  ActionCard(title: 'Patient list', description: 'Patient List', onTap: () { context.push('/patient_List_Screen'); },),
                  const SizedBox(height: 20.0),
                  ActionCard(title: 'Evaluaciones', description: 'Administrar evaluaciones', onTap: () {  },),
                  const SizedBox(height: 20.0),
                  ActionCard(title: 'Reportes', description: 'Generar reportes', onTap: () {  },),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.exit_to_app),
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
          });
        },
      ),
    );
  }
}
