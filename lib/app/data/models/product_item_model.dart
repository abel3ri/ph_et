class ProductItemModel {
  ProductItemModel({
    this.productId,
    this.subCategoryId,
    this.name,
    this.description,
    this.imageUrl,
    this.price,
    this.createdAt,
    this.quantity = 1,
  });

  final String? productId;
  final String? subCategoryId;
  final String? name;
  final String? description;
  final String? price;
  final Map<String, dynamic>? imageUrl;
  final DateTime? createdAt;
  int quantity;

  double get totalPrice {
    return (double.tryParse(price ?? '0.0') ?? 0.0) * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      "subCategoryId": subCategoryId,
      'createdAt': createdAt?.toIso8601String(),
      'quantity': quantity,
    };
  }

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      productId: json['productId'] as String?,
      subCategoryId: json['subCategoryId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] as String?,
      imageUrl: json['imageUrl'] as Map<String, dynamic>?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      quantity: json['quantity'] ?? 1,
    );
  }
}
