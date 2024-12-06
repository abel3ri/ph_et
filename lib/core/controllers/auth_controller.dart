import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/app/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  late FirebaseAuth auth;
  late FirebaseFirestore db;

  SharedPreferences? prefs;
  RxString verificationId = "".obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  int? resendToken;

  @override
  void onInit() {
    super.onInit();
    auth = FirebaseAuth.instance;
    db = FirebaseFirestore.instance;
    SharedPreferences.getInstance().then((instance) {
      prefs = instance;
    });
    getUserData();
  }

  Future<Either<ErrorModel, SuccessModel>> verifyPhoneNumber({
    required Map<String, dynamic>? userData,
    bool isSignUp = false,
  }) async {
    final Completer<bool> completer = Completer<bool>();
    String? errorMessage;

    try {
      final phoneQuerySnapShot = await db
          .collection("users")
          .where("phoneNumber", isEqualTo: userData?['phoneNumber'])
          .get();

      if (isSignUp) {
        if (phoneQuerySnapShot.docs.isNotEmpty) {
          return left(ErrorModel(body: "Phone number is already registered."));
        }
        final emailQuerySnapshot = await db
            .collection("users")
            .where("email", isEqualTo: userData?['email'])
            .get();
        if (emailQuerySnapshot.docs.isNotEmpty) {
          return left(ErrorModel(body: "Email is already registered."));
        }
      } else {
        if (phoneQuerySnapShot.docs.isEmpty) {
          return left(ErrorModel(body: "Phone number is not registered."));
        }
      }

      await auth.verifyPhoneNumber(
        phoneNumber: userData?['phoneNumber'],
        verificationCompleted: (PhoneAuthCredential credential) async {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);
          final userId = userCredential.user?.uid;

          if (userId != null) {
            if (isSignUp) {
              final userModel = UserModel.fromJson(userData!);
              userModel.userId = userId;
              await db.collection("users").doc(userId).set(userModel.toJson());
              currentUser.value = userModel;

              if (userData['email'] != null && userData['email'].isNotEmpty) {
                await linkEmailProvider(
                    userData['email'], userData['password']);
              }
              await saveUserData(userData);
            } else {
              final DocumentSnapshot<Map<String, dynamic>> res =
                  await db.collection("users").doc(userId).get();

              currentUser.value = UserModel.fromJson(res.data()!);
              await saveUserData(currentUser.value!.toJson());
            }
          }
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          this.resendToken = resendToken;
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == "invalid-phone-number") {
            errorMessage = "Invalid phone number entered";
          } else if (e.code == "too-many-requests") {
            errorMessage = "Too many requests. Please try again later!";
          } else if (e.code == "quota-exceeded") {
            errorMessage == "Quota exceeded. Please try again in 24 hrs";
          } else if (e.code == "network-request-failed") {
            errorMessage = "Network failure";
          } else {
            errorMessage = e.toString();
          }
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
      );

      final bool verificationErrorOccurred = await completer.future;
      if (verificationErrorOccurred) {
        return left(ErrorModel(body: errorMessage ?? "Verification failed"));
      }

      return right(
          SuccessModel(body: "OTP sent to ${userData!['phoneNumber']}"));
    } catch (e, stackTrace) {
      return left(ErrorModel(body: e.toString(), stackTrace: stackTrace));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> verifyOTP({
    required String otp,
    required Map<String, dynamic>? userData,
  }) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return left(ErrorModel(body: "User could not be authenticated."));
      }
      final userId = userCredential.user?.uid;

      if (userId != null) {
        if (userData?['email'] != null) {
          final userModel = UserModel.fromJson(userData!);
          userModel.userId = userId;

          await db.collection("users").doc(userId).set(userModel.toJson());

          currentUser.value = userModel;

          if (userData['email'] != null && userData['email'].isNotEmpty) {
            await linkEmailProvider(userData['email'], userData['password']);
          }
          await saveUserData(userData);
          return right(SuccessModel(body: "Account created successfully!"));
        } else {
          final DocumentSnapshot<Map<String, dynamic>> res =
              await db.collection("users").doc(userId).get();

          currentUser.value = UserModel.fromJson(res.data()!);
          await saveUserData(currentUser.value!.toJson());
        }
      }

      return right(SuccessModel(body: "Log in successful!"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        return left(ErrorModel(body: "Invalid verification code!"));
      }
      return left(ErrorModel(body: e.message!));
    } catch (e, stackTrace) {
      return left(ErrorModel(body: e.toString(), stackTrace: stackTrace));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> resendCode(
    Map<String, dynamic> userData,
  ) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: userData['phoneNumber'],
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);
          final userId = userCredential.user?.uid;

          if (userId != null) {
            if (userData['email'] != null) {
              final userModel = UserModel.fromJson(userData);
              userModel.userId = userId;
              await db.collection("users").doc(userId).set(userModel.toJson());
              currentUser.value = userModel;

              if (userData['email'] != null && userData['email'].isNotEmpty) {
                await linkEmailProvider(
                    userData['email'], userData['password']);
              }
              await saveUserData(userData);
            } else {
              final DocumentSnapshot<Map<String, dynamic>> res =
                  await db.collection("users").doc(userId).get();

              currentUser.value = UserModel.fromJson(res.data()!);
              await saveUserData(currentUser.value!.toJson());
            }
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          this.resendToken = resendToken;
        },
        verificationFailed: (FirebaseAuthException e) {
          throw FirebaseAuthException(
              code: e.code, message: e.message ?? "Verification failed");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
      );
      return right(SuccessModel(body: "OTP has been resent successfully."));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Future<void> linkEmailProvider(String email, String password) async {
    try {
      final AuthCredential emailCredential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      final User? user = auth.currentUser;
      if (user == null) {
        throw Exception("No authenticated user found to link email.");
      }
      await user.linkWithCredential(emailCredential);
      log("Email provider linked successfully.");
    } catch (e) {
      log("Failed to link email log: $e");
    }
  }

  Future<Either<ErrorModel, SuccessModel>> loginWithEmailAndPass({
    required Map<String, dynamic> userData,
  }) async {
    try {
      final UserCredential credential = await auth.signInWithEmailAndPassword(
        email: userData['email'],
        password: userData['password'],
      );
      final res = await db.collection("users").doc(credential.user!.uid).get();
      currentUser.value = UserModel.fromJson(res.data()!);
      await saveUserData(currentUser.value!.toJson());

      return right(SuccessModel(body: "Log in successful!"));
    } on FirebaseAuthException catch (e, stackTrace) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        return left(ErrorModel(body: "Invalid email or password"));
      } else if (e.code == 'user-disabled') {
        return left(ErrorModel(body: "User account disabled"));
      }
      return left(ErrorModel(body: e.message!, stackTrace: stackTrace));
    } catch (e, stackTrace) {
      return left(ErrorModel(body: e.toString(), stackTrace: stackTrace));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> resetPassword({
    required String email,
  }) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return right(SuccessModel(body: "Password reset email sent to $email"));
    } on FirebaseAuthException catch (e) {
      return left(ErrorModel(body: e.code));
    } catch (e) {
      return left(ErrorModel(body: e.toString()));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> logout() async {
    try {
      await auth.signOut();
      await removeUserData();
      currentUser.value = null;
      return right(SuccessModel(body: "Successfully logged out!"));
    } catch (e, stackTrace) {
      return left(ErrorModel(body: e.toString(), stackTrace: stackTrace));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> deleteAccount() async {
    try {
      await auth.currentUser?.delete();
      await db.collection("users").doc(currentUser.value?.userId).delete();
      await removeUserData();
      currentUser.value = null;

      return right(SuccessModel(body: "Account deleted successfully!"));
    } catch (e) {
      return left(
        ErrorModel(
          body: "Account could not be deleted!. Please try again later.",
        ),
      );
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      prefs ??= await SharedPreferences.getInstance();
      for (var entry in userData.entries) {
        if (entry.value != null) {
          if (entry.key == "profileImage") {
            prefs!.setString(entry.key, jsonEncode(entry.value));
          } else {
            prefs!.setString(entry.key, entry.value);
          }
        }
      }
    } catch (e) {
      ErrorModel(body: e.toString()).showError();
    }
  }

  Future<void> getUserData() async {
    try {
      prefs ??= await SharedPreferences.getInstance();
      final Map<String, dynamic> userData = {
        "userId": prefs?.getString("userId") ?? '',
        'firstName': prefs?.getString('firstName') ?? '',
        'lastName': prefs?.getString('lastName') ?? '',
        'email': prefs?.getString('email') ?? '',
        'role': prefs?.getString('role') ?? 'user',
        'createdAt': prefs?.getString('createdAt') ?? '',
        "profileImage": jsonDecode(prefs?.getString("profileImage") ?? ""),
        'phoneNumber': prefs?.getString('phoneNumber') ?? '',
      };
      currentUser.value = UserModel.fromJson(userData);
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      currentUser.value = null;
    }
  }

  Future<void> removeUserData() async {
    try {
      prefs ??= await SharedPreferences.getInstance();
      Future.wait([
        prefs!.remove("firstName"),
        prefs!.remove("lastName"),
        prefs!.remove("email"),
        prefs!.remove("userId"),
        prefs!.remove("phoneNumber"),
        prefs!.remove("createdAt"),
        prefs!.remove("profileImage"),
        prefs!.remove("role"),
      ]);
    } catch (e, stackTrace) {
      ErrorModel(body: e.toString(), stackTrace: stackTrace).showError();
    }
  }
}
