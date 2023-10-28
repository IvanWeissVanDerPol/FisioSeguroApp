import 'package:flutter/material.dart';

class ReservaDeTurnosScreen extends StatefulWidget {
  const ReservaDeTurnosScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReservaDeTurnosScreenState createState() => _ReservaDeTurnosScreenState();
}

class _ReservaDeTurnosScreenState extends State<ReservaDeTurnosScreen> {
  String? selectedDoctor = '';
  String? selectedPatient = '';
  DateTime? selectedDate;
  String? selectedTime = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva de Turno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Doctor:'),
            const SizedBox(height: 10),
            const Text('Pacientes:'),
            // DropdownButton<String?>(
            //   value: selectedPatient,
            //   hint: const Text('Selecciona un paciente'),
            //   items: [
            //     'David Wilson',
            //     'Emily Jones',
            //     // ... add other patients here
            //   ]
            //       .map((patient) => DropdownMenuItem(
            //             value: patient,
            //             child: Text(patient),
            //           ))
            //       .toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       selectedPatient = value ?? '';
            //     });
            //   },
            // ),
            const SizedBox(height: 10),
            const Text('Fecha:'),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Selecciona una fecha',
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(text: selectedDate?.toLocal().toString().split(' ')[0]),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            const Text('Hora:'),
            DropdownButton<String>(
              value: selectedTime,
              hint: const Text('Selecciona una hora'),
              items: [
                "09:00 - 10:00",
                "10:00 - 11:00",
                "11:00 - 12:00",
                "12:00 - 13:00",
                "13:00 - 14:00",
                "14:00 - 15:00",
                "15:00 - 16:00",
                "16:00 - 17:00",
                "17:00 - 18:00",
                "18:00 - 19:00",
                "19:00 - 20:00",
                "20:00 - 21:00"
              ]
              .map((time) => DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  ))
              .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedTime = value;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Agregar Reserva'),
            ),
            const Divider(),
            const Text('Reservas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            DataTable(
              columns: const [
                DataColumn(label: Text('Doctor')),
                DataColumn(label: Text('Paciente')),
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Hora')),
                DataColumn(label: Text('Acción')),
              ],
              rows: [
                // Example row, add more rows as needed
                DataRow(cells: [
                  const DataCell(Text('John Doe')),
                  const DataCell(Text('Mia Foster')),
                  const DataCell(Text('2023/10/27')),
                  const DataCell(Text('12:30 - 13:00')),
                  DataCell(ElevatedButton(onPressed: () {}, child: const Text('Cancelar')))
                ]),
              ],
            )
          ],
        ),
      ),
    );
  }

}
