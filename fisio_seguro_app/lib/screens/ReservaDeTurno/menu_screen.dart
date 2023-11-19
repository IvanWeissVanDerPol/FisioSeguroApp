
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisio_seguro_app/reusable_widgets/reusable_widget.dart';
import 'package:fisio_seguro_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TurnosMenu extends StatefulWidget {
  const TurnosMenu({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TurnosMenu createState() => _TurnosMenu();
}

class _TurnosMenu extends State<TurnosMenu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Snap Sale',
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
                  ActionCard(icon: Icons.edit_calendar_rounded,title: 'Registro de Productos', description: '', onTap: () { context.push('/ReservaDeTurnosFormScreen'); },),
                  const SizedBox(height: 20.0),
                 /*  ActionCard(icon: Icons.filter_alt_rounded,title: 'Lista de productos', description: '', onTap: () { context.push('/ReservaDeTurnosListScreen'); },),
                  const SizedBox(height: 20.0), */
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