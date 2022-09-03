import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/data/user.dart';
import 'package:educate_me/locator.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/app_controller.dart';

class NavigationViewModel extends IndexTrackingViewModel {
  final _service = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();


  Future initAppUsers() async {
    setBusy(true);
    final child =
        await _service.getChildUsers(controller.appUser?.userId ?? '');
    controller.appChild = child;
    if (child.isNotEmpty) {
      controller.currentChild = child[0];
    }
    setBusy(false);
  }
  void onSwitchProfile(UserModel child){
    controller.currentChild = child;
    notifyListeners();
  }
}
