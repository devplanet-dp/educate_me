import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/teacher/level/teacher_qns_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/image_selector_sheet.dart';
import '../../../data/services/cloud_storage_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/image_service.dart';
import '../../../locator.dart';

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

  File? _images;
  String? _uploadedImages;

  String? get uploadedImages => _uploadedImages;

  File? get fileImages => _images;

  List<LessonModel> _lessons = [];

  List<LessonModel> get lessons => _lessons;

  setInitDate(LessonModel lesson) {
    orderTEC.text = '${lesson.order}';
    nameTEC.text = lesson.title ?? '';
    maxQnsTEC.text = '${lesson.maxQuestions}';
    descTEC.text = lesson.description ?? '';
    _uploadedImages = lesson.cover;
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
                lessonId: id,
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

  Future removeLesson(
      {required levelId,
      required topicId,
      required subTopicId,
      required lessonId}) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?', description: 'Delete this lesson');
    if (response?.confirmed ?? false) {
      setBusy(true);
      await _service.removeLesson(
          levelId: levelId,
          subTopic: subTopicId,
          lessonId: lessonId,
          topicId: topicId);
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

  @override
  void dispose() {
    orderTEC.dispose();
    nameTEC.dispose();
    descTEC.dispose();
    maxQnsTEC.dispose();
    super.dispose();
  }
}
