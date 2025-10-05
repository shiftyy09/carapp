import 'package:flutter/material.dart';
import '../vehicles/vehicle_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color accentOrange = Color.fromARGB(255, 255, 164, 0);

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.directions_car,
        'title': 'Járműveim',
        'subtitle': 'Autók listája'
      },
      {
        'icon': Icons.event_note,
        'title': 'Szerviz időpontok',
        'subtitle': 'Jövőbeli események'
      },
      {
        'icon': Icons.settings,
        'title': 'Beállítások',
        'subtitle': 'App személyre szabása'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        children: [
          // Alkalmazás logó vagy cím
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Center(
              child: Text(
                'Olajfolt',
                style: TextStyle(
                  color: accentOrange,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Menüelemek
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
                  trailing:
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70),
                  onTap: () {
                    switch (item['title']) {
                      case 'Járműveim':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const VehicleListScreen(),
                          ),
                        );
                        break;
                      case 'Szerviz időpontok':
                      // TODO: implement future events screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Szerviz időpontok fejlesztés alatt')),
                        );
                        break;
                      case 'Beállítások':
                      // TODO: implement settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Beállítások fejlesztés alatt')),
                        );
                        break;
                    }
                  },
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
