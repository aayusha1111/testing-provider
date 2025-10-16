import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/assignment/pages/add_assignment.dart';
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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AssignmentProvider>(context, listen: false).getAssignment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AssignmentProvider>(
        builder: (context, provider, child) => Stack(
          children: [
            Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: CustomTextformfield(
                    hintText: 'Search assignments...',
                    prefixIcon: const Icon(Icons.search),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),

                // Assignment List
                Expanded(child: assignedUi(provider)),
              ],
            ),

            // Loading Overlay
            if (provider.assignmentStatus == ViewState.loading)
              backdropFilter(context),
          ],
        ),
      ),
    );
  }

  Widget assignedUi(AssignmentProvider provider) {
    // Filter assignments by search query
    final filteredList = provider.assignmentList.where((assignment) {
      final subject = assignment.subject?.name?.toLowerCase() ?? '';
      final faculty = assignment.faculty?.toLowerCase() ?? '';
      return subject.contains(_searchQuery) || faculty.contains(_searchQuery);
    }).toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Text(
          "No assigned assignments yet.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final assignment = filteredList[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Consumer<UserRoleProvider>(
              builder: (context, roleProvider, _) {
                final isTeacherOrAdmin =
                    roleProvider.role == "admin" ||
                    roleProvider.role == "teacher";

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row (Faculty, Semester, and Action Buttons)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${assignment.faculty ?? ''} | ${assignment.semester ?? ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),

                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => AddAssignment(assignment: assignment,),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.red,
                              ),
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
                                    ).deleteAssignment(
                                      assignment.assignmentId!,
                                    );

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
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Subject
                    Text(
                      assignment.subject?.name ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Description
                    if (assignment.description != null &&
                        assignment.description!.isNotEmpty)
                      Text(
                        assignment.description!,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    const SizedBox(height: 8),

                    // Deadline
                    Row(
                      children: [
                        const Icon(
                          Icons.punch_clock,
                          size: 18,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          assignment.deadline != null &&
                                  assignment.deadline!.isNotEmpty
                              ? DateFormat(
                                  'EEEE, dd MMM yyyy',
                                ).format(DateTime.parse(assignment.deadline!))
                              : 'No deadline',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                );
              },
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
