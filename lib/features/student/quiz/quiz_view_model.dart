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

import '../../../core/shared/app_colors.dart';
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
  final TextEditingController inputController = TextEditingController();

  bool _allowNextPage = false;

  bool _isFirstAttempt = false;

  bool get isFirstAttempt => _isFirstAttempt;

  bool get allowNextPage => _allowNextPage;

  setAllowNextPage(value) {
    _allowNextPage = value;
    notifyListeners();
  }

  autoMoveToNextPage() async {
    await Future.delayed(const Duration(milliseconds: 1750));
    goToNextQn();
  }

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

  List<OptionModel> checkedMultipleOptions = [];

  onMultipleOptionChecked(OptionModel option) {
    var state = selectedQn?.state;
    if (state == AnswerState.tryAgain ||
        state == AnswerState.correct ||
        state == AnswerState.failed) {
      return;
    }

    var exist = checkedMultipleOptions.contains(option);
    if (exist) {
      checkedMultipleOptions.remove(option);
    } else {
      checkedMultipleOptions.add(option);
    }
    notifyListeners();
  }

  void setPreviousCheckedValues() {
    if (isAnswered()) {
      var answer = ans.firstWhere((e) => e.id == selectedQn?.id);
      checkedMultipleOptions = answer.multipleOptions ?? [];
      notifyListeners();
    }
  }

  bool isOptionChecked(OptionModel index) =>
      userCheckedAnswers().contains(index);

  onPageChanged(index) {
    _qnNo = index;
    notifyListeners();
  }

  goToNextQn() {
    _resetAttempts();
    pageController.animateToPage((pageController.page! + 1).toInt(),
        duration: const Duration(milliseconds: 10), curve: Curves.bounceIn);
  }

  goToPrvQn() {
    _resetAttempts();
    pageController.animateToPage((pageController.page! - 1).toInt(),
        duration: const Duration(milliseconds: 10), curve: Curves.bounceIn);
  }

  void onOptionSelected(OptionModel option) async {
    //disable selection on answered question
    if (!isAnswered()) {
      isFirstAttempt = true; //user tap once on option

      if (option.isCorrect ?? false) {
        selectedQn?.state = AnswerState.correct;
        _addQuestionAsAnswered(option);
        //play success sound
        quizController.playSuccessSound();
        await showSuccessDialog();
        //auto move to next question if answer is correct
        await autoMoveToNextPage();
      } else {
        ///show only one prompt for single choice questions
        if (selectedQn?.type == QuestionType.singleChoice) {
          showSecondAttemptWrongDialog(option);
        } else {
          isSecondAttempt
              ? showSecondAttemptWrongDialog(option)
              : showFirstAttemptWrongPrompt();
        }
      }
    }
  }

  void onMultipleOptionSelected() async {
    if (checkedMultipleOptions.isNotEmpty) {
      //if try again clicked
      if (selectedQn?.state == AnswerState.tryAgain) {
        selectedQn?.state = AnswerState.checkAgain;
        checkedMultipleOptions.removeWhere((e) => e.isCorrect == false);
        notifyListeners();
        return;
      }
      //disable selection on answered question
      if (!isAnswered()) {
        isFirstAttempt = true; //user tap once on option
        var isCorrect =
            checkedMultipleOptions.every((e) => e.isCorrect == true);

        if (isCorrect) {
          selectedQn?.state = AnswerState.correct;
          _addQuestionAsAnswered(null);
          //play success sound
          quizController.playSuccessSound();
          await showSuccessDialog();
          //auto move to next question if answer is correct
          await autoMoveToNextPage();
        } else {
          isSecondAttempt
              ? showSecondAttemptWrongDialog(null)
              : showFirstAttemptWrongPrompt();
        }
      }
    }
  }

  void onInputTypeSubmit(String answer) {
    if (selectedQn?.state == AnswerState.tryAgain) {
      inputController.text = '';
      selectedQn?.state = AnswerState.checkAgain;
      notifyListeners();
      return;
    }
    bool? isCorrect = selectedQn?.options!.any(
        (e) => e.option?.trim().toLowerCase() == answer.trim().toLowerCase());
    OptionModel p =
        OptionModel(index: 0, isCorrect: isCorrect ?? false, option: answer);
    onOptionSelected(p);
  }

  void onInputTypeChanged() {
    if (selectedQn?.state == AnswerState.tryAgain) {
      selectedQn?.state = AnswerState.checkAgain;
      notifyListeners();
    }
  }

  void _addQuestionAsAnswered(OptionModel? option) {
    final userAnswer = UserAnsModel(
        optionIndex: option?.index ?? -1,
        id: selectedQn?.id ?? '',
        isCorrect: option?.isCorrect ?? false,
        qIndex: qnNo,
        multipleOptions: checkedMultipleOptions,
        inputAnswer: option?.option);
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

  List<OptionModel> userCheckedAnswers() {
    if (isAnswered()) {
      return _ans.firstWhere((e) => e.id == selectedQn?.id).multipleOptions ??
          [];
    }
    return checkedMultipleOptions;
  }

  String getUserInputAns() {
    if (isAnswered()) {
      return _ans.firstWhere((e) => e.id == selectedQn?.id).inputAnswer ?? '';
    }
    return '';
  }

  Map<String, dynamic> getButtonStyleQuiz() {
    AnswerState state = selectedQn?.state ?? AnswerState.init;

    switch (state) {
      case AnswerState.init:
        return {'text': 'text095', 'color': kcPrimaryColor};
      case AnswerState.correct:
        return {'text': 'text096', 'color': kcCorrectAns};
      case AnswerState.tryAgain:
        return {'text': 'text097', 'color': kcTryAgainAns};
      case AnswerState.checkAgain:
        return {'text': 'text095', 'color': kcPrimaryColor};
      case AnswerState.failed:
        return {'text': 'text108', 'color': kcFailedAns};
      default:
        return {'text': 'text095', 'color': kcPrimaryColor};
    }
  }

  bool isLastPage() => qnNo > questions.length;

  bool isLastQn() => qnNo == questions.length;

  bool isFirstPage() => qnNo == 1;

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

  Future<bool> updateLessonPassCount(
      {required lesson,
      required levelId,
      required topicId,
      required subTopicId}) async {
    setBusy(true);
    var result = await _service.incrementPassRate(
        levelId: levelId,
        topicId: topicId,
        subTopic: subTopicId,
        lessonId: lesson);
    setBusy(false);
    return !result.hasError;
  }

  Future<void> updateDrawingToolCount(
      {required lesson,
      required levelId,
      required topicId,
      required subTopicId}) async {
    //used to update drawing tool used
    var result = await _service.incrementDrawingToolUsed(
        levelId: levelId,
        topicId: topicId,
        subTopic: subTopicId,
        lessonId: lesson);
    quizController.sendDrawToolAnalytics();
  }

  Future<bool> updateLessonFailCount(
      {required lesson,
      required levelId,
      required topicId,
      required subTopicId}) async {
    setBusy(true);
    var result = await _service.incrementFailRate(
        levelId: levelId,
        topicId: topicId,
        subTopic: subTopicId,
        lessonId: lesson);
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
        //update lesson pass rate
        await updateLessonPassCount(
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
            retryQns();
          },
        ));
      } else {
        //on question fail

        //update lesson pass rate
        await updateLessonFailCount(
            lesson: lesson.id,
            levelId: levelId,
            topicId: topicId,
            subTopicId: subTopicId);

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

  Future showSuccessDialog() async {
    return await Get.dialog(AppDialog(
      title: 'text105'.tr,
      image: kIcSuccess,
      subtitle: 'text106'.tr,
      positiveText: 'text091'.tr,
      singleSelection: true,
      onNegativeTap: () {},
      onPositiveTap: () async {
        Get.back();
      },
    ));
  }

  void showFirstAttemptWrongPrompt() {
    selectedQn?.state = AnswerState.tryAgain;
    Get.dialog(
            AppDialogSingle(
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
            ),
            barrierDismissible: true)
        .then((value) {
      isSecondAttempt = true;
      _ans.removeWhere((e) => e.id == selectedQn?.id);
      notifyListeners();
    });
  }

  void showSecondAttemptWrongDialog(OptionModel? option) async {
    selectedQn?.state = AnswerState.failed;
    await Get.dialog(
            AppDialogSingle(
              title: 'text089'.tr,
              content: selectedQn?.promptTwo ?? '',
              subtitle: selectedQn?.question ?? '',
              positiveText: 'text091'.tr,
              onPositiveTap: () async {
                _resetAttempts();
                Get.back();
                _addQuestionAsAnswered(option);
                await autoMoveToNextPage();
              },
            ),
            barrierDismissible: true)
        .then((value) async {
      //on dialog barrier dismissed
      _resetAttempts();
      _addQuestionAsAnswered(option);
      await autoMoveToNextPage();
    });
  }

  bool isMultipleCorrect() {
    var options = selectedQn?.options ?? [];
    final isMultipleCorrect =
        options.where((e) => e.isCorrect ?? false).toList().length >= 2;
    return isMultipleCorrect;
  }

  _resetAttempts() {
    isFirstAttempt = false;
    isSecondAttempt = false;
    _allowNextPage = false;
  }
}
