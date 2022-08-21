import 'package:get/get.dart';
import 'package:intl/intl.dart';

abstract class Validator {
  static final currFormatter = NumberFormat("#,##0.00", "en_US");

  static bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool isPassword(String em) {
    return em.length > 6 ? true : false;
  }

  static Function(String) validateEmail(v) => (value) {
    if (value.isNotEmpty && isEmail(value)) {
      v = value;
    } else if (value.isEmpty) {
      return "This field can't be left empty";
    } else {
      return "Email is Invalid";
    }
    return null;
  };

  static String? validateName(String? value)  {
    var pattern = RegExp(r"^[a-zA-Z0-9]+$");
    if (value?.isEmpty??true) {
      return 'text022.empty'.tr;
    }
    else if (!pattern.hasMatch(value??'')) {
      return 'text024'.tr;
    }
    return null;
  }

  static String? validatePhone(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value?.isEmpty??true) {
      return 'text009'.tr;
    }
    else if (!regExp.hasMatch(value??'')) {
      return 'text008'.tr;
    }
    return null;
  }

  static Function(String) validatePassword(v) => (value) {
    if (value.isNotEmpty && isPassword(value)) {
      v = value;
    } else if (value.isEmpty) {
      return "This field can't be left empty";
    } else {
      return "Pasword is Invalid";
    }
    return null;
  };
}