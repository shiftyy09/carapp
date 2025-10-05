import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final Storage _instance = Storage._internal();

  factory Storage() {
    return _instance;
  }

  Storage._internal();

  List<Map<String, dynamic>> vehicles = [];
  List<List<Map<String, dynamic>>> servicesPerVehicle = [];

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final vehiclesData = prefs.getString('vehicles');
    final servicesData = prefs.getString('servicesPerVehicle');
    if (vehiclesData != null) {
      vehicles = List<Map<String, dynamic>>.from(jsonDecode(vehiclesData));
    }
    if (servicesData != null) {
      servicesPerVehicle = List<List<Map<String, dynamic>>>.from(
        (jsonDecode(servicesData) as List).map(
              (list) => List<Map<String, dynamic>>.from(list),
        ),
      );
    }
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('vehicles', jsonEncode(vehicles));
    prefs.setString('servicesPerVehicle', jsonEncode(servicesPerVehicle));
  }
}
