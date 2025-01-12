class ReviewModel {
  ReviewModel({
    this.reviewId,
    this.userId,
    this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.productId,
  });

  String? reviewId;
  final String? userId;
  final double? rating;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? productId;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['reviewId'] as String?,
      userId: json['userId'] as String?,
      rating:
          (json['rating'] != null) ? (json['rating'] as num).toDouble() : null,
      comment: json['comment'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      productId: json['productId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'productId': productId,
    };
  }
}
