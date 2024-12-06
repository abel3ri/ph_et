import 'package:fpdart/fpdart.dart';
import 'package:pharma_et/app/data/models/category_model.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/services/BaseService.dart';

class CategoryService extends BaseService<CategoryModel> {
  @override
  CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel.fromJson(json);
  }

  Future<Either<ErrorModel, List<CategoryModel>>> findAllCategories() {
    return findAll(collectionPath: "categories");
  }

  Stream<Either<ErrorModel, List<CategoryModel>>> watchAllCategories() {
    return watchAll(collectionPath: "categories");
  }
}
