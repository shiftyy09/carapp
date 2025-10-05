class MaintenanceRecord {
  final int? id;
  final int vehicleId;
  final String date;
  final int mileage;
  final String servicePlace;
  final String description;
  final double laborCost;
  final double partsCost;
  final double totalCost;
  final String? notes;

  MaintenanceRecord({
    this.id,
    required this.vehicleId,
    required this.date,
    required this.mileage,
    required this.servicePlace,
    required this.description,
    required this.laborCost,
    required this.partsCost,
    required this.totalCost,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'vehicleId': vehicleId,
    'date': date,
    'mileage': mileage,
    'servicePlace': servicePlace,
    'description': description,
    'laborCost': laborCost,
    'partsCost': partsCost,
    'totalCost': totalCost,
    'notes': notes,
  };

  factory MaintenanceRecord.fromMap(Map<String, dynamic> m) => MaintenanceRecord(
    id: m['id'],
    vehicleId: m['vehicleId'],
    date: m['date'],
    mileage: m['mileage'],
    servicePlace: m['servicePlace'],
    description: m['description'],
    laborCost: m['laborCost'],
    partsCost: m['partsCost'],
    totalCost: m['totalCost'],
    notes: m['notes'],
  );
}
