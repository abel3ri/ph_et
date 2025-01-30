import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/product_item_model.dart';
import 'package:pharma_et/app/data/services/base_service.dart';
import 'package:pharma_et/core/utils/handle_firebase_errors.dart';

class ProductItemService extends BaseService<ProductItemModel> {
  @override
  ProductItemModel fromJson(Map<String, dynamic> json) {
    return ProductItemModel.fromJson(json);
  }

  Future<Either<ErrorModel, List<ProductItemModel>>> findAllProducts(
    String subCategoryId, {
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    try {
      Query<Map<String, dynamic>> query = db
          .collection("products")
          .where("subCategoryId", isEqualTo: subCategoryId)
          .orderBy("name")
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final res = await query.get();
      final data = res.docs
          .map((doc) => ProductItemModel.fromJson(doc.data(), snapshot: doc))
          .toList();

      return right(data);
    } on FirebaseException catch (e) {
      return left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Stream<Either<ErrorModel, List<ProductItemModel>>> watchAllProducts(
    String subCategoryId,
  ) {
    return watchAll(
      collectionPath: "products",
      queryBuilder: db
          .collection("products")
          .where("subCategoryId", isEqualTo: subCategoryId),
    );
  }

  Stream<Either<ErrorModel, ProductItemModel>> watchProduct({
    required String productId,
  }) {
    return watchOne(collectionPath: "products", docId: productId);
  }

  Future<Either<ErrorModel, ProductItemModel>> findProduct({
    required String productId,
  }) async {
    return await findOne(collectionPath: "products", docId: productId);
  }

  Stream<Either<ErrorModel, List<ProductItemModel>>> watchTopPicks({
    int limit = 10,
  }) {
    return watchAll(
      collectionPath: "products",
      queryBuilder: db
          .collection("products")
          .orderBy("averageRating", descending: true)
          .orderBy("totalRatings", descending: true)
          .limit(limit),
    );
  }
}
