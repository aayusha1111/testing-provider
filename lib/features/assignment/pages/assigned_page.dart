import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/assignment/provider/assignment_provider.dart';
import 'package:provider_test/features/core/utils/helper.dart';
import 'package:provider_test/features/core/utils/view_state.dart';
import 'package:provider_test/widgets/custom_textform_field.dart';

class AssignedPage extends StatefulWidget {
  const AssignedPage({super.key});

  @override
  State<AssignedPage> createState() => _AssignedPageState();
}

class _AssignedPageState extends State<AssignedPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<AssignmentProvider>(
        context,
        listen: false,
      ).getAssignment(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Consumer<AssignmentProvider>(
        builder: (context, provider, child) => Stack(
          children: [

            Column(
              children: [
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: CustomTextformfield(
                    hintText: 'Search assignments...',
                    prefixIcon: const Icon(Icons.search),
                    onChanged: (value) {
                      // You can handle search logic later
                    },
                  ),
                ),
                Expanded(child: assignedUi(provider)),

              ],
            ),
             
            provider.assignmentStatus == ViewState.loading
                ? backdropFilter(context)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget assignedUi(AssignmentProvider provider) {
    if (provider.assignmentList.isEmpty) {
      return const Center(
        child: Text(
          "No assigned assignments yet.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: provider.assignmentList.length,
      itemBuilder: (context, index) {
        final assignment = provider.assignmentList[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Faculty
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: RichText(
                        text: TextSpan(
                          text: "Faculty: ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: assignment.faculty ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                
                    // Semester
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: RichText(
                        text: TextSpan(
                          text: "Semester: ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: assignment.semester ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                
                    // Subject
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: RichText(
                        text: TextSpan(
                          text: "Subject: ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: assignment.subject?.name ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                
                    // Description
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: RichText(
                        text: TextSpan(
                          text: "Description: ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: assignment.description ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                
                    // Deadline
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RichText(
                        text: TextSpan(
                          text: "Deadline: ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: assignment.deadline ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                
                    Consumer<UserRoleProvider>(
                      builder: (context, roleProvider, _) {
                        if (roleProvider.role == "admin" ||
                            roleProvider.role == "teacher") {
                          return Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if (assignment.assignmentId != null) {
                                    bool? confirm = await _showConfirmDialog(
                                      context,
                                      title: "Delete Assignment",
                                      message:
                                          "This will permanently delete this assignment.",
                                      confirmText: "Delete",
                                      confirmColor: Colors.red,
                                      icon: Icons.delete_outline_rounded,
                                    );
                
                                    if (confirm == true) {
                                      await Provider.of<AssignmentProvider>(
                                        context,
                                        listen: false,
                                      ).deleteAssignment(assignment.assignmentId!);
                
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Assignment deleted successfully.",
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete_forever_outlined,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              IconButton(
                                onPressed: () async {
                                  
                                },
                                icon: const Icon(Icons.edit, color: Colors.green),
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                   
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
   Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required Color confirmColor,
    required IconData icon,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: confirmColor, size: 48),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
