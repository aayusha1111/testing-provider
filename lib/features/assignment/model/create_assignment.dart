class CreateAssignment {
  String? title;
  String? description;
  String? subjectId;
  String? deadline;
  String? semester;
  String? faculty;

  CreateAssignment(
      {this.title,
      this.description,
      this.subjectId,
      this.deadline,
      this.semester,
      this.faculty});

  CreateAssignment.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    subjectId = json['subject_id'];
    deadline = json['deadline'];
    semester = json['semester'];
    faculty = json['faculty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['subject_id'] = this.subjectId;
    data['deadline'] = this.deadline;
    data['semester'] = this.semester;
    data['faculty'] = this.faculty;
    return data;
  }
}
