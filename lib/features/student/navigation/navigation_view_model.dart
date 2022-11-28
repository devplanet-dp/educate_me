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
import 'navigation_view.dart';

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

  final List<ProfileController> _childCount = [];

  List<ProfileController> get childCount => _childCount;

  void setProfiles() {
    for (var child in controller.appChild) {
      _childCount.add(ProfileController(
          childId: child.userId ?? '',
          nameTEC: TextEditingController(text: child.name),
          ageTEC: TextEditingController(text: child.age)));
    }
    notifyListeners();
  }

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
    ownerTECT.text = controller.appUser?.fName ?? '';
    notifyListeners();
  }

  void onSwitchProfile(UserModel child) async {
    controller.popupMenuEnabled.value = false;
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
  Future<void> updateMyProfiles() async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      for (var child in childCount) {
        var user = UserModel(
            name: child.nameTEC.text,
            email: '',
            role: UserRole.student,
            userId: child.childId,
            createdDate: Timestamp.now(),
            age: child.ageTEC.text);
        var result = await _service.createChild(
            parentId: controller.appUser?.userId ?? '', child: user);

      }
      await initAppUsers(selectedChildId: controller.currentChild?.userId);
      setBusy(false);
      showInfoMessage(message: 'Your profile details updated');
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

class ProfileController {
  final String childId;
  final TextEditingController nameTEC;
  final TextEditingController ageTEC;

  ProfileController(
      {required this.childId, required this.nameTEC, required this.ageTEC});
}
