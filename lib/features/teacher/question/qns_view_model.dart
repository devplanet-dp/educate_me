import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/data/lesson.dart';
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

  void setRawInput(
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
      var q = result.data as LessonModel;
      importTEC.text = q.raw??'';
    }
    setBusy(false);
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

  Future removePracticeQuestion(
      {required levelId,
      required topicId,
      required subTopicId,
      required lessonId}) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?', description: 'Delete this question?');
    if (response?.confirmed ?? false) {
      setBusy(true);
      await _service.removePracticeQuestion(
          levelId: levelId,
          topicId: topicId,
          subTopic: subTopicId,
          lessonId: lessonId);
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
            final importMap = a.asMap();
            final qType = _getQuestionTypeByLength(a.length, a[1].trim().replaceAll('*', ''));
            switch (qType) {
              case QuestionType.multipleChoice:
                final question = QuestionModel(
                    index: i,
                    type: QuestionType.multipleChoice,
                    id: const Uuid().v4(),
                    question: a[0].trim(),
                    promptOne: a[5].trim(),
                    promptTwo: a[6].trim(),
                    enableDraw: a[7].toLowerCase().trim() == 'enabledraw',
                    photoUrl: importMap.containsKey(8) ? a[8].trim() : null);

                final List<OptionModel> options = [];
                for (int i = 0; i < 4; i++) {
                  if (importMap.containsKey(i + 1)) {
                    options.add(OptionModel(
                        index: i,
                        option: a[i + 1].replaceAll('*', ''),
                        isCorrect: a[i + 1].contains('*')));
                  }
                }

                question.options = options;

                q.add(question);
                break;
              case QuestionType.inputSingle:
                final question = QuestionModel(
                    index: i,
                    type: QuestionType.inputSingle,
                    id: const Uuid().v4(),
                    question: a[0].trim(),
                    promptOne: a[2].trim(),
                    promptTwo: a[3].trim(),
                    enableDraw: a[4].toLowerCase().trim() == 'enabledraw',
                    photoUrl: importMap.containsKey(5) ? a[5].trim() : null);

                final List<OptionModel> options = [];
                if (importMap.containsKey(1)) {
                  options.add(OptionModel(
                      index: 0,
                      option: a[1].replaceAll('*', ''),
                      isCorrect: a[1].contains('*')));
                }
                question.options = options;

                q.add(question);
                break;
              case QuestionType.inputMultiple:
                final question = QuestionModel(
                    index: i,
                    type: QuestionType.inputMultiple,
                    id: const Uuid().v4(),
                    question: a[0].trim(),
                    promptOne: a[3].trim(),
                    promptTwo: a[4].trim(),
                    enableDraw: a[5].toLowerCase().trim() == 'enabledraw',
                    photoUrl: importMap.containsKey(6) ? a[6].trim() : null);

                final List<OptionModel> options = [];
                for (int i = 0; i < 2; i++) {
                  if (importMap.containsKey(i + 1)) {
                    options.add(OptionModel(
                        index: i,
                        option: a[i + 1].replaceAll('*', ''),
                        isCorrect: a[i + 1].contains('*')));
                  }
                }

                question.options = options;

                q.add(question);
                break;
              case QuestionType.singleChoice:
                final question = QuestionModel(
                    index: i,
                    type: QuestionType.singleChoice,
                    id: const Uuid().v4(),
                    question: a[0].trim(),
                    promptOne: a[2].trim(),
                    promptTwo: a[3].trim(),
                    enableDraw: a[4].toLowerCase().trim() == 'enabledraw',
                    photoUrl: importMap.containsKey(5) ? a[5].trim() : null);

                final List<OptionModel> options = [];
                if (importMap.containsKey(1)) {
                  options.add(OptionModel(
                      index: 0,
                      option: a[1].replaceAll('*', ''),
                      isCorrect: true));
                }

                ///add remaining option
                options.add(OptionModel(
                    index: 1,
                    isCorrect: false,
                    option: options[0].option!.trim().toLowerCase() == 'true'
                        ? 'false'
                        : 'true'));
                question.options = options;

                q.add(question);
                break;
            }
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
              raw: importTEC.text,
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
    required raw,
  }) async {
    setBusy(true);
    final data = await _service.addPracticeQuestion(
        question: questions,
        levelId: levelId,
        topicId: topicId,
        subTopicId: subtopicId,
        lessonId: lessonId,
        raw: raw);
    Get.back();
    showInfoMessage(message: 'Practice question imported successfully.');

    setBusy(false);
  }

  Future updatePracticeQuestions(
      {required levelId,
      required topicId,
      required subtopicId,
      required lessonId,
      required QuestionModel question}) async {
    setBusy(true);
    question.question = qnsTEC.text;
    question.options = addedQns;
    final data = await _service.addPracticeQuestion(
        question: [question],
        levelId: levelId,
        topicId: topicId,
        raw: '',
        subTopicId: subtopicId,
        lessonId: lessonId);
    Get.back();
    showInfoMessage(message: 'Practice question edited successfully.');

    setBusy(false);
  }

  QuestionType _getQuestionTypeByLength(int length, String firstAnswer) {
    if (length >= 9) {
      return QuestionType.multipleChoice;
    } else if (length == 6) {

      if (firstAnswer.toLowerCase() == 'true' ||
          firstAnswer.toLowerCase() == 'false') {
        return QuestionType.singleChoice;
      } else {
        return QuestionType.inputSingle;
      }
    } else {
      return QuestionType.inputMultiple;
    }
  }

  @override
  void dispose() {
    qnsTEC.dispose();
    importTEC.dispose();
    importTEC.removeListener(() {});
    super.dispose();
  }
}
