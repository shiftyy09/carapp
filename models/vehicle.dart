class Vehicle {
  final int? id;
  final String make;
  final String model;
  final int year;
  final String? licensePlate;

  Vehicle({this.id, required this.make, required this.model, required this.year, this.licensePlate});

  Map<String, dynamic> toMap() => {
    'id': id,
    'make': make,
    'model': model,
    'year': year,
    'licensePlate': licensePlate,
  };

  factory Vehicle.fromMap(Map<String, dynamic> m) => Vehicle(
    id: m['id'],
    make: m['make'],
    model: m['model'],
    year: m['year'],
    licensePlate: m['licensePlate'],
  );
}
