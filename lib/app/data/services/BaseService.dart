import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/core/utils/handle_firebase_errors.dart';

abstract class BaseService<T> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  T fromJson(Map<String, dynamic> json);

  Future<Either<ErrorModel, List<T>>> findAll({
    required String collectionPath,
    Query<Map<String, dynamic>>? queryBuilder,
  }) async {
    try {
      Query<Map<String, dynamic>> query = db.collection(collectionPath);
      if (queryBuilder != null) {
        query = queryBuilder;
      }

      final res = await query.get();
      final data = res.docs.map((doc) => fromJson(doc.data())).toList();

      return right(data);
    } on FirebaseException catch (e) {
      return left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Stream<Either<ErrorModel, List<T>>> watchAll({
    required String collectionPath,
    Query<Map<String, dynamic>>? queryBuilder,
  }) async* {
    try {
      Query<Map<String, dynamic>> query = db.collection(collectionPath);
      if (queryBuilder != null) {
        query = queryBuilder;
      }

      yield* query.snapshots(includeMetadataChanges: true).map((snapshot) {
        if (snapshot.docs.isEmpty) {
          return right(<T>[]);
        }

        final data = snapshot.docs.map((doc) => fromJson(doc.data())).toList();
        return right(data);
      });
    } on FirebaseException catch (e) {
      yield left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      yield left(ErrorModel(body: e.toString()));
    }
  }
}
