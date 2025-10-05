class MaintenanceItem {
  final String id;
  final String name;
  final double intervalKm;
  double lastServiceKm;

  MaintenanceItem({
    required this.id,
    required this.name,
    required this.intervalKm,
    required this.lastServiceKm,
  });
}
