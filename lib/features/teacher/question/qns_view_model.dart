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
  final ansTEC = TextEditingController();

  setQuestionData(QuestionModel? question) {
    if (question != null) {
      qnsTEC.text = question.question ?? '';
      ansTEC.text = question.inputAnswer ?? '';
      _isMultiple = question.inputAnswer?.isEmpty ?? false;
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

  Future<void> addQuestion({required String levelId, QuestionModel? question}) async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      QuestionModel qn = QuestionModel(
          id: question == null ? const Uuid().v4() : question.id,
          options: addedQns,
          question: qnsTEC.text,
          inputAnswer: ansTEC.text);
      var data = await _service.addStartUpQuestion(qn, levelId);
      if (!data.hasError) {
        Get.back();
        showInfoMessage(message: 'Question added successfully.');
      }
      setBusy(false);
    }
  }

  Future removeQuestion({required levelId, required qId}) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?', description: 'Delete this question?');
    if (response?.confirmed ?? false) {
      setBusy(true);
      await _service.removeStartUpQuestion(qId: qId, levelId: levelId);
      setBusy(false);
      Get.back();
    }
  }

  @override
  void dispose() {
    qnsTEC.dispose();
    super.dispose();
  }
}
