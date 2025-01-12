
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

      final res = await query.orderBy("createdAt").get();
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

  Future<Either<ErrorModel, T>> findOne({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      final doc = await db.collection(collectionPath).doc(docId).get();

      if (!doc.exists) {
        return left(ErrorModel(body: "Document not found."));
      }

      final data = fromJson(doc.data()!);
      return right(data);
    } on FirebaseException catch (e) {
      return left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Stream<Either<ErrorModel, T>> watchOne({
    required String collectionPath,
    required String docId,
  }) async* {
    try {
      yield* db.collection(collectionPath).doc(docId).snapshots().map((doc) {
        if (!doc.exists) {
          return left(ErrorModel(body: "Document not found."));
        }
        final data = fromJson(doc.data()!);
        return right(data);
      });
    } on FirebaseException catch (e) {
      yield left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      yield left(ErrorModel(body: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> updateOne({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = db.collection(collectionPath).doc(docId);
      await docRef.update(data);
      return right(null);
    } on FirebaseException catch (e) {
      return left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Future<Either<ErrorModel, T>> createOne({
    required String collectionPath,
    required Map<String, dynamic> data,
    required String idFieldName,
  }) async {
    try {
      final docRef = await db.collection(collectionPath).add(data);
      await docRef.update({
        idFieldName: docRef.id,
      });

      final doc = await docRef.get();

      return right(fromJson(doc.data()!));
    } on FirebaseException catch (e) {
      return left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }
}
