import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/core/widgets/app_dialog.dart';
import 'package:educate_me/data/completed_lesson_model.dart';
import 'package:educate_me/data/controllers/quiz_controller.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/data/option.dart';
import 'package:educate_me/data/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/app_controller.dart';
import '../../../core/utils/constants/app_assets.dart';
import '../../../data/question.dart';
import '../../../data/services/firestore_service.dart';
import '../../../locator.dart';

class QuizViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();
  final QuizController quizController = Get.find<QuizController>();
  final PageController pageController = PageController(initialPage: 0);

  bool _isFirstAttempt = false;

  bool get isFirstAttempt => _isFirstAttempt;

  set isFirstAttempt(value) {
    _isFirstAttempt = value;
    notifyListeners();
  }

  bool _isSecondAttempt = false;

  bool get isSecondAttempt => _isSecondAttempt;

  set isSecondAttempt(value) {
    _isSecondAttempt = value;
    notifyListeners();
  }

  List<UserAnsModel> _ans = [];

  List<UserAnsModel> get ans => _ans;
  List<QuestionModel> _questions = [];

  List<QuestionModel> get questions => _questions;

  set questions(value) {
    _questions = value;
    notifyListeners();
  }

  QuestionModel? _selectedQn;

  QuestionModel? get selectedQn => _selectedQn;

  set selectedQn(value) {
    _selectedQn = value;
    notifyListeners();
  }

  int _qnNo = 1;

  int get qnNo => _qnNo;

  _incrementQno() {
    if (qnNo < questions.length + 1) {
      _qnNo++;
      notifyListeners();
    }
  }

  _decrementQno() {
    if (qnNo > 1) {
      _qnNo--;
      notifyListeners();
    }
  }

  goToNextQn() {
    _resetAttempts();
    pageController.animateToPage((pageController.page! + 1).toInt(),
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    _incrementQno();
  }

  goToPrvQn() {
    _resetAttempts();
    pageController.animateToPage((pageController.page! - 1).toInt(),
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    _decrementQno();
  }

  void onOptionSelected(OptionModel option) {
    //disable selection on answered question
    if (!isAnswered()) {
      isFirstAttempt = true; //user tap once on option

      if (option.isCorrect ?? false) {
        _addQuestionAsAnswered(option);
      } else {
        isSecondAttempt
            ? showSecondAttemptWrongDialog(option)
            : showFirstAttemptWrongPrompt();
      }
    }
  }

  void _addQuestionAsAnswered(OptionModel option) {
    final userAnswer = UserAnsModel(
      optionIndex: option.index ?? -1,
      id: selectedQn?.id ?? '',
      isCorrect: option.isCorrect ?? false,
      qIndex: qnNo,
    );
    _ans.removeWhere((e) => e.id == selectedQn?.id);
    _ans.add(userAnswer);
    notifyListeners();
  }

  bool isAnswered() => _ans.any((e) => selectedQn?.id == e.id);

  bool isUserCorrect() {
    if (isAnswered()) {
      return _ans.firstWhere((e) => e.id == selectedQn?.id).isCorrect;
    }
    return false;
  }

  int userAnsIndex() {
    if (isAnswered()) {
      return _ans.firstWhere((e) => e.id == selectedQn?.id).optionIndex;
    }
    return -1;
  }

  bool isLastPage() => qnNo > questions.length;

  int noCorrectAns() => ans.where((e) => e.isCorrect).length;

  Future getQuestions(
      {required levelId,
      required topicId,
      required subTopicId,
      required lessonId}) async {
    setBusy(true);
    var result = await _service.getQuestions(
        levelId: levelId,
        topicId: topicId,
        subTopicId: subTopicId,
        lessonId: lessonId);
    if (!result.hasError) {
      _questions = result.data as List<QuestionModel>;
      if (_questions.isNotEmpty) {
        selectedQn = questions[0];
      }
    } else {
      showErrorMessage(message: result.errorMessage ?? '');
    }
    setBusy(false);
  }

  retryQns() {
    _resetAttempts();
    _qnNo = 1;
    _selectedQn = questions[0];
    _ans.clear();
    pageController.animateToPage(0,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    notifyListeners();
  }

  Future<bool> updateChildStats() async {
    setBusy(true);
    var result = await _service.updateChildStat(
        totalAnswers: questions.length,
        correct: noCorrectAns(),
        incorrect: (questions.length - noCorrectAns()));
    setBusy(false);
    return !result.hasError;
  }

  Future<bool> updateCompletedLesson(
      {required lesson,
      required levelId,
      required topicId,
      required subTopicId}) async {
    setBusy(true);
    final completed = CompletedLessonModel(
        createdAt: Timestamp.now(),
        levelId: levelId,
        topicId: topicId,
        subtopicId: subTopicId,
        lessonId: lesson);
    var result =
        await _service.updateChildCompletedLesson(completed: completed);
    setBusy(false);
    return !result.hasError;
  }

  Future finishExam(
      {required LessonModel lesson,
      required levelId,
      required topicId,
      required subTopicId}) async {
    //update children statitics
    var result = await updateChildStats();
    if (result) {
      if (lesson.noCorrectToPass != 0 &&
          noCorrectAns() >= lesson.noCorrectToPass!) {
        //update the quiz as completed
        await updateCompletedLesson(
            lesson: lesson.id,
            levelId: levelId,
            topicId: topicId,
            subTopicId: subTopicId);
        Get.dialog(AppDialog(
          title: 'text056'.tr,
          image: kImgSuccess,
          subtitle: 'text057'.tr,
          onNegativeTap: () {
            Get.back();
            Get.back();
          },
          onPositiveTap: () async {
            Get.back();
            Get.back();
          },
        ));
      } else {
        //on question fail
        Get.dialog(AppDialog(
          title: 'text058'.tr,
          image: kImgFail,
          subtitle: 'text059'.tr,
          positiveText: 'text074'.tr,
          onNegativeTap: () {
            Get.back();
            Get.back();
          },
          onPositiveTap: () {
            Get.back();
            retryQns();
          },
        ));
      }
    }
  }

  void showFirstAttemptWrongPrompt() {
    Get.dialog(AppDialogSingle(
      title: 'text088'.tr,
      content: selectedQn?.promptOne ?? '',
      subtitle: selectedQn?.question ?? '',
      positiveText: 'text090'.tr,
      onPositiveTap: () {
        isSecondAttempt = true;
        _ans.removeWhere((e) => e.id == selectedQn?.id);
        notifyListeners();
        Get.back();
      },
    ));
  }

  void showSecondAttemptWrongDialog(OptionModel option) {
    Get.dialog(AppDialogSingle(
      title: 'text089'.tr,
      content: selectedQn?.promptTwo ?? '',
      subtitle: selectedQn?.question ?? '',
      positiveText: 'text091'.tr,
      onPositiveTap: () {
        _resetAttempts();
        Get.back();
        _addQuestionAsAnswered(option);
        goToNextQn();
      },
    ));
  }

  _resetAttempts() {
    isFirstAttempt = false;
    isSecondAttempt = false;
  }
}
