class Medication {
  final int id;
  final String name;
  final String dosage;
  final int frequencyHours;
  final DateTime startDate;
  final DateTime endDate;

  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequencyHours,
    required this.startDate,
    required this.endDate,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      frequencyHours: json['frequencyHours'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequencyHours': frequencyHours,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}