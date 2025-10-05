import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaintenanceReminderScreen extends StatefulWidget {
  const MaintenanceReminderScreen({super.key});

  @override
  State<MaintenanceReminderScreen> createState() => _MaintenanceReminderScreenState();
}

class _MaintenanceReminderScreenState extends State<MaintenanceReminderScreen> {
  final TextEditingController _currentKmController = TextEditingController();
  final List<MaintenanceItem> maintenanceItems = [
    MaintenanceItem(name: 'Olajcsere', intervalKm: 15000, lastServiceKm: 0),
    MaintenanceItem(name: 'Vezérműszíj csere', intervalKm: 80000, lastServiceKm: 0),
    MaintenanceItem(name: 'Fékolaj csere', intervalKm: 30000, lastServiceKm: 0),
    MaintenanceItem(name: 'Fagyálló csere', intervalKm: 100000, lastServiceKm: 0),
    MaintenanceItem(name: 'Műszaki vizsga', intervalKm: 40000, lastServiceKm: 0),
    MaintenanceItem(name: 'Fékbetét csere', intervalKm: 35000, lastServiceKm: 0),
    MaintenanceItem(name: 'Levegőszűrő csere', intervalKm: 60000, lastServiceKm: 0),
    MaintenanceItem(name: 'Pollenszűrő csere', intervalKm: 15000, lastServiceKm: 0),
  ];

  double currentKm = 0;
  double weeklyKm = 0; // AI becsléshez
  Map<String, double> weeklyKmHistory = {}; // Heti km teljesítmény történet

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentKm = prefs.getDouble('currentKm') ?? 0;
      weeklyKm = prefs.getDouble('weeklyKm') ?? 0;
      _currentKmController.text = currentKm.toString();

      // Betöltjük az utolsó szerviz km-eket
      for (var item in maintenanceItems) {
        item.lastServiceKm = prefs.getDouble('${item.name}_lastKm') ?? 0;
      }
    });
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('currentKm', currentKm);
    await prefs.setDouble('weeklyKm', weeklyKm);

    for (var item in maintenanceItems) {
      await prefs.setDouble('${item.name}_lastKm', item.lastServiceKm);
    }
  }

  void _updateCurrentKm() {
    setState(() {
      currentKm = double.tryParse(_currentKmController.text) ?? 0;
      _calculateWeeklyKm();
    });
    _saveData();
  }

  void _calculateWeeklyKm() {
    // Egyszerű heti km becslés az utolsó frissítés óta
    final now = DateTime.now();
    final weekKey = '${now.year}-${now.month}-${(now.day / 7).ceil()}';

    if (weeklyKmHistory.containsKey(weekKey)) {
      weeklyKm = currentKm - (weeklyKmHistory[weekKey] ?? 0);
    }
    weeklyKmHistory[weekKey] = currentKm;
  }

  int _estimateWeeksToService(MaintenanceItem item) {
    final remainingKm = (item.lastServiceKm + item.intervalKm) - currentKm;
    if (weeklyKm <= 0) return -1;
    return (remainingKm / weeklyKm).ceil();
  }

  Color _getUrgencyColor(MaintenanceItem item) {
    final remainingKm = (item.lastServiceKm + item.intervalKm) - currentKm;
    if (remainingKm <= 1000) return Colors.red;
    if (remainingKm <= 3000) return Colors.orange;
    if (remainingKm <= 5000) return Colors.yellow;
    return Colors.green;
  }

  void _markAsServiced(MaintenanceItem item) {
    setState(() {
      item.lastServiceKm = currentKm;
    });
    _saveData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} elvégezve $currentKm km-nél')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            // Jelenlegi km beállítása
            TextFormField(
              controller: _currentKmController,
              decoration: const InputDecoration(
                labelText: 'Jelenlegi kilométeróra állás',
                labelStyle: TextStyle(color: Color.fromARGB(255, 255, 164, 0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0)),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              onFieldSubmitted: (_) => _updateCurrentKm(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateCurrentKm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 164, 0),
              ),
              child: const Text('Frissítés', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 20),
            if (weeklyKm > 0)
              Text(
                'Becsült heti km: ${weeklyKm.toStringAsFixed(0)} km',
                style: const TextStyle(color: Colors.white70),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: maintenanceItems.length,
                itemBuilder: (context, index) {
                  final item = maintenanceItems[index];
                  final remainingKm = (item.lastServiceKm + item.intervalKm) - currentKm;
                  final estimatedWeeks = _estimateWeeksToService(item);
                  final urgencyColor = _getUrgencyColor(item);

                  return Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: urgencyColor,
                        child: Text(
                          remainingKm > 0 ? remainingKm.toStringAsFixed(0) : '!',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hátralevő: ${remainingKm > 0 ? "${remainingKm.toStringAsFixed(0)} km" : "Esedékes!"}',
                            style: TextStyle(color: urgencyColor),
                          ),
                          if (estimatedWeeks > 0)
                            Text(
                              'Becsült idő: $estimatedWeeks hét',
                              style: const TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.check_circle, color: Color.fromARGB(255, 255, 164, 0)),
                        onPressed: () => _markAsServiced(item),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaintenanceItem {
  final String name;
  final double intervalKm;
  double lastServiceKm;

  MaintenanceItem({
    required this.name,
    required this.intervalKm,
    required this.lastServiceKm,
  });
}
