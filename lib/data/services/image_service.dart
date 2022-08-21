import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/shared/app_colors.dart';


class ImageSelector {
  Future<File?> selectImage([bool camera = false]) async {
    var pickedFile = await ImagePicker()
        .pickImage(source: camera ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      return cropImage(pickedFile);
    }
    return null;
  }

  Future<XFile?> selectSelfie() async {
    return await ImagePicker().pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
  }

  Future<File?> cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'text038'.tr,
            toolbarColor: kcPrimaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'text038'.tr,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<PickedFile?> selectVideo() async {
    return await ImagePicker().getVideo(source: ImageSource.gallery);
  }
}
