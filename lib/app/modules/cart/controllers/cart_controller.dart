import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/product_item_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';

class CartController extends GetxController {
  Rx<List<ProductItemModel>> cartItems = Rx<List<ProductItemModel>>([]);
  Rx<bool> isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    Chapa.configure(
      privateKey: dotenv.env['CHAPA_TEST_PRIVATE_KEY'] ?? "",
    );
  }

  void addToCart(ProductItemModel product) {
    var existingProduct = cartItems.value
        .firstWhereOrNull((item) => item.productId == product.productId);

    if (existingProduct != null) {
      existingProduct.quantity++;
      cartItems.refresh();
    } else {
      cartItems.value.add(product);
      cartItems.refresh();
    }
  }

  void removeItemFromCart(ProductItemModel product) {
    var existingProduct = cartItems.value
        .firstWhereOrNull((item) => item.productId == product.productId);

    if (existingProduct != null && existingProduct.quantity > 1) {
      existingProduct.quantity--;
      cartItems.refresh();
    } else {
      cartItems.value
          .removeWhere((item) => item.productId == product.productId);
      cartItems.refresh();
    }
  }

  double get totalAmount {
    return cartItems.value.fold(0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> pay() async {
    isLoading(true);
    try {
      final currentUser = Get.find<AuthController>().currentUser.value;
      String txRef =
          TxRefRandomGenerator.generate(prefix: '${currentUser?.userId}');
      await Chapa.getInstance.startPayment(
        context: Get.context,
        onInAppPaymentSuccess: (successMsg) async {
          SuccessModel(body: successMsg).showSuccess();
        },
        onInAppPaymentError: (errorMsg) {
          ErrorModel(body: errorMsg).showError();
        },
        currency: 'ETB',
        amount: totalAmount.toString(),
        firstName: currentUser?.firstName,
        lastName: currentUser?.lastName,
        phoneNumber: currentUser?.phoneNumber,
        txRef: txRef,
      );
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
      isLoading(false);
    }
  }
}
