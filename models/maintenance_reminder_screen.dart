import 'package:flutter/material.dart';
import 'car.dart';
import 'maintenance_item.dart';

class MaintenanceReminderScreen extends StatefulWidget {
  const MaintenanceReminderScreen({super.key});

  @override
  State<MaintenanceReminderScreen> createState() => _MaintenanceReminderScreenState();
}

class _MaintenanceReminderScreenState extends State<MaintenanceReminderScreen> {
  List<Car> cars = [
    Car(id: '1', name: 'Honda Civic', currentKm: 8000),
    Car(id: '2', name: 'Toyota Corolla', currentKm: 12000),
  ];

  Map<String, List<MaintenanceItem>> carMaintenanceMap = {};

  Car? selectedCar;

  @override
  void initState() {
    super.initState();

    for (var car in cars) {
      carMaintenanceMap[car.id] = [
        MaintenanceItem(id: 'oil', name: 'Olajcsere', intervalKm: 10000, lastServiceKm: 0),
        MaintenanceItem(id: 'timing', name: 'Vezérlés csere', intervalKm: 80000, lastServiceKm: 0),
        MaintenanceItem(id: 'coolant', name: 'Fagyálló csere', intervalKm: 100000, lastServiceKm: 0),
        MaintenanceItem(id: 'brake_oil', name: 'Fékolaj csere', intervalKm: 30000, lastServiceKm: 0),
        MaintenanceItem(id: 'mushaki', name: 'Műszaki vizsga', intervalKm: 40000, lastServiceKm: 0),
      ];
    }
  }

  double weeklyKmEstimate(Car car) {
    // Egyszerű becslés, ha kell a jövőben bővíthető AI vagy History alapján
    return 300; // például 300 km/hét
  }

  int weeksToService(MaintenanceItem item, Car car) {
    double remainingKm = (item.lastServiceKm + item.intervalKm) - car.currentKm;
    double weeklyKm = weeklyKmEstimate(car);
    if (weeklyKm <= 0) return -1;
    return (remainingKm / weeklyKm).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final maintenanceItems = selectedCar != null ? carMaintenanceMap[selectedCar!.id]! : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karbantartási emlékeztető'),
        backgroundColor: Colors.black,
        foregroundColor: const Color.fromARGB(255, 255, 164, 0),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<Car>(
              hint: const Text('Válassz autót'),
              value: selectedCar,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              onChanged: (car) {
                setState(() {
                  selectedCar = car;
                });
              },
              items: cars.map((car) {
                return DropdownMenuItem<Car>(
                  value: car,
                  child: Text(car.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (selectedCar != null) ...[
              TextFormField(
                initialValue: selectedCar!.currentKm.toString(),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Jelenlegi km óra állás',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 255, 164, 0)),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0))),
                ),
                onChanged: (value) {
                  final km = double.tryParse(value) ?? selectedCar!.currentKm;
                  setState(() {
                    selectedCar!.currentKm = km;
                  });
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: maintenanceItems.length,
                  itemBuilder: (context, index) {
                    final item = maintenanceItems[index];
                    final remainingKm = (item.lastServiceKm + item.intervalKm) - selectedCar!.currentKm;
                    final weeks = weeksToService(item, selectedCar!);
                    Color statusColor;
                    if (remainingKm <= 1000) {
                      statusColor = Colors.red;
                    } else if (remainingKm <= 3000) {
                      statusColor = Colors.orange;
                    } else if (remainingKm <= 5000) {
                      statusColor = Colors.yellow;
                    } else {
                      statusColor = Colors.green;
                    }
                    return Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: statusColor,
                          child: Text(remainingKm > 0 ? remainingKm.toStringAsFixed(0) : '!', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hátralevő: ${remainingKm > 0 ? remainingKm.toStringAsFixed(0) + " km" : "Esedékes!"}', style: TextStyle(color: statusColor)),
                            if (weeks > 0) Text('Becsült idő: $weeks hét', style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.check_circle, color: Color.fromARGB(255, 255, 164, 0)),
                          onPressed: () {
                            setState(() {
                              item.lastServiceKm = selectedCar!.currentKm;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
