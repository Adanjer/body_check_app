class Measurement {
  final DateTime date;
  final double weight;
  final double waist;
  final double chest;
  final double height; // New height field

  Measurement({
    required this.date,
    required this.weight,
    required this.waist,
    required this.chest,
    required this.height, // Initialize height
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
      'waist': waist,
      'chest': chest,
      'height': height, // Add height to the map
    };
  }

  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      date: DateTime.parse(map['date']),
      weight: map['weight'],
      waist: map['waist'],
      chest: map['chest'],
      height: map['height'], // Extract height from the map
    );
  }
}
