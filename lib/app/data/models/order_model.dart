import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? orderId;
  final String? userId;
  String? status;
  final String? paymentMethod;
  final Map<String, dynamic>? receiptImage;
  final double? totalAmount;
  final int? ditinctItemQuantity;
  final List<Map<String, dynamic>>? products;
  final GeoPoint? deliveryAddress;
  final String? userPhoneNumber;
  final String? userFullName;
  final DateTime? createdAt;

  OrderModel({
    this.orderId,
    this.userId,
    this.status,
    this.paymentMethod,
    this.receiptImage,
    this.totalAmount,
    this.ditinctItemQuantity,
    this.products,
    this.deliveryAddress,
    this.userFullName,
    this.userPhoneNumber,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] as String?,
      userId: json['userId'] as String?,
      status: json['status'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      receiptImage: json['receiptImage'] as Map<String, dynamic>?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      ditinctItemQuantity: json['ditinctItemQuantity'] as int?,
      products: json['products'] != null
          ? List<Map<String, dynamic>>.from(json['products'])
          : null,
      deliveryAddress: json['deliveryAddress'] != null
          ? json['deliveryAddress'] as GeoPoint
          : null,
      userFullName: json['userFullName'] as String?,
      userPhoneNumber: json['userPhoneNumber'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'status': status,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      "receiptImage": receiptImage,
      'ditinctItemQuantity': ditinctItemQuantity,
      "products": products,
      'deliveryAddress': deliveryAddress,
      "userFullName": userFullName,
      'userPhoneNumber': userPhoneNumber,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
