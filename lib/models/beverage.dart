class LoungeBeverage {
  final int id;
  final double? price;
  final double? rating;
  final Beverage beverage;

  LoungeBeverage({
    required this.id,
    this.price,
    this.rating,
    required this.beverage,
  });

  factory LoungeBeverage.fromMap(Map<String, dynamic> map) {
    return LoungeBeverage(
      id: map['id'],
      price: (map['price'] as num?)?.toDouble(),
      rating: (map['rating'] as num?)?.toDouble(),
      beverage: Beverage.fromMap(map['Beverage']),
    );
  }
}

class Beverage {
  final String name;
  final String? description;
  final String? imageUrl;
  final bool? isFasting;

  Beverage({
    required this.name,
    this.description,
    this.imageUrl,
    this.isFasting,
  });

  factory Beverage.fromMap(Map<String, dynamic> map) {
    return Beverage(
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      isFasting: map['isFasting'],
    );
  }
}
