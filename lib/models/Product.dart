class Product {
  final String id;
  final String name;
  final num price;
  final num purchasePrice;
  final int amountPerUnit;
  final String unit;
  final num stock;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? userId;

  final int isDeleted;
  final int isSynced;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.purchasePrice = 0,
    required this.amountPerUnit,
    required this.unit,
    required this.stock,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.isDeleted = 0,
    this.isSynced = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'purchase_price': purchasePrice,
      'amount_per_unit': amountPerUnit,
      'unit': unit,
      'stock': stock,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user_id': userId,
    };
  }

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'] ?? 0,
      purchasePrice: map['purchase_price'] ?? 0,
      amountPerUnit: map['amount_per_unit'] ?? 0,
      unit: map['unit'] ?? '',
      stock: map['stock'] ?? 0,
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
      userId: map['user_id'],
      isDeleted: 0,
      isSynced: 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'purchase_price': purchasePrice,
      'amount_per_unit': amountPerUnit,
      'unit': unit,
      'stock': stock,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user_id': userId,
      'is_deleted': isDeleted,
      'is_synced': isSynced,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'] ?? 0,
      purchasePrice: map['purchase_price'] ?? 0,
      amountPerUnit: map['amount_per_unit'] ?? 0,
      unit: map['unit'] ?? '',
      stock: map['stock'] ?? 0,
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
      userId: map['user_id'],
      isDeleted: map['is_deleted'] ?? 0,
      isSynced: map['is_synced'] ?? 1,
    );
  }

  // Method to handle date parsing
  static DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;
    return DateTime.tryParse(dateString);
  }

  Product copyWith({
    String? id,
    String? name,
    num? price,
    num? purchasePrice,
    int? amountPerUnit,
    String? unit,
    num? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? userId,
    int? isDeleted,
    int? isSynced,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      amountPerUnit: amountPerUnit ?? this.amountPerUnit,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isDeleted: isDeleted ?? this.isDeleted,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
