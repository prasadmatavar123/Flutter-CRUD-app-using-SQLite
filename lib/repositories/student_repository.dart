import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/student.dart';

class StudentRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // CREATE
  Future<int> insertStudent(Student student) async {
    final Database db = await _databaseHelper.database;

    return await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ
  Future<List<Student>> getStudents() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps =
    await db.query(
      'students',
      orderBy: 'id DESC',
    );

    return maps
        .map(
          (map) => Student.fromMap(map),
    )
        .toList();
  }

  // UPDATE
  Future<int> updateStudent(Student student) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // DELETE
  Future<int> deleteStudent(int id) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}