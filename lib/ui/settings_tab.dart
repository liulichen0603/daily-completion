import 'package:flutter/material.dart';

import 'package:daily_completion/data/local_storage.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                LocalStorage.getInstance().clearAll();
              },
              child: const Text('Clear All'),
            ),
            ElevatedButton(
              onPressed: () {
                TaskInfoStorage.getInstance().clearTaskList();
              },
              child: const Text('Clear Task Storage'),
            ),
            ElevatedButton(
              onPressed: () {
                TaskCatagoryStorage.getInstance().clearCatagoryList();
              },
              child: const Text('Clear Catagory Storage'),
            ),
          ],
        ),
      ),
    );
  }
}
