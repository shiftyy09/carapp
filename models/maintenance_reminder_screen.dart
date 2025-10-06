import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaintenanceDataInputScreen extends StatefulWidget {
  final int vehicleId;
  final String vehicleName;

  const MaintenanceDataInputScreen({
    Key? key,
    required this.vehicleId,
    required this.vehicleName,
  }) : super(key: key);

  @override
  _MaintenanceDataInputScreenState createState() => _MaintenanceDataInputScreenState();
}

class _MaintenanceDataInputScreenState extends State<MaintenanceDataInputScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _currentKmController;
  late TextEditingController _oilKmController;
  late TextEditingController _beltKmController;
  late TextEditingController _brakeKmController;
  DateTime? _oilDate;
  DateTime? _beltDate;
  DateTime? _brakeDate;

  @override
  void initState() {
    super.initState();
    _currentKmController = TextEditingController();
    _oilKmController = TextEditingController();
    _beltKmController = TextEditingController();
    _brakeKmController = TextEditingController();
  }

  @override
  void dispose() {
    _currentKmController.dispose();
    _oilKmController.dispose();
    _beltKmController.dispose();
    _brakeKmController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, DateTime? initial, ValueChanged<DateTime> onPicked) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.vehicleId}_';

    final currentKm = double.parse(_currentKmController.text);
    final oilKm = double.parse(_oilKmController.text);
    final beltKm = double.parse(_beltKmController.text);
    final brakeKm = double.parse(_brakeKmController.text);

    await prefs.setDouble('${key}currentKm', currentKm);
    await prefs.setDouble('${key}oilChangeKm', oilKm);
    await prefs.setDouble('${key}beltChangeKm', beltKm);
    await prefs.setDouble('${key}brakeFluidKm', brakeKm);

    if (_oilDate != null) {
      await prefs.setString('${key}oilChangeDate', _oilDate!.toIso8601String());
    }
    if (_beltDate != null) {
      await prefs.setString('${key}beltChangeDate', _beltDate!.toIso8601String());
    }
    if (_brakeDate != null) {
      await prefs.setString('${key}brakeFluidDate', _brakeDate!.toIso8601String());
    }

    // DEBUG prints
    print('⚙️ Saved currentKm: ${prefs.getDouble('${key}currentKm')}');
    print('⚙️ Saved oilChangeDate: ${prefs.getString('${key}oilChangeDate')}');

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    const accentOrange = Color.fromARGB(255, 255, 164, 0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Adatbevitel: ${widget.vehicleName}'),
        backgroundColor: Colors.black,
        foregroundColor: accentOrange,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _currentKmController,
                decoration: const InputDecoration(
                  labelText: 'Jelenlegi km',
                  labelStyle: TextStyle(color: Colors.orange),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Kérem a km-et' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _oilKmController,
                decoration: const InputDecoration(
                  labelText: 'Utolsó olajcsere km',
                  labelStyle: TextStyle(color: Colors.orange),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Kérem az értéket' : null,
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Olajcsere dátuma', style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  _oilDate != null ? _oilDate!.toLocal().toString().split(' ')[0] : 'Nincs kiválasztva',
                  style: const TextStyle(color: Colors.orange),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.orange),
                  onPressed: () => _pickDate(context, _oilDate, (d) => setState(() => _oilDate = d)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _beltKmController,
                decoration: const InputDecoration(
                  labelText: 'Utolsó vezérléscsere km',
                  labelStyle: TextStyle(color: Colors.orange),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Kérem az értéket' : null,
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Vezérléscsere dátuma', style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  _beltDate != null ? _beltDate!.toLocal().toString().split(' ')[0] : 'Nincs kiválasztva',
                  style: const TextStyle(color: Colors.orange),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.orange),
                  onPressed: () => _pickDate(context, _beltDate, (d) => setState(() => _beltDate = d)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brakeKmController,
                decoration: const InputDecoration(
                  labelText: 'Utolsó fékfolyadék-csere km',
                  labelStyle: TextStyle(color: Colors.orange),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Kérem az értéket' : null,
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fékfolyadék csere dátuma', style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  _brakeDate != null ? _brakeDate!.toLocal().toString().split(' ')[0] : 'Nincs kiválasztva',
                  style: const TextStyle(color: Colors.orange),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.orange),
                  onPressed: () => _pickDate(context, _brakeDate, (d) => setState(() => _brakeDate = d)),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentOrange,
                  foregroundColor: Colors.black,
                ),
                onPressed: _saveData,
                child: const Text('Mentés'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
