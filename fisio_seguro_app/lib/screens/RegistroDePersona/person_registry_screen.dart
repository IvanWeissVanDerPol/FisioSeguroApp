
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisio_seguro_app/reusable_widgets/reusable_widget.dart';
import 'package:fisio_seguro_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PersonRegistryScreen extends StatefulWidget {
  const PersonRegistryScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PersonRegistryScreenState createState() => _PersonRegistryScreenState();
}

class _PersonRegistryScreenState extends State<PersonRegistryScreen> {

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
                  ActionCard(icon: Icons.auto_stories,title: 'Registro de Personas', description: '', onTap: () { context.push('/RegisterPersonScreen'); },),
                  const SizedBox(height: 20.0),
                  ActionCard(icon: Icons.auto_stories,title: 'Lista De Pacientes', description: '', onTap: () { context.push('/ListaDePersonasScreen'); },),
                  const SizedBox(height: 20.0),
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