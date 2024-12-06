import 'package:get/get.dart';
import 'package:pharma_et/app/modules/search/controllers/search_controller.dart';

class HomeWrapperController extends GetxController {
  Rx<int> index = 0.obs;
  late SearchController searchController;

  @override
  void onInit() {
    super.onInit();
    searchController = Get.find<SearchController>();
  }

  void onPageChanged(int i) {
    if (i != 1) {
      if (Get.focusScope?.hasFocus ?? false) {
        Get.focusScope!.unfocus();
      }

      searchController.searchResults.value = [];
      searchController.searchController.text = "";
      searchController.isLoading.value = false;
      searchController.animateSearchLottie.value = false;
    } else {
      searchController.animateSearchLottie.value = true;
    }

    index.value = i;
  }
}
