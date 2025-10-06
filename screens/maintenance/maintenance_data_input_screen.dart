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
  State<MaintenanceDataInputScreen> createState() => _MaintenanceDataInputScreenState();
}

class _MaintenanceDataInputScreenState extends State<MaintenanceDataInputScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _currentKmController;
  late TextEditingController _oilChangeKmController;
  late TextEditingController _beltChangeKmController;
  late TextEditingController _brakeFluidKmController;

  DateTime? _lastOilChangeDate;
  DateTime? _lastBeltChangeDate;
  DateTime? _lastBrakeFluidChangeDate;

  @override
  void initState() {
    super.initState();
    _currentKmController = TextEditingController();
    _oilChangeKmController = TextEditingController();
    _beltChangeKmController = TextEditingController();
    _brakeFluidKmController = TextEditingController();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final keyPrefix = '${widget.vehicleId}_';

    setState(() {
      _currentKmController.text = (prefs.getDouble('${keyPrefix}currentKm') ?? 0).toInt().toString();

      _oilChangeKmController.text = (prefs.getDouble('${keyPrefix}oilChangeKm') ?? 0).toInt().toString();
      final oilDateStr = prefs.getString('${keyPrefix}oilChangeDate');
      _lastOilChangeDate = oilDateStr != null ? DateTime.tryParse(oilDateStr) : DateTime.now();

      _beltChangeKmController.text = (prefs.getDouble('${keyPrefix}beltChangeKm') ?? 0).toInt().toString();
      final beltDateStr = prefs.getString('${keyPrefix}beltChangeDate');
      _lastBeltChangeDate = beltDateStr != null ? DateTime.tryParse(beltDateStr) : DateTime.now();

      _brakeFluidKmController.text = (prefs.getDouble('${keyPrefix}brakeFluidKm') ?? 0).toInt().toString();
      final brakeDateStr = prefs.getString('${keyPrefix}brakeFluidDate');
      _lastBrakeFluidChangeDate = brakeDateStr != null ? DateTime.tryParse(brakeDateStr) : DateTime.now();
    });
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final prefs = await SharedPreferences.getInstance();
    final keyPrefix = '${widget.vehicleId}_';

    final currentKm = double.tryParse(_currentKmController.text) ?? 0;
    await prefs.setDouble('${keyPrefix}currentKm', currentKm);

    await prefs.setDouble('${keyPrefix}oilChangeKm', double.tryParse(_oilChangeKmController.text) ?? 0);
    await prefs.setString('${keyPrefix}oilChangeDate', _lastOilChangeDate!.toIso8601String());

    await prefs.setDouble('${keyPrefix}beltChangeKm', double.tryParse(_beltChangeKmController.text) ?? 0);
    await prefs.setString('${keyPrefix}beltChangeDate', _lastBeltChangeDate!.toIso8601String());

    await prefs.setDouble('${keyPrefix}brakeFluidKm', double.tryParse(_brakeFluidKmController.text) ?? 0);
    await prefs.setString('${keyPrefix}brakeFluidDate', _lastBrakeFluidChangeDate!.toIso8601String());

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adatok elmentve')));
    Navigator.of(context).pop(true);
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: const Color.fromARGB(255, 255, 164, 0),
            surface: const Color(0xFF212121),
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: Colors.black,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
    if (date != null) {
      setState(() {
        switch (type) {
          case 'oil':
            _lastOilChangeDate = date;
            break;
          case 'belt':
            _lastBeltChangeDate = date;
            break;
          case 'brake':
            _lastBrakeFluidChangeDate = date;
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    _currentKmController.dispose();
    _oilChangeKmController.dispose();
    _beltChangeKmController.dispose();
    _brakeFluidKmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accentOrange = Color.fromARGB(255, 255, 164, 0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Karbantartási adatok: ${widget.vehicleName}'),
        backgroundColor: Colors.black,
        foregroundColor: accentOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _currentKmController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jelenlegi km állás',
                labelStyle: TextStyle(color: accentOrange),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: accentOrange)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: accentOrange)),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Add meg a km-t' : null,
            ),
            const SizedBox(height: 20),
            _buildKmuItem('Olajcsere', _oilChangeKmController, _lastOilChangeDate, 'oil'),
            _buildKmuItem('Szíjcsere', _beltChangeKmController, _lastBeltChangeDate, 'belt'),
            _buildKmuItem('Fékfolyadék csere', _brakeFluidKmController, _lastBrakeFluidChangeDate, 'brake'),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _saveData,
                child: const Text('Mentés'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentOrange,
                )),
          ]),
        ),
      ),
    );
  }

  Widget _buildKmuItem(String label, TextEditingController controller, DateTime? date, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Color.fromARGB(255, 255, 164, 0)),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 255, 164, 0))),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Add meg a km-t' : null,
        ),
        Row(
          children: [
            Text(
              date != null ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}' : 'Nincs dátum',
              style: const TextStyle(color: Colors.white70),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Color.fromARGB(255, 255, 164, 0)),
              onPressed: () => _selectDate(context, type),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
