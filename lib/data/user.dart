import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { customer, serviceProvider }

enum Gender { male, female, x }

class UserModel {
  String? name;
  String? email;
  String? profileUrl;
  String? userId;
  bool? isActive;
  Timestamp? createdDate;
  bool? isAdmin;
  bool? isEmailVerified;
  UserRole? role;
  String? lName;
  String? fName;
  String? comName;
  String? job;
  List<String>? phone;
  List<String>? photos;
  List<String>? filteredRequest;
  String? playerId;
  int? newOffers;
  String? comPhone;
  String? comProof;
  String? age;
  Gender? gender;
  String? aboutMe;
  String? stripeAccId;
  List<Gender>? interestedGender;

  UserModel(
      {required this.name,
      required this.email,
      this.profileUrl = '',
      required this.userId,
      required this.createdDate,
      this.isAdmin = false,
      this.phone,
      this.role,
      this.fName,
      this.playerId,
      this.lName,
      this.comName,
      this.comProof,
      this.comPhone,
      this.stripeAccId,
      this.aboutMe,
      this.filteredRequest,
      this.job,
      this.newOffers,
      this.age,
      this.gender,
      this.interestedGender,
      this.photos,
      this.isEmailVerified = false,
      this.isActive = true});

  UserModel.fromMap(Map<String, dynamic>? json) {
    name = json!['name'];
    email = json['email'];
    profileUrl = json['profileUrl'];
    userId = json['userId'];
    role = json['role'] != null
        ? UserRole.values.elementAt(json['role'] ?? 0)
        : null;
    gender = json['gender'] != null
        ? Gender.values.elementAt(json['gender'] ?? 0)
        : null;
    if (json['interested_gender'] != null &&
        (json['interested_gender'] is List)) {
      interestedGender = <Gender>[];
      json['interested_gender'].forEach((v) {
        interestedGender!.add(Gender.values.elementAt(v));
      });
    } else {
      interestedGender = [];
    }
    age = json['age'];
    isActive = json['isActive'];
    isAdmin = json['isAdmin'];
    newOffers = json['new_offers'];

    isEmailVerified = json['isEmailVerified'];
    createdDate = json['createdDate'];
    fName = json['fName'];
    lName = json['lName'];
    comName = json['comName'];
    comPhone = json['comPhone'];
    comProof = json['comProof'];
    playerId = json['playerId'];
    stripeAccId = json['stripe_acc_id'];
    job = json['job'];
    aboutMe = json['about_me'];

    if (json['phone'] != null) {
      phone = <String>[];
      json['phone'].forEach((v) {
        phone!.add(v);
      });
    } else {
      phone = [];
    }
    if (json['photos'] != null) {
      photos = <String>[];
      json['photos'].forEach((v) {
        photos!.add(v);
      });
    } else {
      photos = <String>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['profileUrl'] = profileUrl;
    data['userId'] = userId;
    data['isAdmin'] = isAdmin;
    data['isActive'] = isActive;
    data['isEmailVerified'] = isEmailVerified;
    data['role'] = role == null ? null : role!.index;
    data['gender'] = gender == null ? null : gender!.index;
    data['interested_gender'] = interestedGender == null
        ? []
        : interestedGender!.map((e) => e.index).toList();
    data['createdDate'] = createdDate;
    data['phone'] = phone;
    data['stripe_acc_id'] = stripeAccId;
    data['fName'] = fName;
    data['about_me'] = aboutMe;
    data['playerId'] = playerId;
    data['lName'] = lName;
    data['age'] = age;
    data['new_offers'] = newOffers;
    data['job'] = job;
    data['comName'] = comName;
    data['comProof'] = comProof;
    data['comPhone'] = comPhone;
    data['photos'] = photos;
    return data;
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>);
}
