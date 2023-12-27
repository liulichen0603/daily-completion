import 'package:flutter/material.dart';

import 'package:daily_completion/data/task_storage.dart';
import 'package:daily_completion/ui/chart_tab.dart';
import 'package:daily_completion/ui/settings_tab.dart';
import 'package:daily_completion/ui/task_tab.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _titleOptions = <Widget>[
    Text(
      'Task',
      style: optionStyle,
    ),
    Text(
      'Chart',
      style: optionStyle,
    ),
    Text(
      'Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: support multiple account
    TaskModelStorage taskModelStorage = TaskModelStorage(accId: '1');
    List<Widget> widgetOptions = <Widget>[
      TaskTab(taskModelStorage: taskModelStorage),
      ChartTab(taskModelStorage: taskModelStorage),
      SettingsTab(taskModelStorage: taskModelStorage),
    ];

    return Scaffold(
      appBar: AppBar(
        title: _titleOptions.elementAt(_selectedIndex),
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Chart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
