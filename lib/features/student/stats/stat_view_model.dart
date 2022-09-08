import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/core/widgets/app_dialog.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/app_controller.dart';
import '../../../data/services/firestore_service.dart';
import '../../../locator.dart';

class StatViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();

  Future retest() async {
    Get.dialog(AppDialog(
      title: 'text075'.tr,
      image: kImgThink,
      onPositiveTap: () async {
        Get.back();
        setBusy(true);
        var result = await _service.resetChildStat();
        setBusy(false);
        if (result.hasError) {
          showErrorMessage(message: result.errorMessage);
        }
      },
    ));
  }
}
