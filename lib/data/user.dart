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
  String? comName;
  String? playerId;
  String? age;
  String? aboutMe;

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
      this.comName,
      this.aboutMe,
      this.age,
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
    comName = json['comName'];
    playerId = json['playerId'];
    aboutMe = json['about_me'];
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
    data['comName'] = comName;
    return data;
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>);
}
