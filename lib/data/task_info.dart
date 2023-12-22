import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TaskInfo {
  int id;
  bool completed;
  String title;
  String description;

  TaskInfo({
    required this.id,
    required this.completed,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'completed': completed,
      'title': title,
      'description': description,
    };
  }

  factory TaskInfo.fromJson(Map<String, dynamic> json) {
    return TaskInfo(
      id: json['id'],
      completed: json['completed'],
      title: json['title'],
      description: json['description'],
    );
  }

  @override
  String toString() {
    return 'TaskInfo{id: $id, completed: $completed, title: $title, description: $description}';
  }
}

typedef AddNewTaskCallback = void Function(TaskInfo newTaskInfo);
