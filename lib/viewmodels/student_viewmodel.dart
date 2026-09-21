import 'package:flutter/foundation.dart';

import '../models/student.dart';
import '../repositories/student_repository.dart';

class StudentViewModel extends ChangeNotifier {
  final StudentRepository _repository = StudentRepository();

  List<Student> _students = [];

  List<Student> get students => _students;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // READ
  Future<void> loadStudents() async {
    _isLoading = true;
    notifyListeners();

    _students = await _repository.getStudents();

    _isLoading = false;
    notifyListeners();
  }

  // CREATE
  Future<void> addStudent({
    required String name,
    required int age,
    required String course,
  }) async {
    final student = Student(
      name: name,
      age: age,
      course: course,
    );

    await _repository.insertStudent(student);

    await loadStudents();
  }

  // UPDATE
  Future<void> updateStudent({
    required int id,
    required String name,
    required int age,
    required String course,
  }) async {
    final student = Student(
      id: id,
      name: name,
      age: age,
      course: course,
    );

    await _repository.updateStudent(student);

    await loadStudents();
  }

  // DELETE
  Future<void> deleteStudent(int id) async {
    await _repository.deleteStudent(id);

    await loadStudents();
  }
}