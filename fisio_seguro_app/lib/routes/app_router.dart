import 'package:fisio_seguro_app/screens/Physiotherapist/PatientAdministration/patient_list_screen.dart';
import 'package:fisio_seguro_app/screens/consulta/consulta_screen.dart';
import 'package:fisio_seguro_app/screens/auth/main_screen.dart';
import 'package:fisio_seguro_app/screens/home/home_patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fisio_seguro_app/screens/auth/login_screen.dart';
import 'package:fisio_seguro_app/screens/auth/reset_password.dart';
import 'package:fisio_seguro_app/screens/home/home_physiotherapist_screen.dart';



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
        path: '/home_physiotherapists',
        pageBuilder: (context, state) => const MaterialPage(child: HomePhysiotherapistsScreen()),
      ),
      GoRoute(
        path: '/home_patient',
        pageBuilder: (context, state) =>  const MaterialPage(child: HomePatientScreen()),
      ),
      GoRoute(path: '/ConsultasScreen',
      pageBuilder: (context, state) =>  const MaterialPage(child: ConsultasScreen()),
      ),
      GoRoute(path: '/patient_List_Screen',
      pageBuilder: (context, state) =>  const MaterialPage(child: PatientListScreen()),
      ),
    ],
  );
}