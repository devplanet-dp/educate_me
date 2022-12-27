import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/core/utils/app_controller.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/teacher/level/teacher_qns_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/image_selector_sheet.dart';
import '../../../data/services/cloud_storage_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/image_service.dart';
import '../../../locator.dart';

const separator = '|barrier|';

class TeacherLessonViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();
  final _imageSelector = locator<ImageSelector>();
  final _cloudService = locator<CloudStorageService>();
  final formKey = GlobalKey<FormState>();
  final orderTEC = TextEditingController();
  final maxQnsTEC = TextEditingController();
  final nameTEC = TextEditingController();
  final descTEC = TextEditingController();
  final contentTEC = TextEditingController();
  final correctPassTEC = TextEditingController();
  final HtmlEditorController htmlController = HtmlEditorController();
  final AppController appController = Get.find<AppController>();

  List<String> lessonBarrier = [];

  File? _images;
  String? _uploadedImages;

  String? get uploadedImages => _uploadedImages;

  File? get fileImages => _images;

  List<LessonModel> _lessons = [];

  List<LessonModel> get lessons => _lessons;

  bool _isMultiselect = false;

  bool get multiSelect => _isMultiselect;

  toggleMultiSelect() {
    _isMultiselect = !_isMultiselect;
    selectedQnsIds.clear();
    notifyListeners();
  }
  List<String> selectedQnsIds = [];

  bool isLessonSelected(String qns) => selectedQnsIds.contains(qns) && multiSelect;

  void onQnsSelectedForDelete(String qns) {
    if (selectedQnsIds.contains(qns)) {
      selectedQnsIds.remove(qns);
    } else {
      selectedQnsIds.add(qns);
    }
    notifyListeners();
  }

  Future removeLesson(
      {required levelId,
        required topic,
        required subTopic}) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?',
        description: 'Delete ${selectedQnsIds.length} lessons?');
    if (response?.confirmed ?? false) {
      setBusy(true);
      for (var e in selectedQnsIds) {
        await _service.removeLesson(
            levelId: levelId,
            topicId: topic,
            subTopic: subTopic,
            lessonId: e);
      }
      selectedQnsIds.clear();
      setBusy(false);
    }
  }


  setInitDate(LessonModel? lesson) {
    if(lesson!=null) {
      orderTEC.text = '${lesson.order}';
      nameTEC.text = lesson.title ?? '';
      maxQnsTEC.text = '${lesson.maxQuestions}';
      descTEC.text = lesson.description ?? '';
      correctPassTEC.text = '${lesson.noCorrectToPass ?? 0}';
      _uploadedImages = lesson.cover;
      appController.htmlContent.value = '';
      if (lesson.content?.isNotEmpty ?? false) {
        contentTEC.text = '${lesson.content?.length} Barriers';
        appController.htmlContent.value = lesson.content!.join(separator);
      }
    }else{
      appController.htmlContent.value='';
    }

    notifyListeners();
  }

  initHtmlEditor() {
    htmlController.setText(appController.htmlContent.value);
    htmlController.setFocus();
  }

  calculatePassQuizLimit() {
    if (maxQnsTEC.text.isNotEmpty) {
      correctPassTEC.text = '${(int.parse(maxQnsTEC.text) * .8).round()}';
    } else {
      correctPassTEC.text = '';
    }
    notifyListeners();
  }

  Future addLesson(
      {required levelId,
      required topicId,
      required subTopicId,
      LessonModel? l}) async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      var id = l == null ? const Uuid().v4() : l.id;
      await _uploadImage(levelId: levelId, topicId: id);

      var lesson = LessonModel(
          id: id,
          cover: _uploadedImages,
          order: int.parse(orderTEC.text),
          maxQuestions: int.parse(maxQnsTEC.text),
          title: nameTEC.text,
          description: descTEC.text,
          noCorrectToPass: int.parse(correctPassTEC.text),
          content: lessonBarrier,
          createdAt: Timestamp.now());

      var result = await _service.addLesson(
          topicId: topicId,
          lesson: lesson,
          levelId: levelId,
          subTopicId: subTopicId);
      if (!result.hasError) {
        if (l == null) {
          Get.off(() => TeacherQnsView(
                levelId: levelId,
                topicId: topicId,
                subTopicId: subTopicId,
                lessonId: lesson,
              ));
        } else {
          Get.back();
        }
      } else {
        showErrorMessage(message: result.errorMessage);
      }
      setBusy(false);
    }
  }

  Future removeSubTopic(
      {required levelId, required topicId, required subTopicId}) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?', description: 'Delete this Sub-Topic');
    if (response?.confirmed ?? false) {
      setBusy(true);
      await _service.removeSubTopic(
          levelId: levelId, subTopic: subTopicId, topicId: topicId);
      setBusy(false);
      Get.back();
    }
  }

  listenToLessons({required levelId, required topicId, required subTopicId}) {
    _service
        .streamLessons(
            subTopicId: subTopicId, levelId: levelId, topicId: topicId)
        .listen((d) {
      _lessons = d;
      notifyListeners();
    });
  }

  selectImage() async {
    var isCamera = await Get.bottomSheet(const ImageSelectorSheet(),
        isScrollControlled: false);
    if (isCamera != null) {
      clearImage();
      var tempImage = await _imageSelector.selectImage(isCamera);
      if (tempImage != null) {
        _images = File(tempImage.path);
        notifyListeners();
      }
    }
  }

  void clearImage() async {
    _images = null;
    if (uploadedImages != null) {
      deleteImage(uploadedImages!);
    }
    notifyListeners();
  }

  Future deleteImage(String url) async {
    setBusy(true);
    var result = await _cloudService.deleteImage(url);
    _uploadedImages = null;
    setBusy(false);
  }

  Future _uploadImage({required levelId, required topicId}) async {
    if (fileImages != null) {
      var result = await _cloudService.uploadTopicImage(
          imageToUpload: fileImages, levelId: levelId, topicId: topicId);
      _uploadedImages = result.imageUrl;
    }
  }

  onLessonContentSubmitClicked() async {
    try {
      final text = await htmlController.getText();
      appController.htmlContent.value = text;
      Get.back();
    } catch (e) {
      showErrorMessage(message: 'Error in barrier format. Please check again');
    }
  }

  setBarrierContent(content) {
    try {
      lessonBarrier.clear();
      if (appController.htmlContent.value.isNotEmpty) {
        List<String> barriers =
            appController.htmlContent.value.split(separator);
        for (var d in barriers) {
          if (d.trim().isNotEmpty) {
            lessonBarrier.add(d);
          }
        }
      }
      contentTEC.text =
          lessonBarrier.isNotEmpty ? '${lessonBarrier.length} Barriers' : '';
      notifyListeners();
    } catch (e) {
      showErrorMessage(
          message:
              'Unexpected error in barrier content. Please check it again');
    }
  }

  @override
  void dispose() {
    orderTEC.dispose();
    nameTEC.dispose();
    descTEC.dispose();
    maxQnsTEC.dispose();
    correctPassTEC.dispose();
    contentTEC.dispose();
    super.dispose();
  }
}
