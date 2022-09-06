import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/core/widgets/app_dialog.dart';
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
  final PageController pageController = PageController(initialPage: 0);

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
    if (qnNo < questions.length+1) {
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
    pageController.animateToPage((pageController.page! + 1).toInt(),
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    _incrementQno();
  }

  goToPrvQn() {
    pageController.animateToPage((pageController.page! - 1).toInt(),
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    _decrementQno();
  }

  void onOptionSelected(OptionModel option) {
    if (!isAnswered()) {
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

  bool isLastPage() =>qnNo > questions.length;

  int noCorrectAns()=>ans.where((e) => e.isCorrect).length;

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

  Future finishExam(LessonModel lesson)async{
    if(noCorrectAns()>=lesson.noCorrectToPass!) {
      Get.dialog(AppDialog(
        title: 'text056'.tr, image: kImgSuccess, subtitle: 'text057'.tr,));
    }else{
      Get.dialog(AppDialog(
        title: 'text058'.tr, image: kImgFail, subtitle: 'text059'.tr,));
    }
  }
}
