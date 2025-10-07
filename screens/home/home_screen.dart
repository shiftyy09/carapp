import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../vehicles/vehicle_list_screen.dart';
import '../consumption/consumption_calculator_screen.dart';
import '../maintenance/maintenance_reminder_screen.dart';
import '../maintenance/maintenance_data_input_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const Color accentOrange = Color.fromARGB(255, 255, 164, 0);

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.directions_car,
        'title': 'Járműveim',
        'subtitle': 'Autók listája',
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => VehicleListScreen()),
          );
        },
      },
      {
        'icon': Icons.calculate_rounded,
        'title': 'Fogyasztás kalkulátor',
        'subtitle': 'Út költség kalkulátor',
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ConsumptionCalculatorScreen()),
          );
        },
      },
      {
        'icon': Icons.build_circle,
        'title': 'Karbantartási emlékeztető',
        'subtitle': 'Olajcsere, vezérlés, műszaki stb.',
        'onTap': () async {
          // Jármű kiválasztása előtte
          final selectedVehicle = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => VehicleListScreen(selectionMode: true)),
          );

          if (selectedVehicle != null) {
            await _navigateToMaintenance(context, selectedVehicle);
          }
        },
      },
      {
        'icon': Icons.event_note,
        'title': 'Szerviz időpontok',
        'subtitle': 'Jövőbeli események',
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Szerviz időpontok fejlesztés alatt')),
          );
        },
      },
      {
        'icon': Icons.settings,
        'title': 'Beállítások',
        'subtitle': 'App személyre szabása',
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Beállítások fejlesztés alatt')),
          );
        },
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Center(
              child: Text(
                'Szerviz-napló',
                style: TextStyle(
                  color: accentOrange,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ...menuItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Card(
                color: Colors.grey[900] ?? const Color(0xFF212121),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: accentOrange,
                    size: 36,
                  ),
                  title: Text(
                    item['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    ),
                  ),
                  subtitle: Text(
                    item['subtitle'] as String,
                    style: TextStyle(color: Colors.orange[200]),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white70,
                  ),
                  onTap: item['onTap'] as VoidCallback,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<void> _navigateToMaintenance(BuildContext context, dynamic selectedVehicle) async {
    final vehicleId = selectedVehicle.id as int;
    final vehicleName = '${selectedVehicle.make} ${selectedVehicle.model}';

    final prefs = await SharedPreferences.getInstance();
    final keyCurrentKm = '${vehicleId}_currentKm';
    final hasData = prefs.containsKey(keyCurrentKm) && (prefs.getDouble(keyCurrentKm) ?? 0) > 0;

    if (!hasData) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MaintenanceDataInputScreen(
            vehicleId: vehicleId,
            vehicleName: vehicleName,
          ),
        ),
      );

      if (result == true) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MaintenanceReminderScreen(
              vehicleId: vehicleId,
              vehicleName: vehicleName,
            ),
          ),
        );
      }
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MaintenanceReminderScreen(
            vehicleId: vehicleId,
            vehicleName: vehicleName,
          ),
        ),
      );
    }
  }
}
