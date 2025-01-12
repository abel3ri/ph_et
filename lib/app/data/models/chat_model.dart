import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? id;
  String? text;
  String? senderId;
  DateTime? createdAt;

  ChatModel({
    this.id,
    this.text,
    this.senderId,
    this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      text: json['text'],
      senderId: json['senderId'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (json['createdAt'] as Timestamp).millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'senderId': senderId,
      'createdAt': createdAt,
    };
  }
}
