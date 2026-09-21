class Student {
  final int? id;
  final String name;
  final int age;
  final String course;

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.course,
  });

  // Convert Dart object → SQLite Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'course': course,
    };
  }

  // Convert SQLite Map → Dart object
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      course: map['course'],
    );
  }
}