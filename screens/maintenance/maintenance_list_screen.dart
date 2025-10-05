import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
import '../../models/maintenance_record.dart';
import '../vehicles/add_service_screen.dart';

class MaintenanceListScreen extends StatefulWidget {
  final int vehicleId;
  final String vehicleName;
  const MaintenanceListScreen({
    super.key,
    required this.vehicleId,
    required this.vehicleName,
  });

  @override
  State<MaintenanceListScreen> createState() => _MaintenanceListScreenState();
}

class _MaintenanceListScreenState extends State<MaintenanceListScreen> {
  List<MaintenanceRecord> records = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final data = await DatabaseHelper.instance.getMaintenanceForVehicle(widget.vehicleId);
    setState(() {
      records = data.map((m) => MaintenanceRecord.fromMap(m)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karbantartás: ${widget.vehicleName}'),
        backgroundColor: Colors.black,
        foregroundColor: const Color.fromARGB(255,255,164,0),
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255,255,164,0)))
          : records.isEmpty
          ? const Center(
          child: Text('Nincs bejegyzés.',
              style: TextStyle(color: Colors.orange)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        itemBuilder: (context, i) {
          final r = records[i];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(r.description, style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                '${r.date} • ${r.mileage} km\n'
                    'Munkadíj: ${r.laborCost.toStringAsFixed(0)} Ft • '
                    'Alkatrész: ${r.partsCost.toStringAsFixed(0)} Ft\n'
                    'Össz: ${r.totalCost.toStringAsFixed(0)} Ft',
                style: const TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255,255,164,0),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddServiceScreen(
                vehicleName: widget.vehicleName,
              ),
            ),
          );
          if (result != null) {
            // mentsd az adatbázisba
            await DatabaseHelper.instance.createMaintenance({
              'vehicleId': widget.vehicleId,
              'date': result['date'],
              'mileage': result['mileage'],
              'servicePlace': result['servicePlace'],
              'description': result['description'],
              'laborCost': result['laborCost'],
              'partsCost': result['partsCost'],
              'totalCost': result['totalCost'],
              'notes': result['notes'] ?? '',
            });
            _loadRecords();
          }
        },
      ),
    );
  }
}
