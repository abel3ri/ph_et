import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/app/modules/cart/controllers/checkout_controller.dart';
import 'package:pharma_et/core/controllers/location_controller.dart';
import 'package:pharma_et/core/widgets/dialogs/r_show_dialog.dart';

class SelectAddressController extends GetxController {
  GoogleMapController? googleMapController;
  late LocationController locationController;
  late CheckoutController checkoutController;

  @override
  void onInit() {
    super.onInit();
    locationController = Get.find<LocationController>();
    checkoutController = Get.find<CheckoutController>();
  }

  @override
  void onReady() {
    super.onReady();
    checkLocationAccess();
  }

  Future<void> checkLocationAccess() async {
    final useCurrentLocation = await rShowDialog(
      title: "Enable Location",
      content: "Your location is required to know your delivery address.",
      mainActionLabel: "Enable Location Access",
      cancelLabel: "Pick Delivery Address Manually",
    );

    if (useCurrentLocation ?? false) {
      await locationController.getUserCurrentPosition();
      if (locationController.userPosition.value != null) {
        final position = locationController.userPosition.value!;
        googleMapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
        checkoutController.selectedAddress.value = LatLng(
          position.latitude,
          position.longitude,
        );
        SuccessModel(body: "Location address recorded").showSuccess();
      } else {
        ErrorModel(body: "Failed to fetch location.").showError();
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    googleMapController?.dispose();
  }
}
