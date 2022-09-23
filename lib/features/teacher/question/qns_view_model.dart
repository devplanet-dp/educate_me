import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/data/question.dart';
import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../data/option.dart';

class QnsViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();
  final formKey = GlobalKey<FormState>();
  final qnsTEC = TextEditingController();
  final importTEC = TextEditingController();

  setQuestionData(QuestionModel? question) {
    if (question != null) {
      qnsTEC.text = question.question ?? '';
      addedQns = question.options ?? [];
    } else {
      addedQns = emptyQns;
    }
  }

  bool _isMultiple = true;

  bool get isMultipleChoice => _isMultiple;

  set isMultipleChoice(value) {
    _isMultiple = value;
    notifyListeners();
  }

  List<OptionModel> addedQns = [];
  List<OptionModel> emptyQns = [
    OptionModel(index: 0, option: '', isCorrect: false),
    OptionModel(index: 1, option: '', isCorrect: false),
    OptionModel(index: 2, option: '', isCorrect: false),
    OptionModel(index: 3, option: '', isCorrect: false),
  ];

  void updateQn(OptionModel qns) {
    addedQns.removeAt(qns.index ?? 0);
    addedQns.add(OptionModel(
        index: qns.index, option: qns.option, isCorrect: qns.isCorrect));
    addedQns.sort((a, b) => a.index!.compareTo(b.index!));
    notifyListeners();
  }

  Future<void> addQuestion(
      {required levelId,
      required topicId,
      required subtopicId,
      required lessonId,
      required bool isStartup,
      QuestionModel? question}) async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      QuestionModel qn = QuestionModel(
          id: question == null ? const Uuid().v4() : question.id,
          options: addedQns,
          question: qnsTEC.text);

      var data = isStartup
          ? await _service.addStartUpQuestion(qn, levelId)
          : await _service.addQuestions(
              question: qn,
              levelId: levelId,
              topicId: topicId,
              subTopicId: subtopicId,
              lessonId: lessonId);
      if (!data.hasError) {
        Get.back();
        showInfoMessage(message: 'Question added successfully.');
      }
      setBusy(false);
    }
  }

  Future removeQuestion(
      {required levelId,
      required topicId,
      required subTopicId,
      required lessonId,
      required bool isStartUp,
      required qId}) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?', description: 'Delete this question?');
    if (response?.confirmed ?? false) {
      setBusy(true);
      isStartUp
          ? await _service.removeStartUpQuestion(qId: qId, levelId: levelId)
          : await _service.removeQuestion(
              levelId: levelId,
              topicId: topicId,
              subTopic: subTopicId,
              lessonId: lessonId,
              questionId: qId);
      setBusy(false);
      Get.back();
    }
  }

  Future importQnsFromText(
      {required levelId,
      required topicId,
      required subtopicId,
      required lessonId,
      required isPractice}) async {
    if (formKey.currentState!.validate()) {
      try {
        var import = importTEC.text.trim();

        List<String> qns = import.split('|');
        List<QuestionModel> q = [];

        for (var i = 0; i < qns.length; i++) {
          List<String> a = qns[i].split(',,,');
          if (a[0].isNotEmpty) {
            q.add(QuestionModel(
                index: i,
                id: const Uuid().v4(),
                question: a[0],
                promptOne: a[5],
                promptTwo: a[6],
                enableDraw: a[7].toLowerCase().trim() == 'enabledraw',
                photoUrl: a.length == 9 ? a[8] : null,
                options: [
                  OptionModel(
                      index: 0,
                      option: a[1].replaceAll('*', ''),
                      isCorrect: a[1].contains('*')),
                  OptionModel(
                      index: 1,
                      option: a[2].replaceAll('*', ''),
                      isCorrect: a[2].contains('*')),
                  OptionModel(
                      index: 2,
                      option: a[3].replaceAll('*', ''),
                      isCorrect: a[3].contains('*')),
                  OptionModel(
                      index: 3,
                      option: a[4].replaceAll('*', ''),
                      isCorrect: a[4].contains('*'))
                ]));
          }
        }
        if (!isPractice) {
          await addImportedQuestions(
              questions: q,
              levelId: levelId,
              topicId: topicId,
              subtopicId: subtopicId,
              lessonId: lessonId);
        } else {
          //add practice questions to lesson
          await addImportedPracticeQuestions(
              questions: q,
              levelId: levelId,
              topicId: topicId,
              subtopicId: subtopicId,
              lessonId: lessonId);
        }
      } catch (e) {
        lg(e);
        showErrorMessage(
            message:
                'Error in format, Please check for the format again please');
      }
    }
  }

  Future addImportedQuestions({
    required List<QuestionModel> questions,
    required levelId,
    required topicId,
    required subtopicId,
    required lessonId,
  }) async {
    setBusy(true);
    for (var q in questions) {
      final data = await _service.addQuestions(
          question: q,
          levelId: levelId,
          topicId: topicId,
          subTopicId: subtopicId,
          lessonId: lessonId);
    }
    Get.back();
    showInfoMessage(message: 'Questions imported successfully.');

    setBusy(false);
  }

  Future addImportedPracticeQuestions({
    required List<QuestionModel> questions,
    required levelId,
    required topicId,
    required subtopicId,
    required lessonId,
  }) async {
    setBusy(true);
    final data = await _service.addPracticeQuestion(
        question: questions,
        levelId: levelId,
        topicId: topicId,
        subTopicId: subtopicId,
        lessonId: lessonId);
    Get.back();
    showInfoMessage(message: 'Practice question imported successfully.');

    setBusy(false);
  }

  @override
  void dispose() {
    qnsTEC.dispose();
    importTEC.dispose();
    importTEC.removeListener(() {});
    super.dispose();
  }
}
