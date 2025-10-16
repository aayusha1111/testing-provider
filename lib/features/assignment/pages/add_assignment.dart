import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/assignment/model/assignment.dart';
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
  AssignmentGetter?assignment;
   AddAssignment({super.key,this.assignment});

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
    if(widget.assignment!=null){
      assignmentProvider.semester=widget.assignment?.semester;
      assignmentProvider.faculty=widget.assignment?.faculty;
      assignmentProvider.selectedSubjectId=widget.assignment?.subject?.subjectId??"";
      assignmentProvider.title=widget.assignment?.title;
      assignmentProvider.deadline=widget.assignment?.deadline;
      assignmentProvider.description=widget.assignment?.description;

    }
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
        initialValue: widget.assignment?.title,
        
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
        initialValue: widget.assignment?.description,
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
          value: widget.assignment?.subject?.subjectId,
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
        initialValue: widget.assignment?.deadline,
        onChanged: (p0) {
          assignmentProvider.deadline = p0;
        },
        labelText: "Deadline",
      ),

      CustomDropDown(
        initialValue: widget.assignment?.semester,
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
        initialValue:widget.assignment?.faculty ,
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
          if (widget.assignment == null) {
            await assignmentProvider.createAssignment();
          } else {
            await assignmentProvider.updateAssignment(widget.assignment?.assignmentId!);
          }

          if (assignmentProvider.createAssignmentStatus == ViewState.success) {
            displaySnackBar(context,widget.assignment==null? assignmentCreatedMessage:assignmetUpdatedMessage);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AssignmentPage()),
              (Route<dynamic> route) => false,
            );
          } else if (assignmentProvider.createAssignmentStatus ==
              ViewState.error) {
            displaySnackBar(
              context,widget.assignment==null?
              assignmenterrorMessage:assignmentUpdatederrorMessage,
            );
          }
        },
        backgroundColor: secondaryColor,
        child: Text(widget.assignment==null? createLabel:updateLabel )
      ),
    ],
  );
}
