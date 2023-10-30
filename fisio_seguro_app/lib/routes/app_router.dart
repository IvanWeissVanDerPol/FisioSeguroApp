import 'package:fisio_seguro_app/screens/RegistroDePersona/registratio_form_screen.dart';
import 'package:fisio_seguro_app/screens/RegistroDePersona/RegistroDePersonas_Screen.dart';
import 'package:fisio_seguro_app/screens/RegistroDePersona/lista_de_personas_screen.dart';
import 'package:fisio_seguro_app/screens/RegistroDePersona/person_registry_screen.dart';
import 'package:fisio_seguro_app/screens/ReservaDeTurno/form_screen.dart';
import 'package:fisio_seguro_app/screens/ReservaDeTurno/menu_screen.dart';
import 'package:fisio_seguro_app/screens/auth/main_screen.dart';
import 'package:fisio_seguro_app/screens/consulta/consulta_screen.dart';
import 'package:fisio_seguro_app/screens/home/home_screen.dart';

import 'package:fisio_seguro_app/screens/home/log_out_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fisio_seguro_app/screens/auth/login_screen.dart';
import 'package:fisio_seguro_app/screens/auth/reset_password.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(child: MainScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/reset_password',
        pageBuilder: (context, state) => const MaterialPage(child: ResetPassword()),
      ),

      GoRoute(
        path: '/LogOut',
        pageBuilder: (context, state) => const MaterialPage(child: LogOutScreen()),
      ),

      GoRoute(
        path: '/Home',
        pageBuilder: (context, state) => const MaterialPage(child: HomeScreen()),
      ),

      GoRoute(
        path: '/RegistroDePersonasScreen',
        pageBuilder: (context, state) => const MaterialPage(child: RegistroDePersonasScreen()),
      ),
      GoRoute(
        path: '/ConsultasScreen',
        pageBuilder: (context, state) => const MaterialPage(child: ConsultaScreen()),
      ),
      GoRoute(
        path: '/PersonRegistryScreen',
        pageBuilder: (context, state) => const MaterialPage(child: PersonRegistryScreen()),
      ),
      GoRoute(
        path: '/ListaDePersonasScreen',
        pageBuilder: (context, state) => const MaterialPage(child: ListaDePersonasScreen()),
      ),
      GoRoute(
        path: '/RegisterPersonScreen',
        pageBuilder: (context, state) => const MaterialPage(child: RegistrationFormScreen()),
      ),
      GoRoute(path: '/ReservaDeTurnosMenuScreen',
      pageBuilder: (context, state) =>  const MaterialPage(child: TurnosMenu()),
      ),
      GoRoute(path: '/ReservaDeTurnosScreen',
      pageBuilder: (context, state) =>  const MaterialPage(child: ReservaDeTurnosScreen()),
      ),
      // GoRoute(path: '/FichaClinicaScreen',
      // pageBuilder: (context, state) =>  const MaterialPage(child: PersonRegistryScreen()),
      // ),
    ],
  );
}
