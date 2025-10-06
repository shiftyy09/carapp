import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../core/database/database_helper.dart';
import 'add_vehicle_screen.dart';
import '../maintenance/maintenance_list_screen.dart';

class VehicleListScreen extends StatefulWidget {
  final bool selectionMode;

  const VehicleListScreen({super.key, this.selectionMode = false});

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
    List<Map<String, Object?>> data;
    if (kIsWeb) {
      data = await DatabaseHelper.instance.getTestVehicles();
    } else {
      data = await DatabaseHelper.instance.getVehicles();
    }
    setState(() {
      vehicles = data.map((m) => Vehicle.fromMap(m)).toList();
      isLoading = false;
    });
  }

  Future<void> _deleteVehicle(int vehicleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Jármű törlése'),
        content: const Text('Biztosan törölni szeretnéd ezt a járművet?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Mégsem')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Törlés')),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteVehicle(vehicleId);
      setState(() {
        vehicles.removeWhere((v) => v.id == vehicleId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jármű törölve')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const accentOrange = Color.fromARGB(255, 255, 164, 0);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectionMode ? 'Válassz járművet' : 'Járműveim'),
        backgroundColor: Colors.black,
        foregroundColor: accentOrange,
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color.fromARGB(255, 255, 164, 0)),
      )
          : vehicles.isEmpty
          ? const Center(
        child: Text('Nincs jármű.', style: TextStyle(color: Colors.orange)),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vehicles.length,
        itemBuilder: (context, i) {
          final v = vehicles[i];
          return Card(
            color: Colors.grey[900] ?? const Color(0xFF212121),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(
                '${v.make} ${v.model}',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Évjárat: ${v.year}',
                style: const TextStyle(color: Colors.orange),
              ),
              trailing: widget.selectionMode
                  ? null
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentOrange,
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
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteVehicle(v.id!),
                    tooltip: 'Jármű törlése',
                  ),
                ],
              ),
              onTap: widget.selectionMode
                  ? () {
                Navigator.of(context).pop(v);
              }
                  : null,
            ),
          );
        },
      ),
      floatingActionButton: widget.selectionMode
          ? null
          : FloatingActionButton(
        backgroundColor: accentOrange,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddVehicleScreen()),
          );
          if (result == true) {
            _loadVehicles();
          }
        },
      ),
    );
  }
}
