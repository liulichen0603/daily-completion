import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TaskCatagory {
  static int _incId = 0;

  int id;
  String description;

  TaskCatagory.withId({
    required this.id,
    required this.description,
  });
  TaskCatagory({
    required this.description,
  }) : id = _incId++;

  // Add toJson factory method to convert TaskCatagory to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
    };
  }

  factory TaskCatagory.fromJson(Map<String, dynamic> json) {
    return TaskCatagory.withId(
      id: json['id'],
      description: json['description'],
    );
  }

  @override
  String toString() {
    return 'TaskCatagory{id: $id, description: $description}';
  }
}

@JsonSerializable()
class TaskInfo {
  static int _incId = 0;

  late int id;
  bool completed;
  String title;
  String description;
  DateTime createdTime;
  TaskCatagory catagory;

  TaskInfo.withId({
    required this.id,
    required this.completed,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.catagory,
  });
  TaskInfo({
    required this.completed,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.catagory,
  }) : id = _incId++;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'completed': completed,
      'title': title,
      'description': description,
      'createdTime': createdTime.toString(),
      'catagory': catagory.toJson(),
    };
  }

  factory TaskInfo.fromJson(Map<String, dynamic> json) {
    return TaskInfo.withId(
      id: json['id'],
      completed: json['completed'],
      title: json['title'],
      description: json['description'],
      createdTime: DateTime.parse(json['createdTime']),
      catagory: TaskCatagory.fromJson(json['catagory'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return 'TaskInfo{id: $id, completed: $completed, title: $title, description: $description, createdTime: $createdTime, catagory: $catagory}';
  }
}

typedef AddNewTaskCallback = void Function(TaskInfo newTaskInfo);
