class AdModel {
  AdModel({
    this.adId,
    this.title,
    this.link,
    this.imageUrl,
    this.priority,
    this.startDate,
    this.endDate,
    this.showTitle,
  });

  final String? adId;
  final String? title;
  final String? link;
  final Map<String, dynamic>? imageUrl;
  final int? priority;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? showTitle;

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      adId: json['adId'],
      title: json['title'] as String?,
      showTitle: json['showTitle'] as bool?,
      link: json['link'] as String?,
      imageUrl: json['imageUrl'] as Map<String, dynamic>?,
      priority: json['priority'] as int?,
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "adId": adId,
      "title": title,
      'link': link,
      "priority": priority,
      'imageUrl': imageUrl,
      "showTitle": showTitle,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
