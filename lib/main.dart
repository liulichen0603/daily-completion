import 'package:flutter/material.dart';

import 'chart_tab.dart';
import 'settings_tab.dart';
import 'task_tab.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
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

  static final List<Widget> _widgetOptions = <Widget>[
    TaskTab(
        taskList: List.generate(
      100,
      (index) => TaskInfo(
        id: index + 1,
        completed: false,
        title: 'Task ${index + 1}',
        description: 'Description for Task ${index + 1}',
      ),
    )),
    ChartTab(),
    SettingsTab(),
  ];

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
    final List<TaskInfo> taskListForTest = List.generate(
      5,
      (index) => TaskInfo(
        id: index + 1,
        completed: false,
        title: 'Task ${index + 1}',
        description: 'Description for Task ${index + 1}',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: _titleOptions.elementAt(_selectedIndex),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
