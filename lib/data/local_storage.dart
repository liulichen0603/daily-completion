import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:daily_completion/base/logging.dart';
import 'package:daily_completion/data/task_info.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  static LocalStorage? _instance;

  LocalStorage._();

  factory LocalStorage.getInstance() {
    _instance ??= LocalStorage._();
    return _instance!;
  }

  Future<Directory> get _localDocPath async {
    final Directory directory = await getApplicationDocumentsDirectory();

    return directory;
  }

  void clearFolder(Directory dir) {
    dir.listSync().forEach((FileSystemEntity entity) {
      if (entity is File) {
        entity.deleteSync();
      } else if (entity is Directory) {
        clearFolder(entity);
        entity.deleteSync();
      }
    });
  }

  Future<void> clearAll() async {
    Logger.info('LocalStorage clearAll');
    clearFolder(await _localDocPath);
  }
}

class TaskInfoStorage {
  static TaskInfoStorage? _instance;

  late String _accId;

  TaskInfoStorage._();

  factory TaskInfoStorage.getInstance() {
    _instance ??= TaskInfoStorage._();
    return _instance!;
  }

  void initialize(String id) {
    _accId = id;
  }

  Future<Directory> get _localDocPath async {
    final Directory directory = await getApplicationDocumentsDirectory();

    return directory;
  }

  Future<File> get _localTaskFile async {
    final path = (await _localDocPath).path;
    final fileName = '$path/task_info_$_accId.txt';
    return File(fileName);
  }

  Future<List<TaskInfo>> readTaskList() async {
    try {
      final file = await _localTaskFile;
      final content = await file.readAsString();
      Logger.info('TaskInfoStorage readTaskList content: $content');
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

  Future<void> writeTaskList(List<TaskInfo> taskList) async {
    final file = await _localTaskFile;
    final String taskListString = jsonEncode(taskList);
    Logger.info(
        'TaskInfoStorage writeTaskList taskListString: $taskListString');
    file.writeAsStringSync(taskListString);
  }

  Future<void> clearTaskList() async {
    Logger.info('TaskInfoStorage clearTaskList');
    final file = await _localTaskFile;
    file.writeAsStringSync('');
  }
}

class TaskCatagoryStorage {
  static TaskCatagoryStorage? _instance;

  late String _accId;

  TaskCatagoryStorage._();

  factory TaskCatagoryStorage.getInstance() {
    _instance ??= TaskCatagoryStorage._();
    return _instance!;
  }

  void initialize(String id) {
    _accId = id;
  }

  Future<Directory> get _localDocPath async {
    final Directory directory = await getApplicationDocumentsDirectory();

    return directory;
  }

  Future<File> get _localCatagoryFile async {
    final path = (await _localDocPath).path;
    final fileName = '$path/task_catagory_$_accId.txt';
    return File(fileName);
  }

  Future<List<TaskCatagory>> readCatagoryList() async {
    try {
      final file = await _localCatagoryFile;
      final content = await file.readAsString();
      Logger.info('TaskCatagoryStorage readCatagoryList content: $content');
      final catagoryListJson = jsonDecode(content) as List<dynamic>;

      // Convert the List<dynamic> to List<TaskCatagory>
      final List<TaskCatagory> catagoryList = catagoryListJson
          .map((catagoryJson) =>
              TaskCatagory.fromJson(catagoryJson as Map<String, dynamic>))
          .toList();

      return catagoryList;
    } catch (e) {
      return [];
    }
  }

  Future<void> writeCatagoryList(List<TaskCatagory> catagoryList) async {
    final file = await _localCatagoryFile;
    final String catagoryListString = jsonEncode(catagoryList);
    Logger.info(
        'TaskCatagoryStorage writeCatagoryList catagoryListString: $catagoryListString');
    file.writeAsStringSync(catagoryListString);
  }

  Future<void> clearCatagoryList() async {
    Logger.info('TaskCatagoryStorage clearCatagoryList');
    final file = await _localCatagoryFile;
    file.writeAsStringSync('');
  }
}
