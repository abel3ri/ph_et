import 'package:get/get_utils/get_utils.dart';

class FormValidator {
  static String? emailValidator(String? value) {
    if ((value == null || value.isEmpty)) {
      return "Please provide an email address";
    }
    if (!value.isEmail) {
      return "Please provide valid email";
    }
    return null;
  }

  static String? phoneNumberValidator(String? value) {
    final phoneExp = RegExp(r'^(^\+251|^251|^0)?(9|7)\d{8}$');
    if ((value == null || value.isEmpty)) {
      return "Please provide a phone number";
    }
    if (!phoneExp.hasMatch(value)) {
      return "Please provide a valid phone number";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if ((value == null || value.isEmpty)) {
      return "Please provide a password";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  static confirmPasswordValidator({String? password, String? rePassword}) {
    if (rePassword == null || rePassword.isEmpty) {
      return 'Please provide a password'.tr;
    }
    if (rePassword.length < 8) {
      return "Password must be at least 8 characters long".tr;
    }
    if (rePassword != password) {
      return "Passwords do not match".tr;
    }
    return null;
  }

  static String? emailOrPhoneValidator(String? value) {
    final phoneExp = RegExp(r'^(^\+251|^251|^0)?(9|7)\d{8}$');
    if ((value == null || value.isEmpty)) {
      return "Please provide an email address or phone number";
    }
    if (!value.isEmail && !phoneExp.hasMatch(value)) {
      return "Please provide a valid email or phone number";
    }
    return null;
  }

  static String? nameValidator(String? value) {
    if ((value == null || value.isEmpty)) {
      return "Please provide a name";
    }
    if (!value.isAlphabetOnly) {
      return "Please provide a valid name";
    }
    return null;
  }

  static String? fullNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please provide a full name";
    }

    final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');

    if (!nameRegExp.hasMatch(value)) {
      return "Please provide a valid name (alphabets and spaces only)";
    }

    return null;
  }
}
