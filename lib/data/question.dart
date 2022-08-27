import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/data/option.dart';

class QuestionModel {
  String? id;
  int? index;
  String? question;
  List<OptionModel>? options;
  String? inputAnswer;

  QuestionModel({this.id, this.index, this.question, this.options,this.inputAnswer});

  QuestionModel.fromJson(Map<String, dynamic> json) {
   try{
     id = json['id'];
     index = json['index'];
     question = json['question'];
     inputAnswer = json['inputAnswer'];
     if (json['options'] != null) {
       options = [];
       json['options'].forEach((v) {
         options!.add(OptionModel.fromJson(v));
       });
     } else {
       options = [];
     }
   }catch(e){

   }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['index'] = index;
    data['question'] = question;
    data['inputAnswer'] = inputAnswer;
    data['options'] =
        options != null ? options!.map((e) => e.toJson()).toList() : null;
    return data;
  }
  QuestionModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data() as Map<String, dynamic>);
}
