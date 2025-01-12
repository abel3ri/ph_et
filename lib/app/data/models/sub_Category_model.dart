class SubCategoryModel {
  SubCategoryModel({
    this.subCategoryId,
    this.name,
    this.description,
    this.categoryId,
    this.imageUrl,
    this.productCount,
    this.createdAt,
  });
  final String? subCategoryId;
  final String? name;
  final String? description;
  final String? categoryId;
  final Map<String, dynamic>? imageUrl;
  final int? productCount;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      "subCategoryId": subCategoryId,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      "productCount": productCount,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      subCategoryId: json['subCategoryId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String?,
      imageUrl: json['imageUrl'] as Map<String, dynamic>?,
      productCount: json['productCount'] as int?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
