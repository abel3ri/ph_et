import 'package:fpdart/fpdart.dart';
import 'package:pharma_et/app/data/models/ad_model.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/services/base_service.dart';

class AdService extends BaseService<AdModel> {
  @override
  AdModel fromJson(Map<String, dynamic> json) {
    return AdModel.fromJson(json);
  }

  Future<Either<ErrorModel, List<AdModel>>> fetchAllAds() {
    return findAll(collectionPath: "ads");
  }

  Stream<Either<ErrorModel, List<AdModel>>> watchAllAds() {
    return watchAll(collectionPath: "ads");
  }
}
