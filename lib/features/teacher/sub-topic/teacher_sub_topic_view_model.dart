import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/features/teacher/lesson/teacher_lesson_view.dart';
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
import '../../../data/sub_topic.dart';
import '../../../locator.dart';

class TeacherSubTopicViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();
  final _imageSelector = locator<ImageSelector>();
  final _cloudService = locator<CloudStorageService>();
  final formKey = GlobalKey<FormState>();
  final orderTEC = TextEditingController();
  final nameTEC = TextEditingController();
  final descTEC = TextEditingController();

  bool _isMultiselect = false;

  bool get multiSelect => _isMultiselect;

  toggleMultiSelect() {
    _isMultiselect = !_isMultiselect;
    selectedQnsIds.clear();
    notifyListeners();
  }

  File? _images;
  String? _uploadedImages;

  String? get uploadedImages => _uploadedImages;

  File? get fileImages => _images;

  List<SubTopicModel> _topics = [];

  List<SubTopicModel> get topics => _topics;


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

  Future removeSubTopic(
      {required levelId,
        required topic}) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?',
        description: 'Delete ${selectedQnsIds.length} sub-topics?');
    if (response?.confirmed ?? false) {
      setBusy(true);
      for (var e in selectedQnsIds) {
        await _service.removeSubTopic(
            levelId: levelId,
            topicId: topic,
            subTopic: e);
      }
      selectedQnsIds.clear();
      setBusy(false);
    }
  }


  setInitDate(SubTopicModel topic) {
    orderTEC.text = '${topic.order}';
    nameTEC.text = topic.title ?? '';
    descTEC.text = topic.description ?? '';
    _uploadedImages = topic.cover;
    notifyListeners();
  }

  Future addSubTopic({required topicId, required levelId,required SubTopicModel? t}) async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      var id = t==null? const Uuid().v4():t.id;
      await _uploadImage(levelId: levelId, topicId: topicId, subtopicId: id);
      var topic = SubTopicModel(
          id: id,
          cover: _uploadedImages,
          description: descTEC.text,
          order: int.parse(orderTEC.text),
          title: nameTEC.text,
          createdAt: Timestamp.now());
      var result = await _service.addSubTopic(
          topicId: topicId, subTopic: topic, levelId: levelId);
      if (!result.hasError) {
        if(t==null) {
          Get.off(() =>
              TeacherLessonView(
                  levelId: levelId, topicId: topicId, subTopic: topic));
        }else{
          Get.back();
        }
      } else {
        showErrorMessage(message: result.errorMessage);
      }
      setBusy(false);
    }
  }

  Future removeTopic({required levelId, required topicId}) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?', description: 'Delete this topic');
    if (response?.confirmed ?? false) {
      setBusy(true);
      await _service.removeTopic(levelId: levelId, tId: topicId);
      setBusy(false);
      Get.back();
    }
  }

  listenToTopics({required levelId, required topicId}) {
    _service.streamSubTopic(levelId: levelId, topicId: topicId).listen((d) {
      _topics = d;
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

  void clearImage() {
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

  Future _uploadImage(
      {required levelId, required topicId, required subtopicId}) async {
    if (fileImages != null) {
      var result = await _cloudService.uploadSubTopicImage(
          imageToUpload: fileImages,
          levelId: levelId,
          topicId: topicId,
          subtopicId: subtopicId);
      _uploadedImages = result.imageUrl;
    }
  }

  @override
  void dispose() {
    orderTEC.dispose();
    nameTEC.dispose();
    descTEC.dispose();
    super.dispose();
  }
}
