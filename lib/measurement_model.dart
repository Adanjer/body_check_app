class Measurement {
  final DateTime date;
  final double weight;
  final String weightUnit; // Unit for weight
  final double waist;
  final String waistUnit; // Unit for waist
  final double chest;
  final String chestUnit; // Unit for chest
  final double height;
  final String heightUnit; // Unit for height

  Measurement({
    required this.date,
    required this.weight,
    required this.weightUnit,
    required this.waist,
    required this.waistUnit,
    required this.chest,
    required this.chestUnit,
    required this.height,
    required this.heightUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
      'weightUnit': weightUnit,
      'waist': waist,
      'waistUnit': waistUnit,
      'chest': chest,
      'chestUnit': chestUnit,
      'height': height,
      'heightUnit': heightUnit,
    };
  }

  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      date: DateTime.parse(map['date']),
      weight: map['weight'],
      weightUnit: map['weightUnit'],
      waist: map['waist'],
      waistUnit: map['waistUnit'],
      chest: map['chest'],
      chestUnit: map['chestUnit'],
      height: map['height'],
      heightUnit: map['heightUnit'],
    );
  }
}
