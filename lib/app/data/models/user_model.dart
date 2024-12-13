class UserModel {
  UserModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.role,
    this.profileImage,
    this.isBlocked,
    this.createdAt,
  });

  String? userId;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? role;
  final bool? isBlocked;
  final DateTime? createdAt;
  final Map<String, dynamic>? profileImage;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      role: json['role'] ?? "user",
      profileImage: json['profileImage'],
      isBlocked: json['isBlocked'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'role': role,
      "profileImage": profileImage,
      "isBlocked": isBlocked,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
