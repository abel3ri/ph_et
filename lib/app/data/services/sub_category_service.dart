import 'package:fpdart/fpdart.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/sub_Category_model.dart';
import 'package:pharma_et/app/data/services/base_service.dart';

class SubCategoryService extends BaseService<SubCategoryModel> {
  @override
  SubCategoryModel fromJson(Map<String, dynamic> json) {
    return SubCategoryModel.fromJson(json);
  }

  Future<Either<ErrorModel, List<SubCategoryModel>>> findAllSubCategories(
    String categoryId,
  ) {
    return findAll(
      collectionPath: "subCategories",
      queryBuilder: db
          .collection("subCategories")
          .where("categoryId", isEqualTo: categoryId),
    );
  }

  Stream<Either<ErrorModel, List<SubCategoryModel>>> watchAllSubCategories(
    String categoryId,
  ) {
    return watchAll(
      collectionPath: "subCategories",
      queryBuilder: db
          .collection("subCategories")
          .where("categoryId", isEqualTo: categoryId),
    );
  }

  Future<int> countProductsInSubCategory(String subCategoryId) async {
    final res = await db
        .collection("products")
        .where("subCategoryId", isEqualTo: subCategoryId)
        .count()
        .get();
    return res.count ?? 0;
  }
}
