import 'package:flutter/material.dart';
import '../vehicles/vehicle_list_screen.dart';
import '../consumption/consumption_calculator_screen.dart';
import '../maintenance/maintenance_reminder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color accentOrange = Color.fromARGB(255, 255, 164, 0);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.directions_car,
        'title': 'Járműveim',
        'subtitle': 'Autók listája',
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const VehicleListScreen()),
          );
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
        }
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
        'subtitle': 'Olajcsere, vezérlés és műszaki időben',
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MaintenanceReminderScreen()),
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
        }
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        children: [
          Center(
            child: Image.asset(
              'assets/images/olajfoltiras.png',
              width: 250,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Szerviz-napló',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ...menuItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Card(
                color: Colors.grey[900],
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
}
