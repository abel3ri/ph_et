import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/product_item_model.dart';

class CartController extends GetxController {
  Rx<List<ProductItemModel>> cartItems = Rx<List<ProductItemModel>>([]);
  Rx<bool> isLoading = false.obs;

  Rx<String> radioGroupValue = "digital_payment".obs;

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
}
