import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pharma_et/core/widgets/list_tiles/r_list_tile.dart';
import 'package:pharma_et/core/widgets/modal_sheets/r_modal_sheet.dart';

import '../controllers/image_picker_controller.dart';

class ImagePickerView extends GetView<ImagePickerController> {
  const ImagePickerView({
    super.key,
    this.imageType,
    this.label,
  });
  final String? imageType;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return RModalBottomSheet(
      label: label ?? "Pick Profile Image",
      children: [
        RListTile(
          title: "Gallery".tr,
          leadingIcon: Icons.image,
          onPressed: () async {
            final res = await controller.pickImageFromGallery();
            res.fold((l) {
              l.showError();
            }, (r) {
              if (imageType == "profile_image") {
                controller.profileImagePath(r.path);
              } else if (imageType == "category_image") {
                controller.categoryImagePath(r.path);
              } else if (imageType == "sub_category_image") {
                controller.subCategoryImagePath(r.path);
              }
              controller.update();
              Get.back();
            });
          },
        ),
        RListTile(
          title: "Camera".tr,
          leadingIcon: Icons.camera,
          onPressed: () async {
            final res = await controller.pickImageFromCamera();
            res.fold((l) {
              l.showError();
            }, (r) {
              if (imageType == "profile_image") {
                controller.profileImagePath(r.path);
              } else if (imageType == "category_image") {
                controller.categoryImagePath(r.path);
              } else if (imageType == "sub_category_image") {
                controller.subCategoryImagePath(r.path);
              }
              Get.back();
            });
          },
        ),
      ],
    );
  }
}
