

class Subject {
  String? subjectId;
  String? name;

  Subject({this.subjectId, this.name});

  Subject.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['name'] = this.name;
    return data;
  }
}
