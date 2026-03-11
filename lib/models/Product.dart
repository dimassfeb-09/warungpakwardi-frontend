class Product {
  final String id;
  final String name;
  final num price;
  final int amountPerUnit;
  final String unit;
  final int stock;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? userId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.amountPerUnit,
    required this.unit,
    required this.stock,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'amount_per_unit': amountPerUnit,
      'unit': unit,
      'stock': stock,
      'created_at':
          createdAt?.toIso8601String(), // Convert DateTime to ISO String
      'updated_at': updatedAt?.toIso8601String(),
      'user_id': userId,
    };
  }

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      amountPerUnit: map['amount_per_unit'],
      unit: map['unit'],
      stock: map['stock'],
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
      userId: map['user_id'],
    );
  }

  // Method to handle date parsing
  static DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;
    return DateTime.tryParse(dateString); // Parse with DateTime
  }

  Product copyWith({
    String? id,
    String? name,
    num? price,
    int? amountPerUnit,
    String? unit,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isDeleted,
    int? userId,
    int? isSynced,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      amountPerUnit: amountPerUnit ?? this.amountPerUnit,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}
