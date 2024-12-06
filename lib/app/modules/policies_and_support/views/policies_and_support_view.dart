import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/policies_and_support_controller.dart';

class PoliciesAndSupportView extends GetView<PoliciesAndSupportController> {
  const PoliciesAndSupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PoliciesAndSupportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PoliciesAndSupportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
