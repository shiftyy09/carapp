import 'package:flutter/material.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  String make = '';
  String model = '';
  int year = DateTime.now().year;
  String licensePlate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jármű hozzáadása'),
        backgroundColor: Colors.black,
        foregroundColor: const Color.fromARGB(255, 255, 164, 0),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Gyártmány (pl. Opel)',
                  labelStyle: TextStyle(color: Colors.orange),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0)),
                  ),
                ),
                onChanged: (val) => setState(() => make = val),
                validator: (val) => val == null || val.isEmpty ? 'Kötelező mező!' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Típus (pl. Astra)',
                  labelStyle: TextStyle(color: Colors.orange),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0)),
                  ),
                ),
                onChanged: (val) => setState(() => model = val),
                validator: (val) => val == null || val.isEmpty ? 'Kötelező mező!' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Évjárat',
                  labelStyle: TextStyle(color: Colors.orange),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0)),
                  ),
                ),
                keyboardType: TextInputType.number,
                initialValue: year.toString(),
                onChanged: (val) => setState(() => year = int.tryParse(val) ?? DateTime.now().year),
                validator: (val) => val == null || val.isEmpty ? 'Kötelező mező!' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Rendszám (opcionális)',
                  labelStyle: TextStyle(color: Colors.orange),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0)),
                  ),
                ),
                onChanged: (val) => setState(() => licensePlate = val),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 164, 0),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'make': make,
                      'model': model,
                      'year': year,
                      'licensePlate': licensePlate.isEmpty ? null : licensePlate,
                    });
                  }
                },
                child: const Text('Mentés', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}