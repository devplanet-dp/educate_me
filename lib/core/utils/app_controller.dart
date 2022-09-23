import 'package:get/get.dart';

import '../../data/user.dart';

class AppController extends GetxController {
  UserModel? appUser;

  List<UserModel> appChild = [];

  UserModel? currentChild;

  RxString htmlContent = ''.obs;
}
