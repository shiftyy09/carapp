import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'maintenance_data_input_screen.dart';

enum MaintenanceStatus { urgent, warning, ok }

class MaintenanceReminderScreen extends StatefulWidget {
  final int vehicleId;
  final String vehicleName;

  const MaintenanceReminderScreen({
    Key? key,
    required this.vehicleId,
    required this.vehicleName,
  }) : super(key: key);

  @override
  _MaintenanceReminderScreenState createState() =>
      _MaintenanceReminderScreenState();
}

class _MaintenanceReminderScreenState
    extends State<MaintenanceReminderScreen> {
  double currentKm = 0;
  double oilChangeKm = 0;
  double beltChangeKm = 0;
  double brakeFluidKm = 0;
  DateTime? lastOilChangeDate;
  DateTime? lastBeltChangeDate;
  DateTime? lastBrakeFluidChangeDate;
  bool notificationsEnabled = false;
  bool isLoading = true;

  static const double oilInterval = 15000;
  static const double beltInterval = 60000;
  static const double brakeFluidInterval = 40000;
  static const int oilMonthInterval = 12;
  static const int beltMonthInterval = 48;
  static const int brakeFluidMonthInterval = 24;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.vehicleId}_';

    final loadedKm = prefs.getDouble('${key}currentKm') ?? 0;
    print('⚙️ Loading currentKm: $loadedKm');

    setState(() {
      currentKm = loadedKm;
      oilChangeKm = prefs.getDouble('${key}oilChangeKm') ?? 0;
      beltChangeKm = prefs.getDouble('${key}beltChangeKm') ?? 0;
      brakeFluidKm = prefs.getDouble('${key}brakeFluidKm') ?? 0;
      lastOilChangeDate = prefs.getString('${key}oilChangeDate') != null
          ? DateTime.parse(prefs.getString('${key}oilChangeDate')!)
          : null;
      lastBeltChangeDate = prefs.getString('${key}beltChangeDate') != null
          ? DateTime.parse(prefs.getString('${key}beltChangeDate')!)
          : null;
      lastBrakeFluidChangeDate = prefs.getString('${key}brakeFluidDate') != null
          ? DateTime.parse(prefs.getString('${key}brakeFluidDate')!)
          : null;
      notificationsEnabled = prefs.getBool('${key}notifications') ?? false;
      isLoading = false;
    });
  }

  Future<void> _toggleNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      '${widget.vehicleId}_notifications',
      !notificationsEnabled,
    );
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });
  }

  MaintenanceStatus _getMaintenanceStatus(
      double lastKm,
      double currentKm,
      double interval,
      DateTime? lastDate,
      int monthInterval,
      ) {
    final kmSince = currentKm - lastKm;
    final kmRemaining = interval - kmSince;
    int monthsSince = 0;
    if (lastDate != null) {
      monthsSince = DateTime.now().difference(lastDate).inDays ~/ 30;
    }
    final monthsRemaining = monthInterval - monthsSince;

    if (kmRemaining <= 0 || monthsRemaining <= 0) {
      return MaintenanceStatus.urgent;
    } else if (kmRemaining <= interval * 0.1 || monthsRemaining <= 1) {
      return MaintenanceStatus.warning;
    } else {
      return MaintenanceStatus.ok;
    }
  }

  Widget _buildMaintenanceItem(
      String title,
      IconData icon,
      double lastKm,
      DateTime? lastDate,
      double interval,
      int monthInterval,
      ) {
    final status = _getMaintenanceStatus(
      lastKm,
      currentKm,
      interval,
      lastDate,
      monthInterval,
    );
    final kmSince = currentKm - lastKm;
    final kmRemaining = (interval - kmSince).toInt();
    int monthsSince = 0;
    if (lastDate != null) {
      monthsSince = DateTime.now().difference(lastDate).inDays ~/ 30;
    }
    final monthsRemaining = monthInterval - monthsSince;

    Color color;
    String statusText;
    switch (status) {
      case MaintenanceStatus.urgent:
        color = Colors.red;
        statusText = 'SÜRGŐS!';
        break;
      case MaintenanceStatus.warning:
        color = Colors.orange;
        statusText = 'Hamarosan';
        break;
      case MaintenanceStatus.ok:
      default:
        color = Colors.green;
        statusText = 'Rendben';
    }

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    kmRemaining > 0
                        ? '$kmRemaining km hátra'
                        : '${-kmRemaining} km túllépve',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  Text(
                    monthsRemaining > 0
                        ? '$monthsRemaining hónap hátra'
                        : '${-monthsRemaining} hónap túllépve',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color),
              ),
              child: Text(statusText,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accentOrange = Color.fromARGB(255, 255, 164, 0);

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Karbantartási emlékeztető'),
          backgroundColor: Colors.black,
          foregroundColor: accentOrange,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: accentOrange),
        ),
        backgroundColor: Colors.black,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Karbantartás: ${widget.vehicleName}'),
        backgroundColor: Colors.black,
        foregroundColor: accentOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => MaintenanceDataInputScreen(
                    vehicleId: widget.vehicleId,
                    vehicleName: widget.vehicleName,
                  ),
                ),
              );
              if (result == true) _loadData();
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.directions_car,
                        color: accentOrange, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.vehicleName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              'Jelenlegi km: ${currentKm.toInt()}',
                              style:
                              const TextStyle(color: Colors.orange)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildMaintenanceItem(
                    'Olajcsere',
                    Icons.oil_barrel,
                    oilChangeKm,
                    lastOilChangeDate,
                    oilInterval,
                    oilMonthInterval,
                  ),
                  _buildMaintenanceItem(
                    'Szíjcsere',
                    Icons.settings,
                    beltChangeKm,
                    lastBeltChangeDate,
                    beltInterval,
                    beltMonthInterval,
                  ),
                  _buildMaintenanceItem(
                    'Fékfolyadék csere',
                    Icons.local_gas_station,
                    brakeFluidKm,
                    lastBrakeFluidChangeDate,
                    brakeFluidInterval,
                    brakeFluidMonthInterval,
                  ),
                ],
              ),
            ),
            Card(
              color: Colors.grey[900],
              child: SwitchListTile(
                title: const Text('Értesítések engedélyezése',
                    style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                    'Figyelmeztetés karbantartási időpontokra',
                    style: TextStyle(color: Colors.grey)),
                value: notificationsEnabled,
                onChanged: (_) => _toggleNotifications(),
                activeColor: accentOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
