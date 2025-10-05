import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  String make = '';
  String model = '';
  int? year;
  String licensePlate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Új jármű hozzáadása'),
        backgroundColor: Colors.black,
        foregroundColor: const Color.fromARGB(255, 255, 164, 0),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Gyártó',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 164, 0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) => (value == null || value.isEmpty) ? 'Add meg a gyártót' : null,
                onSaved: (value) => make = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Modell',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 164, 0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) => (value == null || value.isEmpty) ? 'Add meg a modellt' : null,
                onSaved: (value) => model = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Évjárat',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 164, 0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0)),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Add meg az évjáratot';
                  if (int.tryParse(value) == null) return 'Érvényes számot adj meg';
                  return null;
                },
                onSaved: (value) => year = int.parse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Rendszám (nem kötelező)',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 164, 0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onSaved: (value) => licensePlate = value ?? '',
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 164, 0),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await DatabaseHelper.instance.createVehicle({
                      'make': make,
                      'model': model,
                      'year': year,
                      'licensePlate': licensePlate,
                    });
                    Navigator.of(context).pop(true);
                  }
                },
                child: const Text(
                  'Mentés',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
