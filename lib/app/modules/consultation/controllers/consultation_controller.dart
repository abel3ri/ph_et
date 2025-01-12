import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/chat_model.dart';
import 'package:pharma_et/app/data/services/chat_service.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';

class ConsultationController extends GetxController {
  final RxList<ChatModel> messages = <ChatModel>[].obs;
  final messageController = TextEditingController();

  late AuthController authController;
  late ChatService chatService;

  late String userId;

  @override
  void onInit() {
    super.onInit();
    authController = Get.find<AuthController>();
    chatService = Get.find<ChatService>();
    userId = authController.currentUser.value?.userId ?? "";
    _listenToMessages();
  }

  void _listenToMessages() {
    chatService.watchChatMessages(userId).listen((data) {
      messages.value = data;
    });
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;
    DateTime messageSentAt = DateTime.now();

    final message = ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: messageController.text.trim(),
      senderId: userId,
      createdAt: messageSentAt,
    );

    await chatService.sendMessage(chatId: userId, message: message);

    chatService.db.collection("chats").doc(userId).set({
      "lastMessage": messageController.text.trim(),
      "lastMessageAt": messageSentAt,
      "chatId": userId,
    });

    messageController.text = '';
  }

  @override
  void onClose() {
    super.onClose();
    messageController.dispose();
  }
}
