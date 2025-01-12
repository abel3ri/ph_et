import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  const MapView({required this.position, super.key});

  final LatLng position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          "Delivery Address",
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 14,
          target: position,
        ),
        trafficEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId("Delivery Position"),
            position: position,
          ),
        },
      ),
    );
  }
}
