import 'package:flutter/material.dart';
import 'package:car_maintenance_app/core/database/database_helper.dart';
import '../../models/vehicle.dart';
import '../maintenance/maintenance_list_screen.dart'; // importáld

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  List<Vehicle> vehicles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final data = await DatabaseHelper.instance.getVehicles();
    setState(() {
      vehicles = data.map((m) => Vehicle.fromMap(m)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Járműveim'),
        backgroundColor: Colors.black,
        foregroundColor: const Color.fromARGB(255, 255, 164, 0),
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255,255,164,0)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vehicles.length,
        itemBuilder: (context, i) {
          final v = vehicles[i];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text('${v.make} ${v.model}',
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text('Évjárat: ${v.year}',
                  style: const TextStyle(color: Colors.orange)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255,255,164,0),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Karbantartások'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MaintenanceListScreen(
                        vehicleId: v.id!,
                        vehicleName: '${v.make} ${v.model}',
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255,255,164,0),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          // AddVehicleScreen implementálva korábban
          final result = await Navigator.of(context).pushNamed('/addVehicle');
          if (result == true) _loadVehicles();
        },
      ),
    );
  }
}
