import 'dart:io';

import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/order_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/app/data/services/image_service.dart';
import 'package:pharma_et/app/data/services/order_service.dart';
import 'package:pharma_et/app/modules/cart/controllers/cart_controller.dart';
import 'package:pharma_et/app/modules/home_wrapper/controllers/home_wrapper_controller.dart';
import 'package:pharma_et/app/modules/image_picker/controllers/image_picker_controller.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';
import 'package:pharma_et/core/widgets/dialogs/r_show_dialog.dart';

class CheckoutController extends GetxController {
  Rxn<String> selectedPaymentOption = Rxn<String>();
  Rx<String?> holderName = Rx<String?>(null);
  Rx<LatLng?> selectedAddress = Rx<LatLng?>(null);

  RxBool isLoading = false.obs;

  late ImagePickerController imagePickerController;
  late OrderService orderService;
  late ImageService imageService;
  late CartController cartController;

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    imagePickerController = Get.find<ImagePickerController>();
    orderService = Get.find<OrderService>();
    imageService = Get.find<ImageService>();
    cartController = Get.find<CartController>();

    Chapa.configure(
      privateKey: dotenv.env['CHAPA_TEST_PRIVATE_KEY'] ?? "",
    );
  }

  void updateSelectedPaymentOption(String? value) {
    selectedPaymentOption.value = value;
    update();
  }

  void updateHolderName(String? name) {
    holderName.value = name;
  }

  Future<void> createOrder() async {
    final result = cartController.radioGroupValue.value != "digital_payment"
        ? await rShowDialog(
            title: "Confirm Your Order Information",
            content:
                "Please review your order details carefully before proceeding. "
                "Are you sure all the information is correct?",
            mainActionLabel: "Confirm",
            cancelLabel: "Close",
          )
        : true;

    if (result ?? false) {
      isLoading.value = true;

      Map<String, dynamic>? uploadedImage;

      if (cartController.radioGroupValue.value == "bank_transfer") {
        final res = await imageService.uploadImage(
          imageFile: File(imagePickerController.receiptImagePath.value!),
          uploadPreset: "order_images",
        );

        final uploadResult = res.fold((l) {
          ErrorModel(
            body:
                "Receipt image could not be uploaded. Please try the process again.",
          ).showError();
          return null;
        }, (r) => r);

        if (uploadResult == null) {
          isLoading.value = false;
          return;
        }

        uploadedImage = uploadResult;
      }

      final res = await orderService.createOrder(
        OrderModel(
          userFullName: fullNameController.text,
          userPhoneNumber: phoneController.text,
          userId: Get.find<AuthController>().currentUser.value?.userId,
          createdAt: DateTime.now(),
          deliveryAddress: GeoPoint(selectedAddress.value!.latitude,
              selectedAddress.value!.longitude),
          paymentMethod: cartController.radioGroupValue.value,
          products: cartController.cartItems.value
              .map((item) => {
                    "id": item.productId!,
                    "quantity": item.quantity,
                  })
              .toList(),
          status: "pending",
          ditinctItemQuantity: cartController.cartItems.value.length,
          totalAmount: cartController.totalAmount,
          receiptImage: uploadedImage,
        ),
      );

      res.fold((l) async {
        l.showError();
        if (uploadedImage != null) {
          await imageService.deleteImage(image: uploadedImage);
        }
      }, (r) {
        Get.find<HomeWrapperController>().index.value = 3;
        Get.until((route) => Get.currentRoute == '/home-wrapper');
        SuccessModel(body: "Order created successfully").showSuccess();
      });

      isLoading.value = false;
    }
  }

  Future<void> chapaPay() async {
    try {
      final currentUser = Get.find<AuthController>().currentUser.value;
      String txRef =
          TxRefRandomGenerator.generate(prefix: '${currentUser?.userId}');
      final result = await rShowDialog(
        title: "Confirm Your Order Information",
        content:
            "Please review your order details carefully before proceeding. "
            "Are you sure all the information is correct?",
        mainActionLabel: "Confirm",
        cancelLabel: "Close",
      );
      if (result ?? false) {
        isLoading.value = true;
        await Chapa.getInstance.startPayment(
          context: Get.context,
          onInAppPaymentSuccess: (successMsg) async {
            await createOrder();
          },
          onInAppPaymentError: (errorMsg) {
            ErrorModel(body: errorMsg).showError();
          },
          currency: 'ETB',
          amount: cartController.totalAmount.toString(),
          firstName: fullNameController.text.split(" ").first,
          lastName: fullNameController.text.split(" ").last,
          phoneNumber: phoneController.text,
          txRef: txRef,
        );
      }

      // isLoading(false);
    } on ChapaException catch (e) {
      if (e is AuthException) {
        ErrorModel(body: 'AuthException ${e.toString()}').showError();
      } else if (e is InitializationException) {
        ErrorModel(body: 'InitializationException ${e.toString()}').showError();
      } else if (e is NetworkException) {
        ErrorModel(body: 'NetworkException ${e.toString()}').showError();
      } else if (e is ServerException) {
        ErrorModel(body: 'ServerException ${e.toString()}').showError();
      } else {
        ErrorModel(body: 'Unknown error ${e.toString()}').showError();
      }
    } catch (e) {
      ErrorModel(body: 'Exception ${e.toString()}').showError();
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getPlaceName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.name}, ${place.locality}, ${place.country}";
      } else {
        return "No place found";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  @override
  void onClose() {
    super.onClose();
    fullNameController.dispose();
    phoneController.dispose();
  }
}
