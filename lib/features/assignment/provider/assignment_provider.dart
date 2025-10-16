import 'package:flutter/material.dart';
import 'package:provider_test/features/assignment/model/assignment.dart';
import 'package:provider_test/features/assignment/model/create_assignment.dart';
import 'package:provider_test/features/core/utils/api_response.dart';
import 'package:provider_test/features/core/utils/constants/app_api.dart';
import 'package:provider_test/features/core/utils/services/api_service.dart';
import 'package:provider_test/features/core/utils/view_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentProvider extends ChangeNotifier {
  ViewState getAssignmentStatus = ViewState.idle;
  List<Subject> subjectList = [];
 
  List<AssignmentGetter> assignmentList = [];
  String selectedSubjectId = "";
  ApiService apiService = ApiService();

  List<String> semesterList = [
    "First Semester",
    "Second Semester",
    "Third Semester",
    "Fourth Semester",
    "Fifth Semester",
    "Sixth Semester",
    "Seventh Semester",
    "Eighth Semester",
  ];

  List<String> facultyList = ["BCA", "CSIT", "BIM"];
  String? title, description, subjectId, deadline, semester, faculty;

  setAssignmentStatus(ViewState state) {
    getAssignmentStatus = state;
    notifyListeners();
  }

  Future<void> getSubject() async {
    setAssignmentStatus(ViewState.loading);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    

    ApiResponse apiResponse = await apiService.get(
      endpoint: AppApi.getSubjects,
      token: token,
    
    );

    if (apiResponse.state == ViewState.success) {
      subjectList.addAll(
        (apiResponse.data['data'] as List<dynamic>)
            .map((e) => Subject.fromJson(e))
            .toList(),
      );
      print(subjectList);

      setAssignmentStatus(ViewState.success);
    } else if (apiResponse.state == ViewState.error) {
      setAssignmentStatus(ViewState.error);
    }
  }

  ViewState createAssignmentStatus = ViewState.idle;
  String? errorMessage;
  ApiService service = ApiService();

  setCreateAssignmentState(ViewState value) {
    createAssignmentStatus = value;
    notifyListeners();
  }

  Future<void> createAssignment() async {
    setCreateAssignmentState(ViewState.loading);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    CreateAssignment createAssignment = CreateAssignment(
      title: title,
      description: description,
      subjectId: selectedSubjectId,
      deadline: deadline,
      semester: semester,
      faculty: faculty,
    );
    ApiResponse response = await service.post(
      AppApi.createAssignment,
      data: createAssignment.toJson(),
      token: token,
    );

    if (response.state == ViewState.success) {
      setCreateAssignmentState(ViewState.success);
    } else if (response.state == ViewState.error) {
      errorMessage = response.errorMessage;
      setCreateAssignmentState(ViewState.error);
    }
  }



  //update Assignment
  ViewState updateAssignmentStatus = ViewState.idle;
  

  setUpdateAssignmentState(ViewState value) {
    createAssignmentStatus = value;
    notifyListeners();
  }

  Future<void> updateAssignment(String? assignmnetId) async {
    setCreateAssignmentState(ViewState.loading);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    CreateAssignment createAssignment = CreateAssignment(
      title: title,
      description: description,
      subjectId: selectedSubjectId,
      deadline: deadline,
      semester: semester,
      faculty: faculty,
    );
    ApiResponse response = await service.patch(
      AppApi.updateAssignment+assignmnetId!,
      data: createAssignment.toJson(),
      token: token,
    );

    if (response.state == ViewState.success) {
      setCreateAssignmentState(ViewState.success);
    } else if (response.state == ViewState.error) {
      errorMessage = response.errorMessage;
      setCreateAssignmentState(ViewState.error);
    }
  }

  // Status for loading, success, error
  ViewState _assignmentStatus = ViewState.idle;
  ViewState get assignmentStatus => _assignmentStatus;

  Future<void> getAssignment() async {
    setAssignmentStatus(ViewState.loading);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    ApiResponse apiResponse = await apiService.get(
      endpoint: AppApi.getAssignment,
      token: token,
    );

    if (apiResponse.state == ViewState.success) {
      assignmentList = (apiResponse.data['data'] as List<dynamic>)
          .map((e) => AssignmentGetter.fromJson(e))
          .toList();

      setAssignmentStatus(ViewState.success);
    } else {
      setAssignmentStatus(ViewState.error);
    }
  }

  ViewState deleteAssignmentStatus = ViewState.idle;

  setDeleteAssignmentStatus(ViewState value) {
    deleteAssignmentStatus = value;
    notifyListeners();
  }

   Future<void> deleteAssignment(String assignmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      errorMessage = "Auth token not found.";
      notifyListeners();
      return;
    }

    // Construct URL using the static API endpoint appended with the assignment ID
    final String url = AppApi.deleteAssignment + assignmentId;

    ApiResponse response = await apiService.delete(url, token: token);
    if (response.state == ViewState.success) {
      // Remove the assignment from your list
      assignmentList.removeWhere(
        (assignment) => assignment.assignmentId == assignmentId,
      );
      notifyListeners();
    } else {
      errorMessage = response.errorMessage;
      notifyListeners();
    }
  }
}

class UserRoleProvider extends ChangeNotifier {
  String _role = "user";
  bool _isLoaded = false;

  String get role => _role;
  bool get isLoaded => _isLoaded;

  UserRoleProvider() {
    loadUserRole();
  }

  Future<void> loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString("user_role") ?? "user";
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateUserRole(String newRole) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_role", newRole);
    _role = newRole;
    notifyListeners();
  }
}
