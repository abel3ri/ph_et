import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/consultation/controllers/consultation_controller.dart';
import 'package:pharma_et/app/modules/consultation/widgets/r_chat_container.dart';
import 'package:pharma_et/app/modules/consultation/widgets/r_chat_input.dart';
import 'package:pharma_et/app/modules/consultation/widgets/s_chat_container.dart';

class ConsultationView extends GetView<ConsultationController> {
  const ConsultationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: Text(
          "Consult with a professional",
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final messages = controller.messages;

              if (messages.isEmpty) {
                return const Center(child: Text('No messages yet.'));
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  final isSentByUser = message.senderId == controller.userId;
                  return !isSentByUser
                      ? RChatContainer(
                          message: message.text!,
                          sender: "Consultant",
                          date: message.createdAt!,
                        )
                      : SChatContainer(
                          message: message.text!,
                          sender: "You",
                          date: message.createdAt!,
                        );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: RChatInput(
                    maxLines: null,
                    controller: controller.messageController,
                    hintText: "Type your message...",
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    validator: (value) => null,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.sendMessage();
                  },
                  icon: Icon(
                    Icons.send,
                    size: 32,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
