import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/data/level.dart';
import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/features/teacher/level/teacher_qns_view.dart';
import 'package:educate_me/features/teacher/topic/teacher_topic_view.dart';
import 'package:educate_me/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../data/question.dart';

class TeacherLevelViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();
  final formKey = GlobalKey<FormState>();
  final orderTEC = TextEditingController();
  final nameTEC = TextEditingController();

  List<QuestionModel> _questions = [];

  List<QuestionModel> get questions => _questions;

  void setInitData(LevelModel level) {
    orderTEC.text = '${level.order}';
    nameTEC.text = level.name ?? '';
    notifyListeners();
  }

  Future addLevel(LevelModel? l) async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      var id = l == null ? const Uuid().v4() : l.id;
      var level = LevelModel(
          id: id, order: int.parse(orderTEC.text), name: nameTEC.text);
      var result = await _service.createLevel(level);
      if (!result.hasError) {
        if (l == null) {
          if (level.order == 0) {
            Get.off(() => TeacherQnsView(levelId: level.id??''));
          } else {
            Get.off(() => TeacherTopicView(level: level));
          }
        } else {
          Get.back();
        }
      } else {
        showErrorMessage(message: result.errorMessage);
      }
      setBusy(false);
    }
  }

  Future removeLevel(String id) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?', description: 'Delete this level');
    if (response?.confirmed ?? false) {
      setBusy(true);
      await _service.removeLevel(id);
      setBusy(false);
      Get.back();
    }
  }

  Future removeLesson(
      {required levelId,
      required topic,
      required subTopic,
      required lessonId}) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?', description: 'Delete this lesson');
    if (response?.confirmed ?? false) {
      setBusy(true);
      await _service.removeLesson(
          levelId: levelId,
          topicId: topic,
          subTopic: subTopic,
          lessonId: lessonId);
      setBusy(false);
      Get.back();
    }
  }

  listenToStartUpQns(String id) {
    _service.streamStartUpQuestions(id).listen((d) {
      _questions = d;
      notifyListeners();
    });
  }

  listenToQns(
      {required levelId,
      required topiId,
      required subTopicId,
      required lessonId}) {
    _service
        .streamQuestions(
            subTopicId: subTopicId,
            levelId: levelId,
            lessonId: lessonId,
            topicId: topiId)
        .listen((d) {
      _questions = d;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    orderTEC.dispose();
    nameTEC.dispose();
    super.dispose();
  }
}
