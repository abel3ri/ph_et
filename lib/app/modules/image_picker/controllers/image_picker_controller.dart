import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharma_et/app/data/models/error_model.dart';

class ImagePickerController extends GetxController {
  Rx<String?> profileImagePath = Rx<String?>(null);
  Rx<String?> categoryImagePath = Rx<String?>(null);
  Rx<String?> subCategoryImagePath = Rx<String?>(null);

  Future<Either<ErrorModel, File>> pickImageFromCamera() async {
    try {
      XFile? pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 100);
      if (pickedFile == null) {
        return left(ErrorModel(body: "No image selected!"));
      }

      final compressedBytes = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 85,
        minWidth: 600,
        minHeight: 600,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null) {
        return left(ErrorModel(body: "Failed to compress the image!"));
      }

      final appDocDir = await getTemporaryDirectory();
      final fileName = pickedFile.path.split('/').last;
      final compressedImage = await File('${appDocDir.path}/$fileName')
          .writeAsBytes(compressedBytes);

      return right(compressedImage);
    } catch (err) {
      return left(ErrorModel(body: err.toString()));
    }
  }

  Future<Either<ErrorModel, File>> pickImageFromGallery() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (pickedFile == null) {
        return left(ErrorModel(body: "No image selected!"));
      }
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 85,
        minWidth: 600,
        minHeight: 600,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null) {
        return left(ErrorModel(body: "Failed to compress the image!"));
      }

      final appDocDir = await getTemporaryDirectory();
      final fileName = pickedFile.path.split('/').last;
      final compressedImage = await File('${appDocDir.path}/$fileName')
          .writeAsBytes(compressedBytes);

      return right(compressedImage);
    } catch (err) {
      return left(ErrorModel(body: err.toString()));
    }
  }

  Future<Either<ErrorModel, List<XFile>>> pickMultipleImages() async {
    try {
      final List<XFile> images = await ImagePicker().pickMultiImage(
        imageQuality: 80,
        limit: 5,
      );

      if (images.isEmpty) {
        return left(ErrorModel(body: "No image selected!"));
      }

      List<XFile> compressedImages = [];

      final tempDir = await getTemporaryDirectory();

      for (var image in images) {
        final compressedBytes = await FlutterImageCompress.compressWithFile(
          image.path,
          quality: 85,
          minWidth: 600,
          minHeight: 600,
          format: CompressFormat.jpeg,
        );

        if (compressedBytes != null) {
          final compressedFilePath = '${tempDir.path}/${image.name}';
          final compressedFile =
              await File(compressedFilePath).writeAsBytes(compressedBytes);

          compressedImages.add(XFile(compressedFile.path));
        }
      }

      return right(compressedImages);
    } catch (err) {
      return left(ErrorModel(body: err.toString()));
    }
  }

  @override
  void onClose() {
    super.onClose();
    profileImagePath.close();
    categoryImagePath.close();
    subCategoryImagePath.close();
  }
}
