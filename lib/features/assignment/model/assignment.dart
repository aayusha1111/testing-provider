class Subject {
  String? subjectId;
  String? name;
  String? code;
  String? description;
  int? credits;
  String? createdAt;
  String? updatedAt;

  Subject(
      {this.subjectId,
      this.name,
      this.code,
      this.description,
      this.credits,
      this.createdAt,
      this.updatedAt});

  Subject.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    credits = json['credits'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['credits'] = this.credits;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


class AssignmentGetter {
  String? assignmentId;
  String? title;
  String? description;
  Subject? subject;
  String? teacher;
  String? deadline;
  String? faculty;
  String? semester;

  AssignmentGetter(
      {this.assignmentId,
      this.title,
      this.description,
      this.subject,
      this.teacher,
      this.deadline,
      this.faculty,
      this.semester});

  AssignmentGetter.fromJson(Map<String, dynamic> json) {
    assignmentId = json['assignment_id'];
    title = json['title'];
    description = json['description'];
    subject =
        json['subject'] != null ? new Subject.fromJson(json['subject']) : null;
    teacher = json['teacher'];
    deadline = json['deadline'];
    faculty = json['faculty'];
    semester = json['semester'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assignment_id'] = this.assignmentId;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.subject != null) {
      data['subject'] = this.subject!.toJson();
    }
    data['teacher'] = this.teacher;
    data['deadline'] = this.deadline;
    data['faculty'] = this.faculty;
    data['semester'] = this.semester;
    return data;
  }
}