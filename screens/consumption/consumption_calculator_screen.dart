import 'package:flutter/material.dart';

class ConsumptionCalculatorScreen extends StatefulWidget {
  const ConsumptionCalculatorScreen({super.key});

  @override
  _ConsumptionCalculatorScreenState createState() => _ConsumptionCalculatorScreenState();
}

class _ConsumptionCalculatorScreenState extends State<ConsumptionCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  double fuelPrice = 588; // Ft/l
  double dieselPrice = 592; // Ft/l

  String fuelType = 'benzin';
  double distance = 0;       // km
  double litersUsed = 0;     // liter

  double? consumption;     // liter/100km számolt érték
  double? totalCost;       // forint

  // Kiválasztott ár a tüzelőanyagtípus alapján
  double get selectedPrice => (fuelType == 'benzin') ? fuelPrice : dieselPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fogyasztás kalkulátor'),
        backgroundColor: Colors.black,
        foregroundColor: const Color.fromARGB(255,255,164,0),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ToggleButtons(
                isSelected: [fuelType == 'benzin', fuelType == 'gázolaj'],
                onPressed: (index) {
                  setState(() {
                    fuelType = (index == 0) ? 'benzin' : 'gázolaj';
                  });
                },
                borderRadius: BorderRadius.circular(12),
                color: Colors.white70,
                selectedColor: Colors.black,
                fillColor: const Color.fromARGB(255,255,164,0),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text('Benzin'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text('Gázolaj'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: selectedPrice.toStringAsFixed(0),
                decoration: InputDecoration(
                  labelText: fuelType == 'benzin' ? 'Benzin ára (Ft/l)' : 'Gázolaj ára (Ft/l)',
                  labelStyle: const TextStyle(color: Color.fromARGB(255,255,164,0)),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255,255,164,0)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  double v = double.tryParse(val.replaceAll(',', '.')) ?? selectedPrice;
                  setState(() {
                    if (fuelType == 'benzin') {
                      fuelPrice = v;
                    } else {
                      dieselPrice = v;
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Megtett távolság (km)',
                  labelStyle: TextStyle(color: Color.fromARGB(255,255,164,0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255,255,164,0)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() {
                    distance = double.tryParse(val.replaceAll(',', '.')) ?? 0;
                  });
                },
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Adj meg megtett távolságot!';
                  if (double.tryParse(val.replaceAll(',', '.')) == null) return 'Érvényes számot adj meg!';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Fogyasztott üzemanyag mennyisége (L)',
                  labelStyle: TextStyle(color: Color.fromARGB(255,255,164,0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255,255,164,0)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() {
                    litersUsed = double.tryParse(val.replaceAll(',', '.')) ?? 0;
                  });
                },
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Adj meg tankolt liter mennyiséget!';
                  if (double.tryParse(val.replaceAll(',', '.')) == null) return 'Érvényes számot adj meg!';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _calculate();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255,255,164,0),
                ),
                child: const Text(
                  'Számítás',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 30),
              if (consumption != null && totalCost != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text(
                        'Fogyasztás: ${consumption!.toStringAsFixed(2)} L/100km',
                        style: const TextStyle(color: Color.fromARGB(255,255,164,0), fontSize: 20),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.black87,
                            title: const Text('Fogyasztás magyarázat', style: TextStyle(color: Colors.orange)),
                            content: Text(
                              'A fogyasztás azt mutatja, hogy hány liter üzemanyagot használsz el 100 km-en.\n'
                                  'Példa: Ha 2000 km-t mentél és 40 litert tankoltál, akkor a fogyasztás: (40 / 2000) * 100 = 2 L/100km.',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Bezár', style: TextStyle(color: Colors.orange)),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      },
                      trailing: const Icon(Icons.info_outline, color: Color.fromARGB(255,255,164,0)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Költség: ${totalCost!.toStringAsFixed(0)} Ft',
                      style: const TextStyle(color: Color.fromARGB(
                          255, 255, 164, 0), fontSize: 20),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _calculate() {
    if (distance > 0 && litersUsed > 0) {
      final cons = (litersUsed / distance) * 100;
      final cost = litersUsed * selectedPrice;
      setState(() {
        consumption = cons;
        totalCost = cost;
      });
    }
  }
}
