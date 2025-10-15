import 'package:flutter/material.dart';
import 'package:provider_test/features/assignment/pages/assignment_page.dart';
//import 'package:provider_test/features/login/pages/assignment_page.dart';

class Home {
  final IconData icon;
  final String homeText;
  final Widget?  page;

  Home({required this.icon, required this.homeText, this.page});
}

List<Home> homeList = [
  Home(
    icon:Icons.assignment,
    homeText: "Assignment",
    page: AssignmentPage()
  ),
  Home(
    icon: Icons.book_outlined,
    homeText: "Log book",
  ),
  Home(
    icon: Icons.note,
    homeText: "Course",
  ),
  Home(
    icon: Icons.description,
    homeText: "Result",
  ),




 
];
