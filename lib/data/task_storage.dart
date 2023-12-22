import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'task_info.dart';

class TaskModelStorage {
  TaskModelStorage({required String accId}) : _accId = accId;

  final String _accId;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final fileName = '$path/task_model_$_accId.txt';
    return File(fileName);
  }

  Future<List<TaskInfo>> readTaskList() async {
    try {
      final file = await _localFile;
      final content = await file.readAsString();
      final taskListJson = jsonDecode(content) as List<dynamic>;

      // Convert the List<dynamic> to List<TaskInfo>
      final List<TaskInfo> taskList = taskListJson
          .map(
              (taskJson) => TaskInfo.fromJson(taskJson as Map<String, dynamic>))
          .toList();

      return taskList;
    } catch (e) {
      return [];
    }
  }

  Future<File> writeTaskList(List<TaskInfo> taskList) async {
    final file = await _localFile;
    final String taskListString = jsonEncode(taskList);
    return file.writeAsString(taskListString);
  }
}
