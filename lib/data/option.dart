class OptionModel {
  int? index;
  String? option;
  bool? isCorrect;
  String? qId;

  OptionModel({this.index, this.option, this.isCorrect,this.qId});

  OptionModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    option = json['option'];
    isCorrect = json['isCorrect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['option'] = option;
    data['isCorrect'] = isCorrect;
    return data;
  }


}
