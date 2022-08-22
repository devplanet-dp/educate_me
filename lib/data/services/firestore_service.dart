import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../locator.dart';
import '../firebase_result.dart';
import '../level.dart';
import '../user.dart';
import 'cloud_storage_service.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _levelReference =
      FirebaseFirestore.instance.collection(tbLevel);

  final CollectionReference _categoryCollectionRef =
      FirebaseFirestore.instance.collection('categories');

  final CollectionReference _offersCollection =
      FirebaseFirestore.instance.collection(tbOffers);
  final CollectionReference _commentsCollection =
      FirebaseFirestore.instance.collection(tbMyComments);
  final CollectionReference _requestCollectionRef =
      FirebaseFirestore.instance.collection(tbRequests);

  static const String tbLevel = 'level';
  static const String tbMyReviews = 'reviews';
  static const String tbMyComments = 'comments';
  static const String tbRequests = 'request';
  static const String tbMySupplyVehicle = 'my_supply_vehicles';
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
}
