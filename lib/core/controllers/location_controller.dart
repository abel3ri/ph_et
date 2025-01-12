import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/location_service.dart';

class LocationController extends GetxController {
  Rx<Position?> userPosition = Rx<Position?>(null);
  Rx<bool> isLoading = false.obs;
  late GeolocatorPlatform geolocator;

  @override
  void onInit() {
    super.onInit();
    geolocator = GeolocatorPlatform.instance;
    Get.lazyPut(() => LocationService());
  }

  Future<void> getUserCurrentPosition() async {
    final locationProvider = Get.find<LocationService>();
    isLoading(true);
    final res = await locationProvider.getCurrentPosition();
    isLoading(false);
    res.fold((l) {
      l.showError();
    }, (r) {
      userPosition(r);
    });
  }
}
