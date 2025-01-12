import 'package:fpdart/fpdart.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/order_model.dart';
import 'package:pharma_et/app/data/services/base_service.dart';

class OrderService extends BaseService<OrderModel> {
  @override
  OrderModel fromJson(Map<String, dynamic> json) {
    return OrderModel.fromJson(json);
  }

  Future<Either<ErrorModel, List<OrderModel>>> findAllOrdersByUser(
      String userId) {
    return findAll(
      collectionPath: "orders",
      queryBuilder: db.collection("orders").where("userId", isEqualTo: userId),
    );
  }

  Stream<Either<ErrorModel, List<OrderModel>>> watchAllOrdersByUser(
      String userId) {
    return watchAll(
      collectionPath: "orders",
      queryBuilder: db
          .collection("orders")
          .where("userId", isEqualTo: userId)
          .orderBy("createdAt", descending: true),
    );
  }

  Future<Either<ErrorModel, void>> updateOrder(
    String orderId,
    Map<String, dynamic> data,
  ) {
    return updateOne(
      collectionPath: "orders",
      docId: orderId,
      data: data,
    );
  }

  Future<Either<ErrorModel, OrderModel>> createOrder(OrderModel order) async {
    try {
      final orderMap = order.toJson();
      final result = await createOne(
        collectionPath: "orders",
        data: orderMap,
        idFieldName: "orderId",
      );
      return result;
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Stream<Either<ErrorModel, OrderModel>> watchOrder(String orderId) {
    return watchOne(collectionPath: "orders", docId: orderId);
  }
}
