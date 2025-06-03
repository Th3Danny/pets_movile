class Diet {
  final int id;
  final String mealName;
  final String quantity;
  final String schedule;
  final String notes;

  const Diet({
    required this.id,
    required this.mealName,
    required this.quantity,
    required this.schedule,
    required this.notes,
  });

  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      id: json['id'],
      mealName: json['mealName'],
      quantity: json['quantity'],
      schedule: json['schedule'],
      notes: json['notes'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealName': mealName,
      'quantity': quantity,
      'schedule': schedule,
      'notes': notes,
    };
  }
}