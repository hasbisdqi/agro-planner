class Plant {
  final int? id;
  final String name;
  final double area;
  final String plantDate;
  final String harvestDate;

  Plant({
    this.id,
    required this.name,
    required this.area,
    required this.plantDate,
    required this.harvestDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'plantDate': plantDate,
      'harvestDate': harvestDate,
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] as int?,
      name: map['name'] as String,
      area: (map['area'] as num).toDouble(),
      plantDate: map['plantDate'] as String,
      harvestDate: map['harvestDate'] as String,
    );
  }

  Plant copyWith({
    int? id,
    String? name,
    double? area,
    String? plantDate,
    String? harvestDate,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      area: area ?? this.area,
      plantDate: plantDate ?? this.plantDate,
      harvestDate: harvestDate ?? this.harvestDate,
    );
  }
}
