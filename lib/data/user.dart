import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, teacher }

class UserModel {
  String? name;
  String? email;
  String? profileUrl;
  String? userId;
  bool? isActive;
  Timestamp? createdDate;
  UserRole? role;
  String? lName;
  String? fName;
  String? playerId;
  String? age;
  String? aboutMe;
  Stats? stats;

  UserModel(
      {required this.name,
      required this.email,
      this.profileUrl = '',
      required this.userId,
      required this.createdDate,
      this.role,
      this.fName,
      this.playerId,
      this.lName,
      this.aboutMe,
      this.age,
      this.stats,
      this.isActive = true});

  UserModel.fromMap(Map<String, dynamic>? json) {
    name = json!['name'];
    email = json['email'];
    profileUrl = json['profileUrl'];
    userId = json['userId'];
    role = json['role'] != null
        ? UserRole.values.elementAt(json['role'] ?? 0)
        : null;
    age = json['age'];
    isActive = json['isActive'];
    createdDate = json['createdDate'];
    fName = json['fName'];
    lName = json['lName'];
    playerId = json['playerId'];
    aboutMe = json['about_me'];
    stats = json['stats'] == null ? null : Stats.fromJson(json['stats']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['profileUrl'] = profileUrl;
    data['userId'] = userId;
    data['isActive'] = isActive;
    data['role'] = role == null ? null : role!.index;
    data['createdDate'] = createdDate;
    data['fName'] = fName;
    data['about_me'] = aboutMe;
    data['playerId'] = playerId;
    data['lName'] = lName;
    data['age'] = age;
    data['stats'] = stats?.toJson();
    return data;
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>);
}

class Stats {
  int? totalAnswered;
  int? totalCorrect;
  int? totalIncorrect;
  String? unlockedLevels;

  Stats(
      {this.totalAnswered,
      this.totalCorrect,
      this.totalIncorrect,
      this.unlockedLevels});

  Stats.fromJson(Map<String, dynamic> json) {
    totalAnswered = json['total_answered'];
    totalCorrect = json['total_correct'];
    totalIncorrect = json['total_incorrect'];
    unlockedLevels = json['unlocked_levels'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_answered'] = totalAnswered;
    data['total_correct'] = totalCorrect;
    data['total_incorrect'] = totalIncorrect;
    data['unlocked_levels'] = unlockedLevels;
    return data;
  }
}
