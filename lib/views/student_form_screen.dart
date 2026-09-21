import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({
    super.key,
    this.student,
  });

  @override
  State<StudentFormScreen> createState() =>
      _StudentFormScreenState();
}

class _StudentFormScreenState
    extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _courseController;

  bool get isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.student?.name ?? '',
    );

    _ageController = TextEditingController(
      text: widget.student?.age.toString() ?? '',
    );

    _courseController = TextEditingController(
      text: widget.student?.course ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _courseController.dispose();

    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel =
    context.read<StudentViewModel>();

    final name = _nameController.text.trim();
    final age = int.parse(
      _ageController.text.trim(),
    );
    final course = _courseController.text.trim();

    if (isEditing) {
      await viewModel.updateStudent(
        id: widget.student!.id!,
        name: name,
        age: age,
        course: course,
      );
    } else {
      await viewModel.addStudent(
        name: name,
        age: age,
        course: course,
      );
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Edit Student'
              : 'Add Student',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter age';
                  }

                  if (int.tryParse(value) == null) {
                    return 'Enter valid age';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter course';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveStudent,
                  child: Text(
                    isEditing
                        ? 'Update Student'
                        : 'Save Student',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}