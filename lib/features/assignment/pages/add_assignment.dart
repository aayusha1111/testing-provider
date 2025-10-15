import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/assignment/pages/assigned_page.dart';
import 'package:provider_test/features/assignment/pages/assignment_page.dart';
import 'package:provider_test/features/assignment/provider/assignment_provider.dart';
import 'package:provider_test/features/core/utils/constants/app_color.dart';
import 'package:provider_test/features/core/utils/constants/app_string.dart';
import 'package:provider_test/features/core/utils/helper.dart';
import 'package:provider_test/features/core/utils/view_state.dart';
import 'package:provider_test/widgets/custom_drop_down.dart';
import 'package:provider_test/widgets/custom_elevated_button.dart';
import 'package:provider_test/widgets/custom_textform_field.dart';

class AddAssignment extends StatefulWidget {
  const AddAssignment({super.key});

  @override
  State<AddAssignment> createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  @override
  void initState() {
    Future.microtask(() {
      getSubjects();
    });
    super.initState();
  }

  void getSubjects() async {
    final assignmentProvider = Provider.of<AssignmentProvider>(
      context,
      listen: false,
    );
    await assignmentProvider.getSubject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: SingleChildScrollView(
        child: Consumer<AssignmentProvider>(
          builder: (context, assignmentProvider, child) => Stack(
            children: [
              addAsignmentUi(assignmentProvider),
              assignmentProvider.createAssignmentStatus == ViewState.loading
                  ? backdropFilter(context)
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget addAsignmentUi(AssignmentProvider assignmentProvider) => Column(
    children: [
      CustomTextformfield(
        initialValue: assignmentProvider.title,
        
        onChanged: (value) {
          assignmentProvider.title = value;
        },
        labelText: titleStr,
        validator: (value) {
          if (value!.isEmpty) {
            return titleValidationStr;
          }
          return null;
        },
      ),

      CustomTextformfield(
        initialValue: assignmentProvider.description,
        onChanged: (value) {
          assignmentProvider.description = value;
        },
        labelText: descriptionStr,
        validator: (value) {
          if (value!.isEmpty) {
            return descriptionValidatorStr;
          }
          return null;
        },
      ),

      Padding(
        padding: const EdgeInsets.all(12),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            labelText: "Subject",
          ),
          items: assignmentProvider.subjectList
              .map(
                (e) =>
                    DropdownMenuItem(child: Text(e.name!), value: e.subjectId),
              )
              .toList(),
          onChanged: (value) {
            assignmentProvider.selectedSubjectId = value!;
          },
        ),
      ),

      CustomTextformfield(
        initialValue: assignmentProvider.deadline,
        onChanged: (p0) {
          assignmentProvider.deadline = p0;
        },
        labelText: "Deadline",
      ),

      CustomDropDown(
        labelText: semseterStr,
        validator: (value) {
          if (value!.isEmpty) {
            return semesterValidatorStr;
          }
          return null;
        },
        onChanged: (value) {
          assignmentProvider.semester = value;
        },
        itemList: assignmentProvider.semesterList,
      ),

      CustomDropDown(
        labelText: facultyStr,
        validator: (value) {
          if (value!.isEmpty) {
            return facultyValidatorStr;
          }
          return null;
        },
        onChanged: (value) {
          assignmentProvider.faculty = value;
        },
        itemList: assignmentProvider.facultyList,
      ),

      CustomElevatedButton(
        onPressed: () async {
          await assignmentProvider.createAssignment();

          if (assignmentProvider.createAssignmentStatus == ViewState.success) {
            displaySnackBar(context, assignmentCreatedMessage);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AssignmentPage()),
              (Route<dynamic> route) => false,
            );
          } else if (assignmentProvider.createAssignmentStatus ==
              ViewState.error) {
            displaySnackBar(
              context,
              assignmentProvider.errorMessage ?? assignmenterrorMessage,
            );
          }
        },
        backgroundColor: secondaryColor,
        child: Text("Submit", style: TextStyle(fontSize: 18)),
      ),
    ],
  );
}
