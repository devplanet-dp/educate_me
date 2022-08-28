import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/data/sub_topic.dart';
import 'package:educate_me/data/topic.dart';
import 'package:flutter/services.dart';

import '../../locator.dart';
import '../firebase_result.dart';
import '../level.dart';
import '../question.dart';
import '../user.dart';
import 'cloud_storage_service.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _levelReference =
      FirebaseFirestore.instance.collection(tbLevel);

  final CollectionReference _questionReference =
      FirebaseFirestore.instance.collection(tbQuestions);

  static const String tbLevel = 'level';
  static const String tbQuestions = 'questions';
  static const String tbTopic = 'topic';
  static const String tbSubTopic = 'sub_topic';
  static const String tbLesson = 'tbLesson';
  static const String tbMyServices = 'my_services';
  static const String tbOffers = 'offers';
  static const String tbFilteredRequest = 'my_out_request';

  late FirebaseFirestore _firestore;

  final _cloudService = locator<CloudStorageService>();

  FirestoreService() {
    _firestore = FirebaseFirestore.instance;
  }

  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference
          .doc(user.userId)
          .set(user.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future deleteCurrentUser(String uid) async {
    try {
      await _usersCollectionReference.doc(uid).delete();
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future<FirebaseResult> updateUser(
      {required UserModel user, required List<String> phone}) async {
    try {
      await _usersCollectionReference
          .doc(user.userId)
          .set(user.toJson(), SetOptions(merge: true));
      await _usersCollectionReference
          .doc(user.userId)
          .update({'phone': FieldValue.arrayUnion(phone)});
      return FirebaseResult(data: true);
    } catch (e) {
      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Future<bool> isUserExists(String uid) async {
    var doc = await _usersCollectionReference.doc(uid).get();
    return doc.exists;
  }

  Stream<UserModel> streamUser(String uid) {
    var snap = _usersCollectionReference.doc(uid).snapshots();
    return snap.map((doc) => UserModel.fromSnapshot(doc));
  }

  Future<UserModel> getUserById(String uid) async {
    var userData = await _usersCollectionReference.doc(uid).get();
    return UserModel.fromSnapshot(userData);
  }

  Stream<List<UserModel>> streamServiceProviders() {
    Stream<QuerySnapshot> snap = _usersCollectionReference
        .where('role', isEqualTo: 1)
        .limit(10)
        .snapshots();

    return snap.map((snapshot) => snapshot.docs.map((doc) {
          return UserModel.fromSnapshot(doc);
        }).toList());
  }

  Future<FirebaseResult> getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return FirebaseResult(data: UserModel.fromSnapshot(userData));
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  //start_level
  Future<FirebaseResult> createLevel(LevelModel level) async {
    try {
      await _levelReference
          .doc(level.id)
          .set(level.toJson(), SetOptions(merge: true));
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Stream<List<LevelModel>> streamLevels() {
    Stream<QuerySnapshot> snap = _levelReference.snapshots();

    return snap.map((snapshot) => snapshot.docs.map((doc) {
          return LevelModel.fromSnapshot(doc);
        }).toList());
  }

  Future<FirebaseResult> removeLevel(String id) async {
    try {
      await _levelReference.doc(id).delete();
      return FirebaseResult(data: true);
    } catch (e) {
      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  //questions
  Future<FirebaseResult> addStartUpQuestion(
      QuestionModel qns, String levelId) async {
    try {
      await _levelReference
          .doc(levelId)
          .collection(tbQuestions)
          .doc(qns.id ?? '')
          .set(qns.toJson(), SetOptions(merge: true));
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Stream<List<QuestionModel>> streamStartUpQuestions(String levelId) {
    Stream<QuerySnapshot> snap =
        _levelReference.doc(levelId).collection(tbQuestions).snapshots();
    return snap.map((snapshot) => snapshot.docs.map((doc) {
          return QuestionModel.fromSnapshot(doc);
        }).toList());
  }

  Future<FirebaseResult> removeStartUpQuestion(
      {required levelId, required qId}) async {
    try {
      await _levelReference
          .doc(levelId)
          .collection(tbQuestions)
          .doc(qId)
          .delete();
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  //topics
  Future<FirebaseResult> addTopic(TopicModel topic, String levelId) async {
    try {
      await _levelReference
          .doc(levelId)
          .collection(tbTopic)
          .doc(topic.id ?? '')
          .set(topic.toJson(), SetOptions(merge: true));
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Stream<List<TopicModel>> streamLevelTopics(String levelId) {
    Stream<QuerySnapshot> snap =
        _levelReference.doc(levelId).collection(tbTopic).orderBy('order').snapshots();
    return snap.map((snapshot) => snapshot.docs.map((doc) {
          return TopicModel.fromSnapshot(doc);
        }).toList());
  }

  Future<FirebaseResult> removeTopic({required levelId, required tId}) async {
    try {
      await _levelReference.doc(levelId).collection(tbTopic).doc(tId).delete();
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  //sub-topics
  Future<FirebaseResult> addSubTopic(
      {required SubTopicModel subTopic,
      required levelId,
      required topicId}) async {
    try {
      await _levelReference
          .doc(levelId)
          .collection(tbTopic)
          .doc(topicId)
          .collection(tbSubTopic)
          .doc(subTopic.id)
          .set(subTopic.toJson(), SetOptions(merge: true));
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Stream<List<SubTopicModel>> streamSubTopic(
      {required levelId, required topicId}) {
    Stream<QuerySnapshot> snap = _levelReference
        .doc(levelId)
        .collection(tbTopic)
        .doc(topicId)
        .collection(tbSubTopic)
        .orderBy('order')
        .snapshots();
    return snap.map((snapshot) => snapshot.docs.map((doc) {
          return SubTopicModel.fromSnapshot(doc);
        }).toList());
  }

  Future<FirebaseResult> removeSubTopic(
      {required levelId, required topicId, required subTopic}) async {
    try {
      await _levelReference
          .doc(levelId)
          .collection(tbTopic)
          .doc(topicId)
          .collection(tbSubTopic)
          .doc(subTopic)
          .delete();
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  //lessons
  Future<FirebaseResult> addLesson(
      {required LessonModel lesson,
      required levelId,
      required topicId,
      required subTopicId}) async {
    try {
      await _levelReference
          .doc(levelId)
          .collection(tbTopic)
          .doc(topicId)
          .collection(tbSubTopic)
          .doc(subTopicId)
          .collection(tbLesson)
          .doc(lesson.id)
          .set(lesson.toJson(), SetOptions(merge: true));
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Stream<List<LessonModel>> streamLessons(
      {required levelId, required topicId, required subTopicId}) {
    Stream<QuerySnapshot> snap = _levelReference
        .doc(levelId)
        .collection(tbTopic)
        .doc(topicId)
        .collection(tbSubTopic)
        .doc(subTopicId)
        .collection(tbLesson)
        .orderBy('order')
        .snapshots();
    return snap.map((snapshot) => snapshot.docs.map((doc) {
          return LessonModel.fromSnapshot(doc);
        }).toList());
  }

  Future<FirebaseResult> removeLesson(
      {required levelId,
      required topicId,
      required subTopic,
      required lessonId}) async {
    try {
      await _levelReference
          .doc(levelId)
          .collection(tbTopic)
          .doc(topicId)
          .collection(tbSubTopic)
          .doc(subTopic)
          .collection(tbLesson)
          .doc(lessonId)
          .delete();
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  //questions
  Future<FirebaseResult> addQuestions(
      {required QuestionModel question,
      required levelId,
      required topicId,
      required subTopicId,
      required lessonId}) async {
    try {
      await _levelReference
          .doc(levelId)
          .collection(tbTopic)
          .doc(topicId)
          .collection(tbSubTopic)
          .doc(subTopicId)
          .collection(tbLesson)
          .doc(lessonId)
          .collection(tbQuestions)
          .doc(question.id)
          .set(question.toJson(), SetOptions(merge: true));
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Stream<List<QuestionModel>> streamQuestions(
      {required levelId,
      required topicId,
      required subTopicId,
      required lessonId}) {
    Stream<QuerySnapshot> snap = _levelReference
        .doc(levelId)
        .collection(tbTopic)
        .doc(topicId)
        .collection(tbSubTopic)
        .doc(subTopicId)
        .collection(tbLesson)
        .doc(lessonId)
        .collection(tbQuestions)
        .snapshots();
    return snap.map((snapshot) => snapshot.docs.map((doc) {
          return QuestionModel.fromSnapshot(doc);
        }).toList());
  }

  Future<FirebaseResult> removeQuestion(
      {required levelId,
      required topicId,
      required subTopic,
      required lessonId,
      required questionId}) async {
    try {
      await _levelReference
          .doc(levelId)
          .collection(tbTopic)
          .doc(topicId)
          .collection(tbSubTopic)
          .doc(subTopic)
          .collection(tbLesson)
          .doc(lessonId)
          .collection(tbQuestions)
          .doc(questionId)
          .delete();
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message.toString());
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }
}
