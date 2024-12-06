class CategoryModel {
  CategoryModel({
    this.name,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.categoryId,
  });

  final String? categoryId;
  final String? name;
  final String? description;
  final Map<String, dynamic>? imageUrl;
  final DateTime? createdAt;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
