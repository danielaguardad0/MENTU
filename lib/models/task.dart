class TaskModel {
  int? id;
  int userId;
  String title;
  String subject;
  String dueDate; // ISO yyyy-MM-dd
  String priority; // 'baja'|'media'|'alta'
  bool completed;

  TaskModel({
    this.id,
    required this.userId,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.priority,
    this.completed = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'subject': subject,
        'due_date': dueDate,
        'priority': priority,
        'completed': completed ? 1 : 0,
      };

  factory TaskModel.fromMap(Map<String, dynamic> m) => TaskModel(
        id: m['id'] as int?,
        userId: m['user_id'] as int,
        title: m['title'] as String,
        subject: m['subject'] as String,
        dueDate: m['due_date'] as String,
        priority: m['priority'] as String,
        completed: (m['completed'] ?? 0) == 1,
      );
}
