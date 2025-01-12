import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/review_model.dart';
import 'package:pharma_et/app/data/services/base_service.dart';
import 'package:pharma_et/core/utils/handle_firebase_errors.dart';

class ReviewService extends BaseService<ReviewModel> {
  ReviewService() : super();

  @override
  ReviewModel fromJson(Map<String, dynamic> json) {
    return ReviewModel.fromJson(json);
  }

  Future<Either<ErrorModel, void>> addReviewTransaction({
    required ReviewModel review,
  }) async {
    final productRef = db.collection('products').doc(review.productId);
    final reviewRef = db.collection('reviews').doc();

    try {
      await db.runTransaction((transaction) async {
        final productSnapshot = await transaction.get(productRef);
        if (!productSnapshot.exists) {
          throw Exception("Product not found");
        }

        final productData = productSnapshot.data()!;
        final currentAverage = productData['averageRating'] ?? 0.0;
        final currentTotal = productData['totalRatings'] ?? 0;

        final newTotal = currentTotal + 1;
        final double newAverage =
            ((currentAverage * currentTotal) + review.rating!) / newTotal;

        transaction.update(productRef, {
          'averageRating': double.parse(newAverage.toStringAsFixed(2)),
          'totalRatings': newTotal,
        });
        review.reviewId = reviewRef.id;
        transaction.set(reviewRef, review.toJson());
      });

      return right(null);
    } on FirebaseException catch (e) {
      return left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Future<Either<ErrorModel, List<ReviewModel>>> findPaginatedReviewsByProduct({
    required String productId,
    required int limit,
    required int startAfter,
  }) async {
    try {
      Query query = db
          .collection("reviews")
          .where("productId", isEqualTo: productId)
          .orderBy("createdAt", descending: true)
          .limit(limit);

      if (startAfter != 0) {
        final lastVisibleDoc = await db
            .collection("reviews")
            .where("productId", isEqualTo: productId)
            .orderBy("createdAt", descending: true)
            .limit(startAfter)
            .get()
            .then((snapshot) => snapshot.docs.last);

        query = query.startAfterDocument(lastVisibleDoc);
      }

      final snapshot = await query.get();

      final reviews = snapshot.docs.map((doc) {
        return ReviewModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return right(reviews);
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Future<Either<ErrorModel, List<ReviewModel>>> findAllReviewsByProduct(
    String productId,
  ) {
    return findAll(
      collectionPath: "reviews",
      queryBuilder:
          db.collection("reviews").where("productId", isEqualTo: productId),
    );
  }

  Stream<Either<ErrorModel, List<ReviewModel>>> watchAllReviewsByProduct(
    String productId,
  ) {
    return watchAll(
      collectionPath: "reviews",
      queryBuilder: db
          .collection("reviews")
          .where("productId", isEqualTo: productId)
          .orderBy(
            "createdAt",
            descending: true,
          ),
    );
  }

  Future<Either<ErrorModel, void>> updateReviewTransaction({
    required String reviewId,
    required ReviewModel updatedReview,
  }) async {
    final productRef = db.collection('products').doc(updatedReview.productId);
    final reviewRef = db.collection('reviews').doc(reviewId);

    try {
      await db.runTransaction((transaction) async {
        final reviewSnapshot = await transaction.get(reviewRef);
        if (!reviewSnapshot.exists) {
          throw Exception("Review not found");
        }

        final productSnapshot = await transaction.get(productRef);
        if (!productSnapshot.exists) {
          throw Exception("Product not found");
        }

        final reviewData = reviewSnapshot.data()!;
        final oldRating = reviewData['rating'] as num;
        final productData = productSnapshot.data()!;
        final currentAverage = productData['averageRating'] ?? 0.0;
        final currentTotal = productData['totalRatings'] ?? 0;

        final double newAverage = ((currentAverage * currentTotal) -
                oldRating +
                updatedReview.rating!) /
            currentTotal;

        transaction.update(productRef, {
          'averageRating': double.parse(newAverage.toStringAsFixed(2)),
        });

        transaction.update(reviewRef, updatedReview.toJson());
      });

      return right(null);
    } on FirebaseException catch (e) {
      return left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> deleteReviewTransaction({
    required String reviewId,
    required String productId,
  }) async {
    final productRef = db.collection('products').doc(productId);
    final reviewRef = db.collection('reviews').doc(reviewId);

    try {
      await db.runTransaction((transaction) async {
        final reviewSnapshot = await transaction.get(reviewRef);
        if (!reviewSnapshot.exists) {
          throw Exception("Review not found");
        }

        final productSnapshot = await transaction.get(productRef);
        if (!productSnapshot.exists) {
          throw Exception("Product not found");
        }

        final reviewData = reviewSnapshot.data()!;
        final ratingToRemove = reviewData['rating'] as num;
        final productData = productSnapshot.data()!;
        final currentAverage = productData['averageRating'] ?? 0.0;
        final currentTotal = productData['totalRatings'] ?? 0;

        if (currentTotal <= 1) {
          transaction.update(productRef, {
            'averageRating': 0.0,
            'totalRatings': 0,
          });
        } else {
          final newTotal = currentTotal - 1;
          final double newAverage =
              ((currentAverage * currentTotal) - ratingToRemove) / newTotal;

          transaction.update(productRef, {
            'averageRating': double.parse(newAverage.toStringAsFixed(2)),
            'totalRatings': newTotal,
          });
        }

        transaction.delete(reviewRef);
      });

      return right(null);
    } on FirebaseException catch (e) {
      return left(ErrorModel(body: handleFirebaseFirestoreErrors(e.code)));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }
}
