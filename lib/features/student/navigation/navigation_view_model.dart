import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/data/user.dart';
import 'package:educate_me/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/app_controller.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/complain_model.dart';
import '../../../data/services/local_storage_service.dart';

class NavigationViewModel extends IndexTrackingViewModel {
  final _service = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();
  final nameTEC = TextEditingController();
  final ownerTECT = TextEditingController();
  final ageTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final messageTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final localStorage = locator<LocalStorageService>();

  final _list = [
    {'code': 'en', 'name': 'English'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'ga', 'name': 'Irish'},
  ];

  List<Map> get languages => _list;


  Future initAppUsers({String? selectedChildId}) async {
    setBusy(true);
    final child =
        await _service.getChildUsers(controller.appUser?.userId ?? '');
    controller.appChild = child;

    if (child.isNotEmpty) {
      controller.currentChild = selectedChildId == null
          ? child[0]
          : controller.appChild.firstWhere((e) => e.userId == selectedChildId);
    }
    setBusy(false);
  }

  void initChildAccountDetails() {
    nameTEC.text = controller.currentChild?.name ?? '';
    ageTEC.text = controller.currentChild?.age ?? '';
    ownerTECT.text = controller.appUser?.fName??'';
    notifyListeners();
  }

  void onSwitchProfile(UserModel child) async {
    controller.currentChild = child;
    setBusy(true);
    await _service.populateCurrentChild();
    setBusy(false);
  }

  Future<void> updateChildAccountDetails() async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      var result = await _service.updateChildAccount(name: nameTEC.text);
      if (!result.hasError) {
        ///init app child in switch account popup
        await initAppUsers(selectedChildId: controller.currentChild?.userId);
        showInfoMessage(message: 'text078'.tr);
      } else {
        showErrorMessage(message: result.errorMessage);
      }
      setBusy(false);
    }
  }


  void onLanguageSelected(String code) {
    localStorage.appLocale = code;
    notifyListeners();
  }

  String? get languageName =>
      _list.firstWhere((e) => e['code'] == localStorage.appLocale)['name'];

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
      final result = await _service.createAComplain(c);
      if (!result.hasError) {
        Get.back();
        showInfoMessage(message: 'text073'.tr);
      } else {
        showErrorMessage(message: result.errorMessage ?? '');
      }
      setBusy(false);
    }
  }

  @override
  void dispose() {
    nameTEC.dispose();
    ageTEC.dispose();
    ownerTECT.dispose();
    super.dispose();
  }
}
