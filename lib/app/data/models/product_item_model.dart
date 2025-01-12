class ProductItemModel {
  ProductItemModel({
    this.productId,
    this.subCategoryId,
    this.name,
    this.description,
    this.images,
    this.price,
    this.createdAt,
    this.quantity = 1,
    this.averageRating,
    this.totalRatings,
    this.ingredients,
  });

  final String? productId;
  final String? subCategoryId;
  final String? name;
  final String? description;
  final String? price;
  final List<Map<String, dynamic>>? images;
  final DateTime? createdAt;
  final double? averageRating;
  final int? totalRatings;
  final List<String>? ingredients;
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
      'images': images,
      "subCategoryId": subCategoryId,
      'createdAt': createdAt?.toIso8601String(),
      'quantity': quantity,
      "averageRating": averageRating,
      "totalRatings": totalRatings,
      "ingredients": ingredients,
    };
  }

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      productId: json['productId'] as String?,
      subCategoryId: json['subCategoryId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] as String?,
      images: json['images'] != null
          ? List<Map<String, dynamic>>.from(json['images'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      quantity: json['quantity'] ?? 1,
      averageRating: json['averageRating'] != null
          ? (json['averageRating'] as num).toDouble()
          : 0.0,
      totalRatings: json['totalRatings'] as int?,
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
    );
  }
}
