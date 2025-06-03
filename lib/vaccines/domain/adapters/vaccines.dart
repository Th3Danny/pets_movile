class Vaccine {
  final int id;
  final DateTime dateApplied;
  final DateTime nextDoseDate;
  final String vetName;

  const Vaccine({
    required this.id,
    required this.dateApplied,
    required this.nextDoseDate,
    required this.vetName,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      id: json['id'],
      dateApplied: DateTime.parse(json['dateApplied']),
      nextDoseDate: DateTime.parse(json['nextDoseDate']),
      vetName: json['vetName'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateApplied': dateApplied.toIso8601String(),
      'nextDoseDate': nextDoseDate.toIso8601String(),
      'vetName': vetName,
    };
  }
}