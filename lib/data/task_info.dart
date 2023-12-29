import 'package:daily_completion/data/local_storage.dart';
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

  Future<TaskCatagory?> getCatagoryById(int id) async {
    List<TaskCatagory> catagoryList =
        await TaskCatagoryStorage.getInstance().readCatagoryList();
    for (TaskCatagory cata in catagoryList) {
      if (id == cata.id) {
        return cata;
      }
    }
    return null;
  }
}

typedef VoidTaskCatagoryCallback = void Function(TaskCatagory? newCatagoryInfo);

@JsonSerializable()
class TaskInfo {
  static int _incId = 0;

  late int id;
  bool completed;
  String title;
  String description;
  DateTime createdTime;
  double duration;
  int catagoryId;

  TaskInfo.withId({
    required this.id,
    required this.completed,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.duration,
    required this.catagoryId,
  });
  TaskInfo({
    required this.completed,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.duration,
    required this.catagoryId,
  }) : id = _incId++;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'completed': completed,
      'title': title,
      'description': description,
      'createdTime': createdTime.toString(),
      'duration': duration.toString(),
      'catagory': catagoryId,
    };
  }

  factory TaskInfo.fromJson(Map<String, dynamic> json) {
    return TaskInfo.withId(
      id: json['id'],
      completed: json['completed'],
      title: json['title'],
      description: json['description'],
      createdTime: DateTime.parse(json['createdTime']),
      duration: double.parse(json['duration']),
      catagoryId: json['catagory'],
    );
  }

  @override
  String toString() {
    return 'TaskInfo{id: $id, completed: $completed, title: $title, description: $description, createdTime: $createdTime, duration: $duration, catagory: $catagoryId}';
  }
}

typedef AddNewTaskCallback = void Function(TaskInfo newTaskInfo);
