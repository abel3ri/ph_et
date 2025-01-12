import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/app/data/models/user_model.dart';
import 'package:pharma_et/core/utils/handle_firebase_errors.dart';

class UserService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Either<ErrorModel, UserModel>> findOne({
    required String userId,
  }) async {
    try {
      final res = await db.collection("users").doc(userId).get();
      final user = UserModel.fromJson(res.data()!);
      return right(user);
    } on FirebaseException catch (e) {
      return left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Stream<Either<ErrorModel, UserModel>> findOneAsStream({
    required String userId,
  }) {
    try {
      return db.collection("users").doc(userId).snapshots().map((snapshot) {
        if (snapshot.exists) {
          final user = UserModel.fromJson(snapshot.data()!);
          return Either<ErrorModel, UserModel>.right(user);
        } else {
          return Either<ErrorModel, UserModel>.left(
            ErrorModel(body: "User not found"),
          );
        }
      }).handleError((error) {
        if (error is FirebaseException) {
          return Either<ErrorModel, UserModel>.left(
            ErrorModel(body: handleFirebaseFirestoreErrors(error.code)),
          );
        }
        return Either<ErrorModel, UserModel>.left(
          ErrorModel(body: error.toString()),
        );
      });
    } catch (e) {
      return Stream.value(
        Either<ErrorModel, UserModel>.left(
          ErrorModel(body: e.toString()),
        ),
      );
    }
  }

  Future<Either<ErrorModel, SuccessModel>> updateOne({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await db.collection("users").doc(userId).update(userData);
      return right(SuccessModel(body: "Profile updated successfully"));
    } on FirebaseException catch (e) {
      return left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }
}
