import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/data/level.dart';
import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/features/teacher/level/add_level.dart';
import 'package:educate_me/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

class LevelViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();
  final formKey = GlobalKey<FormState>();
  final orderTEC = TextEditingController();
  final nameTEC = TextEditingController();

  Future addLevel() async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      var id = const Uuid().v4();
      var level = LevelModel(id: id, order: orderTEC.text, name: nameTEC.text);
      var result = await _service.createLevel(level);
      if (!result.hasError) {
        Get.off(() => AddLessonQns(level: level));
      } else {
        showErrorMessage(message: result.errorMessage);
      }
      setBusy(false);
    }
  }
  Future removeLevel(String id)async{
    var response = await _dialogService.showConfirmationDialog(title: 'Are you sure?',description: 'Delete this level');
    if(response?.confirmed??false){
      setBusy(true);
      await _service.removeLevel(id);
      setBusy(false);
      Get.back();
    }
  }

  @override
  void dispose() {
    orderTEC.dispose();
    nameTEC.dispose();
    super.dispose();
  }
}
