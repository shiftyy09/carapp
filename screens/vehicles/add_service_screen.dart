import 'package:flutter/material.dart';

class AddServiceScreen extends StatefulWidget {
  final String vehicleName;
  const AddServiceScreen({super.key, required this.vehicleName});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  int mileage = 0;
  String servicePlace = '';
  String description = '';
  double laborCost = 0.0;
  double partsCost = 0.0;

  double get totalCost => laborCost + partsCost;

  @override
  Widget build(BuildContext context) {
    const accentOrange = Color.fromARGB(255, 255, 164, 0);
    return Scaffold(
      appBar: AppBar(
        title: Text('Szerviz - ${widget.vehicleName}'),
        backgroundColor: Colors.black,
        foregroundColor: accentOrange,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Dátum választó
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Dátum', style: TextStyle(color: accentOrange)),
                subtitle: Text(
                  '${selectedDate.year}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(Icons.calendar_today, color: accentOrange),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: accentOrange,
                          surface: Colors.grey,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (date != null) setState(() => selectedDate = date);
                },
              ),
              const SizedBox(height: 16),

              // Kilométeróra
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Kilométeróra állás',
                  labelStyle: TextStyle(color: accentOrange),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() => mileage = int.tryParse(v) ?? 0),
                validator: (v) => v == null || v.isEmpty ? 'Kötelező!' : null,
              ),
              const SizedBox(height: 16),

              // Szerviz hely
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Szervizhely',
                  labelStyle: TextStyle(color: accentOrange),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => servicePlace = v),
                validator: (v) => v == null || v.isEmpty ? 'Kötelező!' : null,
              ),
              const SizedBox(height: 16),

              // Munka leírása
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Munka leírása',
                  labelStyle: TextStyle(color: accentOrange),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => description = v),
                validator: (v) => v == null || v.isEmpty ? 'Kötelező!' : null,
              ),
              const SizedBox(height: 16),

              // Munkadíj
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Munkadíj (Ft)',
                  labelStyle: TextStyle(color: accentOrange),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() => laborCost = double.tryParse(v) ?? 0.0),
                validator: (v) => v == null || v.isEmpty ? 'Kötelező!' : null,
              ),
              const SizedBox(height: 16),

              // Alkatrészköltség
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Alkatrészköltség (Ft)',
                  labelStyle: TextStyle(color: accentOrange),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() => partsCost = double.tryParse(v) ?? 0.0),
                validator: (v) => v == null || v.isEmpty ? 'Kötelező!' : null,
              ),
              const SizedBox(height: 16),

              // Összköltség (read-only)
              TextFormField(
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(
                  labelText: 'Összköltség (Ft)',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                controller: TextEditingController(text: totalCost.toStringAsFixed(0)),
              ),
              const SizedBox(height: 16),

              // Megjegyzés (opcionális)
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Megjegyzés (opcionális)',
                  labelStyle: TextStyle(color: accentOrange),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentOrange,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'date': '${selectedDate.year}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}',
                      'mileage': mileage,
                      'servicePlace': servicePlace,
                      'description': description,
                      'laborCost': laborCost,
                      'partsCost': partsCost,
                      'totalCost': totalCost,
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
