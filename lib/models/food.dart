class LoungeFood {
  final int id;
  final double? price;
  final double? rating;
  final Food food;

  LoungeFood({
    required this.id,
    this.price,
    this.rating,
    required this.food,
  });

  factory LoungeFood.fromMap(Map<String, dynamic> map) {
    return LoungeFood(
      id: map['id'],
      price: (map['price'] as num?)?.toDouble(),
      rating: (map['rating'] as num?)?.toDouble(),
      food: Food.fromMap(map['Food']),
    );
  }
}

class Food {
  final String name;
  final String? description;
  final String? imageUrl;
  final bool? isFasting;

  Food({
    required this.name,
    this.description,
    this.imageUrl,
    this.isFasting,
  });

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      isFasting: map['isFasting'],
    );
  }
}
