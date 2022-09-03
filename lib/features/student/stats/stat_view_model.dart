import 'package:educate_me/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/app_controller.dart';
import '../../../data/services/firestore_service.dart';
import '../../../locator.dart';

class StatViewModel extends BaseViewModel{

  final _service = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();



}