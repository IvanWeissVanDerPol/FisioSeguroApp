// ignore: file_names
// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisio_seguro_app/reusable_widgets/reusable_widget.dart';
import 'package:fisio_seguro_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
      body: BackgroundGradient(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
          child: Padding(
            padding: const  EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 const Text('Bienvenido al Sistema de Seguimiento de Pacientes'),
                 const SizedBox(height: 20.0),
                 //ActionCard(title: '', description: '', onTap: () {  },),
                  ActionCard(icon: Icons.auto_stories,title: 'Categoria de Consultas', description: 'Se puede agregar, modificar o eliminar la categoria de las consultas.', onTap: () { context.push('/ConsultasScreen'); },),
                  const SizedBox(height: 20.0),
                  ActionCard(icon: Icons.app_registration, title: 'Registro De Personas', description: 'Accede al registro de personas donde se puede crear un nuevo persona o modificar uno ya existente, Tambien se le asigna si es doctor o paciente.', onTap: () { context.push('/PersonRegistryScreen'); },),
                  const SizedBox(height: 20.0),
                  ActionCard(icon: Icons.mode_edit,title: 'Reserva de Turnos', description: 'Accede a la reserva de turnos para agregar o modificar un turno, tambien se puede indicar a que hora se tendra el turno.', onTap: () {context.push('/ReservaDeTurnosScreen');  },),
                  const SizedBox(height: 20.0),
                  ActionCard(icon: Icons.view_list,title: 'Ficha Clinica', description: 'Accede a la ficha clinica para agregar o modificar la ficha, tambien se puede hacer un reporte en excel o pdf.', onTap: () {  },),
             ],
              ),
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