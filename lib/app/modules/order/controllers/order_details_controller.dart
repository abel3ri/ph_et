import 'package:fpdart/fpdart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/order_model.dart';
import 'package:pharma_et/app/data/models/product_item_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/app/data/services/order_service.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/core/widgets/dialogs/r_show_dialog.dart';

class OrderDetailsController extends GetxController {
  late OrderService orderService;
  late ProductItemService productItemService;

  OrderModel? order;

  String? orderId;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    orderService = Get.find<OrderService>();
    productItemService = Get.find<ProductItemService>();

    orderId = Get.arguments?['orderId'];
    if (orderId != null) {
      watchOrder(orderId!);
    }
  }

  void watchOrder(String orderId) {
    isLoading(true);
    orderService.watchOrder(orderId).listen((res) {
      res.fold((l) {
        l.showError();
        isLoading(false);
      }, (r) {
        order = r;
        isLoading(false);
      });
    });
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

  Future<List<Either<ErrorModel, ProductItemModel>>> getOrderProdFutures(
      OrderModel order) {
    final productsFuture = Future.wait(
      order.products!.map(
        (item) => productItemService.findProduct(productId: item['id']),
      ),
    );

    return productsFuture;
  }

  Future<void> editOrder(Map<String, dynamic> data) async {
    if (orderId == null) return;
    final result = await rShowDialog(
      title: "Modify Order",
      content: "Are you sure you want to modify this order?",
      mainActionLabel: "Proceed",
    );

    if (result ?? false) {
      isLoading(true);
      final res = await orderService.updateOrder(orderId!, data);

      res.fold((l) {
        l.showError();
      }, (r) {
        SuccessModel(body: "Order updated successfully").showSuccess();
      });
    }
  }
}
