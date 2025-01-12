import 'package:pharma_et/app/data/models/chat_model.dart';
import 'package:pharma_et/app/data/services/base_service.dart';

class ChatService extends BaseService<ChatModel> {
  @override
  ChatModel fromJson(Map<String, dynamic> json) {
    return ChatModel.fromJson(json);
  }

  Future<void> sendMessage({
    required String chatId,
    required ChatModel message,
  }) async {
    try {
      await db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toJson());
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<List<ChatModel>> fetchChatMessages(String chatId) async {
    try {
      final querySnapshot = await db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => ChatModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch chat messages: $e');
    }
  }

  Stream<List<ChatModel>> watchChatMessages(String chatId) {
    try {
      return db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Failed to watch chat messages: $e');
    }
  }
}
