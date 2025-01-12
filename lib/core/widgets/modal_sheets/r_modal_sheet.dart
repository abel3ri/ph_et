import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/widgets/list_tiles/r_list_tile.dart';

class RModalBottomSheet extends StatelessWidget {
  const RModalBottomSheet({
    super.key,
    required this.label,
    required this.children,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(),
        ),
        ...children,
        RListTile(
          title: "Cancel".tr,
          leadingIcon: Icons.close,
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}
