import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/data/lesson.dart';
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

  bool _isMultiselect = false;

  bool get multiSelect => _isMultiselect;

  toggleMultiSelect() {
    _isMultiselect = !_isMultiselect;
    selectedQnsIds.clear();
    notifyListeners();
  }

  List<String> selectedQnsIds = [];

  void onQnsSelectedForDelete(String qns) {
    if (selectedQnsIds.contains(qns)) {
      selectedQnsIds.remove(qns);
    } else {
      selectedQnsIds.add(qns);
    }
    notifyListeners();
  }

  bool isQnSelected(String qns) => selectedQnsIds.contains(qns) && multiSelect;

  List<QuestionModel> _questions = [];
  List<QuestionModel> _practiceQns = [];

  List<QuestionModel> get questions => _questions;

  List<QuestionModel> get practiceQns => _practiceQns;

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
            Get.off(() => TeacherQnsView(levelId: level.id ?? ''));
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
      _questions.sort((a, b) => a.index ?? 0.compareTo(b.index ?? 0));
      notifyListeners();
    });
  }

  Future getPracticeQuestion(
      {required levelId,
      required topicId,
      required subTopicId,
      required lessonId}) async {
    setBusy(true);
    final result = await _service.getPracticeQuestions(
        levelId: levelId,
        topicId: topicId,
        subTopicId: subTopicId,
        lessonId: lessonId);
    if (!result.hasError) {
      var data = result.data as LessonModel;
      _practiceQns = data.questions ?? [];
    }
    setBusy(false);
  }

  Future removeQuestions(
      {required levelId,
      required topicId,
      required subTopicId,
      required lessonId}) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?', description: 'Delete this question?');
    if (response?.confirmed ?? false) {
      setBusy(true);
      for (var e in selectedQnsIds) {
        await _service.removeQuestion(
            levelId: levelId,
            topicId: topicId,
            subTopic: subTopicId,
            lessonId: lessonId.id,
            questionId: e);
      }
      selectedQnsIds.clear();
      setBusy(false);
    }
  }

  @override
  void dispose() {
    orderTEC.dispose();
    nameTEC.dispose();
    super.dispose();
  }
}
