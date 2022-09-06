import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/app_controller.dart';
import '../../../data/services/firestore_service.dart';
import '../../../locator.dart';

class SupportViewModel extends BaseViewModel{
  final _fireService = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();
  final nameTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final messageTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> onSendPressed()async{
    if(formKey.currentState!.validate()){

    }
  }
}