import 'package:flutter/material.dart';

import 'package:daily_completion/data/task_storage.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key, required this.taskModelStorage});

  final TaskModelStorage taskModelStorage;

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            widget.taskModelStorage.clearTaskList();
          },
          child: const Text('Clear Task Storage'),
        ),
      ),
    );
  }
}
