import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:daily_completion/base/logging.dart';
import 'package:daily_completion/data/task_info.dart';
import 'package:path_provider/path_provider.dart';

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
      Logger.info('TaskModelStorage readTaskList content: $content');
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
    Logger.info(
        'TaskModelStorage writeTaskList taskListString: $taskListString');
    return file.writeAsString(taskListString);
  }

  Future<File> clearTaskList() async {
    Logger.info('TaskModelStorage clearTaskList');
    final file = await _localFile;
    return file.writeAsString('');
  }
}
