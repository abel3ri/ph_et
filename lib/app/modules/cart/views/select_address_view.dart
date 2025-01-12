import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/app/modules/cart/controllers/select_address_controller.dart';
import 'package:pharma_et/core/widgets/buttons/r_filled_button.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';

class SelectAddressView extends GetView<SelectAddressController> {
  const SelectAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final selectedAddress =
            controller.checkoutController.selectedAddress.value;
        return Stack(
          children: [
            GoogleMap(
              trafficEnabled: true,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: selectedAddress != null
                    ? LatLng(
                        selectedAddress.latitude, selectedAddress.longitude)
                    : const LatLng(9.018981086642524, 38.75158113579755),
                zoom: 11.0,
              ),
              onTap: (position) {
                controller.checkoutController.selectedAddress.value = position;
              },
              onMapCreated: (mapController) {
                controller.googleMapController = mapController;
              },
              markers: {
                if (controller.checkoutController.selectedAddress.value != null)
                  Marker(
                    markerId: const MarkerId("position"),
                    position:
                        controller.checkoutController.selectedAddress.value!,
                  ),
              },
            ),
            Positioned(
              top: 32,
              right: 16,
              child: RFilledButton(
                onPressed:
                    controller.checkoutController.selectedAddress.value == null
                        ? null
                        : () {
                            Get.back();
                          },
                label: "Done",
              ),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () async {
            controller.locationController.userPosition.value = null;
            await controller.locationController
                .getUserCurrentPosition()
                .then((_) async {
              final position = controller.locationController.userPosition.value;

              if (position == null) {
                await Get.snackbar("Error", "Unable to get location address.")
                    .show();
              } else {
                controller.googleMapController?.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(position.latitude, position.longitude),
                  ),
                );
                controller.checkoutController.selectedAddress.value = LatLng(
                  position.latitude,
                  position.longitude,
                );
                SuccessModel(body: "Location address recorded").showSuccess();
              }
            });
          },
          tooltip: "My Location",
          child: controller.locationController.isLoading.isTrue
              ? const FittedBox(child: RLoading())
              : const Icon(Icons.location_on_rounded),
        ),
      ),
    );
  }
}
