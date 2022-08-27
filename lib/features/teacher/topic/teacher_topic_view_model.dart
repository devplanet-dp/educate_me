import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/data/topic.dart';
import 'package:educate_me/features/teacher/sub-topic/teacher_add_sub_topic_view.dart';
import 'package:educate_me/features/teacher/sub-topic/teacher_sub_topic_view.dart';
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

class TeacherTopicViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();
  final _imageSelector = locator<ImageSelector>();
  final _cloudService = locator<CloudStorageService>();
  final formKey = GlobalKey<FormState>();
  final orderTEC = TextEditingController();
  final nameTEC = TextEditingController();

  File? _images;
  String? _uploadedImages;

  String? get uploadedImages => _uploadedImages;

  File? get fileImages => _images;

  List<TopicModel> _topics = [];

  List<TopicModel> get topics => _topics;

  Future addTopic(levelId) async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      var id = const Uuid().v4();
      await _uploadImage(levelId: levelId, topicId: id);

      var topic = TopicModel(
          id: id,
          cover: _uploadedImages,
          order: int.parse(orderTEC.text),
          name: nameTEC.text,
          createdAt: Timestamp.now());

      var result = await _service.addTopic(topic, levelId);
      if (!result.hasError) {
        Get.off(() => TeacherSubTopicView(
              topic: topic,
              levelId: levelId,
            ));
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

  listenToTopics(String id) {
    _service.streamLevelTopics(id).listen((d) {
      _topics = d;
      notifyListeners();
    });
  }

  selectImage() async {
    var isCamera = await Get.bottomSheet(const ImageSelectorSheet(),
        isScrollControlled: false);
    if (isCamera != null) {
      var tempImage = await _imageSelector.selectImage(isCamera);
      if (tempImage != null) {
        _images = File(tempImage.path);
        notifyListeners();
      }
    }
  }

  void clearImage() {
    _images = null;
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
    super.dispose();
  }
}
