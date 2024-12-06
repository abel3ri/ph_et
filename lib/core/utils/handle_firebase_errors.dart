String handleFirebaseFirestoreErrors(String code) {
  String errorMessage;

  switch (code) {
    case 'not-found':
      errorMessage = "The requested collection or document does not exist.";
      break;
    case 'permission-denied':
      errorMessage = "You do not have permission to access this resource.";
      break;
    case 'resource-exhausted':
      errorMessage = "Firestore has exceeded its quota for the project.";
      break;
    case 'unavailable':
      errorMessage =
          "The Firestore service is currently unavailable. Try again later.";
      break;
    case 'cancelled':
      errorMessage = "The operation was cancelled.";
      break;
    case 'deadline-exceeded':
      errorMessage =
          "The operation took too long to complete. Try again later.";
      break;
    case 'already-exists':
      errorMessage = "The document you are trying to create already exists.";
      break;
    case 'internal':
      errorMessage = "An internal server error occurred. Please try again.";
      break;
    default:
      errorMessage = "An unknown error occurred";
      break;
  }

  return errorMessage;
}

String handleFirebaseAuthErrors(String code) {
  String errorMessage;

  switch (code) {
    case 'auth/invalid-email':
      errorMessage =
          "The email address is not valid. Please check and try again.";
      break;
    case 'auth/missing-android-pkg-name':
      errorMessage =
          "An Android package name is required. Please contact support.";
      break;
    case 'auth/missing-continue-uri':
      errorMessage = "A continue URL must be provided. Please contact support.";
      break;
    case 'auth/missing-ios-bundle-id':
      errorMessage =
          "An iOS bundle ID must be provided. Please contact support.";
      break;
    case 'auth/invalid-continue-uri':
      errorMessage =
          "The continue URL provided is invalid. Please contact support.";
      break;
    case 'auth/unauthorized-continue-uri':
      errorMessage =
          "The domain of the continue URL is not whitelisted. Please contact support.";
      break;
    case 'auth/user-not-found':
      errorMessage = "No account found with this email address.";
      break;
    case 'auth/wrong-password':
      errorMessage = "The password entered is incorrect. Please try again.";
      break;
    case 'auth/user-disabled':
      errorMessage =
          "This user account has been disabled. Please contact support.";
      break;
    case 'auth/email-already-in-use':
      errorMessage = "This email address is already in use by another account.";
      break;
    case 'auth/weak-password':
      errorMessage =
          "The password is too weak. Please choose a stronger password.";
      break;
    case 'auth/network-request-failed':
      errorMessage =
          "A network error occurred. Please check your connection and try again.";
      break;
    case 'auth/too-many-requests':
      errorMessage = "Too many attempts. Please wait and try again later.";
      break;
    case 'auth/operation-not-allowed':
      errorMessage = "This operation is not allowed. Please contact support.";
      break;
    case 'auth/requires-recent-login':
      errorMessage =
          "This operation requires recent authentication. Please log in again.";
      break;
    case 'auth/account-exists-with-different-credential':
      errorMessage =
          "An account already exists with a different credential for this email.";
      break;
    case 'auth/credential-already-in-use':
      errorMessage = "This credential is already associated with another user.";
      break;
    case 'auth/invalid-credential':
      errorMessage = "The provided credential is invalid. Please try again.";
      break;
    case 'auth/invalid-verification-code':
      errorMessage =
          "The verification code entered is invalid. Please try again.";
      break;
    case 'auth/invalid-verification-id':
      errorMessage = "The verification ID is invalid. Please try again.";
      break;
    default:
      errorMessage = "An unknown error occurred. Please try again later.";
      break;
  }

  return errorMessage;
}
