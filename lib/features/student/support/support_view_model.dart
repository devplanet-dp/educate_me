import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/data/complain_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/app_controller.dart';
import '../../../data/services/firestore_service.dart';
import '../../../locator.dart';

class SupportViewModel extends BaseViewModel {
  final _fireService = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();
  final nameTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final messageTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> onSendPressed() async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      final c = ComplainModel(
          id: const Uuid().v4(),
          createdAt: Timestamp.now(),
          authorId: controller.appUser?.userId ?? '',
          name: nameTEC.text,
          email: emailTEC.text,
          message: messageTEC.text);
      final result = await _fireService.createAComplain(c);
      if (!result.hasError) {
        Get.back();
        showInfoMessage(message: 'text073'.tr);
      } else {
        showErrorMessage(message: result.errorMessage ?? '');
      }
      setBusy(false);
    }
  }
}
