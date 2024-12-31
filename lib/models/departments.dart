class Department {
  final int? id;
  final DateTime? createdAt;
  final String? name;
  final String? description;
  final int? blockNumber;
  final int? roomNumber;
  final bool? isEngineering;

  Department({
    this.id,
    this.createdAt,
    this.name,
    this.description,
    this.blockNumber,
    this.roomNumber,
    this.isEngineering,
  });

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      name: map['name'],
      description: map['description'],
      blockNumber: map['blockNumber'],
      roomNumber: map['roomNumber'],
      isEngineering: map['isEngineering'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'name': name,
      'description': description,
      'blockNumber': blockNumber,
      'roomNumber': roomNumber,
      'isEngineering': isEngineering,
    };
  }
}
