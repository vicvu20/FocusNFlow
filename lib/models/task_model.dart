class Task {
  final String id;
  final String title;
  final String course;
  final DateTime dueDate;
  final int effort;
  final int weight;

  Task({
    required this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    required this.effort,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'course': course,
      'dueDate': dueDate.toIso8601String(),
      'effort': effort,
      'weight': weight,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      course: map['course'] ?? '',
      dueDate: DateTime.parse(map['dueDate']),
      effort: map['effort'] ?? 1,
      weight: map['weight'] ?? 1,
    );
  }
}