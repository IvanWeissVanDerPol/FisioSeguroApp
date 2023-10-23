// lib/providers/physiotherapist_provider.dart
import 'package:fisio_seguro_app/models/physiotherapist.dart';
import 'package:flutter/material.dart';

class PhysiotherapistProvider with ChangeNotifier {
  Physiotherapist? _physiotherapist;

  Physiotherapist? get physiotherapist => _physiotherapist;

  set physiotherapist(Physiotherapist? value) {
    _physiotherapist = value;
    notifyListeners();
  }

  // Método para obtener datos de Firebase y actualizar el provider
  Future<void> fetchAndSetPhysiotherapist() async {
    // Suponiendo que ya has configurado Firebase y tienes una colección llamada 'physiotherapists'
    // final response = await FirebaseFirestore.instance.collection('physiotherapists').doc(userId).get();
    // _physiotherapist = Physiotherapist.fromMap(response.data() as Map<String, dynamic>);
    // notifyListeners();
  }
}
