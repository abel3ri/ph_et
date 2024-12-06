import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';

class ImageService extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
    httpClient.baseUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/';
  }

  Future<Either<ErrorModel, Map<String, dynamic>>> uploadImage({
    required File imageFile,
    String uploadPreset = "public",
  }) async {
    try {
      final formData = FormData(
        {
          'file': MultipartFile(
            imageFile,
            filename: imageFile.path.split('/').last,
          ),
          'upload_preset': uploadPreset,
        },
      );

      final res = await post("/upload", formData);

      if (!res.hasError) {
        return right({
          "url": res.body['url'],
          "publicId": res.body['public_id'],
        });
      } else {
        return left(
          ErrorModel(
            body: res.body?['error']?['message'] ?? "Failed to upload image",
          ),
        );
      }
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> deleteImage({
    required Map<String, dynamic> image,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final String signatureString =
          'public_id=${image['publicId']}&timestamp=$timestamp${dotenv.env['CLOUDINARY_API_SECRET']}';

      final String signature =
          sha1.convert(utf8.encode(signatureString)).toString();

      final res = await post("/destroy", {
        "public_id": image['publicId'],
        'api_key': dotenv.env['CLOUDINARY_API_KEY'],
        'signature': signature,
        "timestamp": timestamp.toString(),
      });

      if (!res.hasError) {
        return right(SuccessModel(body: "Image deleted successfully!"));
      } else {
        return left(
          ErrorModel(
            body: res.body?['error']?['message'] ?? "Failed to delete image",
          ),
        );
      }
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }
}
