import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/core/controllers/location_controller.dart';

class LocationService extends GetConnect {
  late GeolocatorPlatform geolocator;
  @override
  void onInit() {
    super.onInit();
    geolocator = Get.find<LocationController>().geolocator;
  }

  Future<Either<ErrorModel, Position>> getCurrentPosition() async {
    try {
      final res = await requestPermission();
      return res.fold(
        (l) {
          return left(l);
        },
        (r) async {
          try {
            final userPosition = await geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
              ),
            );
            return right(userPosition);
          } catch (e) {
            return left(ErrorModel(body: e.toString()));
          }
        },
      );
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Future<Either<ErrorModel, bool>> requestPermission() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return left(
          ErrorModel(
            body: "Location services are disabled. Please enable Location.",
          ),
        );
      }

      permission = await geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return left(ErrorModel(body: "Location permission denied."));
        }

        if (permission == LocationPermission.deniedForever) {
          throw Exception("App is denied to use location.");
        }
      }
      return right(true);
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }
}
