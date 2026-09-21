import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/student_viewmodel.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() =>
      _StudentListScreenState();
}

class _StudentListScreenState
    extends State<StudentListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<StudentViewModel>()
          .loadStudents();
    });
  }

  void _openAddStudent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const StudentFormScreen(),
      ),
    );
  }

  void _openEditStudent(student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            StudentFormScreen(
              student: student,
            ),
      ),
    );
  }

  Future<void> _deleteStudent(
      int id,
      ) async {
    final viewModel =
    context.read<StudentViewModel>();

    await viewModel.deleteStudent(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student deleted'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Management',
        ),
      ),

      floatingActionButton:
      FloatingActionButton(
        onPressed: _openAddStudent,
        child: const Icon(Icons.add),
      ),

      body: Consumer<StudentViewModel>(
        builder: (
            context,
            viewModel,
            child,
            ) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.students.isEmpty) {
            return const Center(
              child: Text(
                'No students found',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount:
            viewModel.students.length,
            itemBuilder: (
                context,
                index,
                ) {
              final student =
              viewModel.students[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      student.name[0]
                          .toUpperCase(),
                    ),
                  ),

                  title: Text(
                    student.name,
                  ),

                  subtitle: Text(
                    'Age: ${student.age}\n'
                        'Course: ${student.course}',
                  ),

                  isThreeLine: true,

                  trailing: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          _openEditStudent(
                            student,
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                        ),
                        onPressed: () {
                          _showDeleteDialog(
                            student.id!,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Student',
          ),
          content: const Text(
            'Are you sure you want to delete this student?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                await _deleteStudent(id);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}