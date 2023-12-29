import 'package:daily_completion/base/datetime_utils.dart';
import 'package:daily_completion/base/logging.dart';
import 'package:daily_completion/data/task_info.dart';
import 'package:daily_completion/data/local_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum TimePeriodSelect {
  day,
  week,
  month,
  year,
  total,
}

typedef TimePeriodButtonCallback = void Function(TimePeriodSelect timePeriod);

class ChartTab extends StatefulWidget {
  const ChartTab({super.key});

  @override
  State<ChartTab> createState() => _ChartTabState();
}

class _ChartTabState extends State<ChartTab> {
  TimePeriodSelect _timePeriodSelect = TimePeriodSelect.total;
  TimePeriodButtonCallback _buttonCallback = (timePeriod) {};
  int _colorIndex = 0;
  Map<int, List<TaskInfo>> _taskMap = {};
  List<TaskCatagory> _catagoryList = [];

  @override
  void initState() {
    super.initState();
    _buttonCallback = (timePeriod) {
      setState(() {
        _timePeriodSelect = timePeriod;
      });
      _initializeTaskMap();
    };
  }

  // Helper function to initialize the task list asynchronously
  Future<void> _initializeTaskMap() async {
    _taskMap = await _getTaskMap();
    _catagoryList = await TaskCatagoryStorage.getInstance().readCatagoryList();
    setState(() {
      // Trigger a rebuild after setting the state
    });
  }

  Future<List<TaskInfo>> _readTaskList() async {
    return await TaskInfoStorage.getInstance().readTaskList();
  }

  Future<Map<int, List<TaskInfo>>> _getTaskMap() async {
    Function dateComparison = <bool>(DateTime dt1, DateTime dt2) => true;
    switch (_timePeriodSelect) {
      case TimePeriodSelect.day:
        dateComparison = DateTimeUtils.isSameDay;
        break;
      case TimePeriodSelect.week:
        dateComparison = DateTimeUtils.isSameWeek;
        break;
      case TimePeriodSelect.month:
        dateComparison = DateTimeUtils.isSameMonth;
        break;
      case TimePeriodSelect.year:
        dateComparison = DateTimeUtils.isSameYear;
        break;
      case TimePeriodSelect.total:
      default:
        break;
    }

    DateTime now = DateTime.now();
    List<TaskInfo> taskList = await _readTaskList();
    Map<int, List<TaskInfo>> taskMap = <int, List<TaskInfo>>{};

    for (var task in taskList) {
      if (!task.completed) {
        continue;
      }
      if (dateComparison(now, task.createdTime)) {
        int catagoryId = task.catagoryId;
        if (!taskMap.containsKey(catagoryId)) {
          taskMap[catagoryId] = [];
        }
        taskMap[catagoryId]!.add(task);
      }
    }

    // Convert Map to List then to Map, can get key of Map as axis x.
    List<List<TaskInfo>> tempTaskList = [];
    taskMap.forEach((key, value) {
      tempTaskList.add(value);
    });
    taskMap = tempTaskList.asMap();

    return taskMap;
  }

  TaskCatagory? _getTaskCatagoryById(int catagoryId) {
    for (TaskCatagory catagory in _catagoryList) {
      if (catagory.id == catagoryId) {
        return catagory;
      }
    }
    return null;
  }

  SideTitles _getBottomTiles(Map<int, List<TaskInfo>> taskMap) {
    List<TaskCatagory> catagoryList = [];

    taskMap.forEach((int key, List<TaskInfo> value) {
      if (value.isNotEmpty) {
        TaskCatagory? catagory = _getTaskCatagoryById(value[0].catagoryId);
        if (catagory != null) {
          catagoryList.add(catagory);
        }
      }
    });

    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
        int valIdx = value.toInt();
        if (taskMap.containsKey(valIdx) && taskMap[valIdx]!.isNotEmpty) {
          TaskCatagory? catagory =
              _getTaskCatagoryById(taskMap[valIdx]![0].catagoryId);
          text = catagory == null ? '' : catagory.description;
        } else {
          Logger.error(
              'chart_tab _getBottomTiles valIdx: $valIdx is out of range.');
        }
        return Text(
          text,
          style: const TextStyle(fontSize: 10),
        );
      },
    );
  }

  Color _getNextColor() {
    List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
    ];
    int colorIndex = _colorIndex % colors.length;
    _colorIndex++;
    return colors[colorIndex];
  }

  List<BarChartGroupData> _getBarChartGroupData(
      Map<int, List<TaskInfo>> taskMap) {
    List<BarChartGroupData> groupDataList = [];
    taskMap.forEach((int axisX, List<TaskInfo> taskList) {
      List<BarChartRodData> rodDataList = [];
      double posY = 0;
      for (TaskInfo task in taskList) {
        Color color = _getNextColor();
        rodDataList.add(BarChartRodData(
          fromY: posY,
          toY: posY + task.duration,
          color: color,
        ));
        posY = posY + task.duration;
      }
      groupDataList.add(BarChartGroupData(
        x: axisX,
        groupVertically: true,
        barRods: rodDataList,
      ));
    });

    return groupDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimePeriodSelection(onTimePeriodSelected: _buttonCallback),
        const SizedBox(
          height: 16.0,
        ),
        BarChartView(
          groupData: _getBarChartGroupData(_taskMap),
          bottomTile: _getBottomTiles(_taskMap),
        ),
      ],
    );
  }
}

class TimePeriodSelection extends StatelessWidget {
  const TimePeriodSelection({
    super.key,
    required this.onTimePeriodSelected,
  });

  final TimePeriodButtonCallback onTimePeriodSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          SelectTimePeriodButton(
            onTimePeriodSelected: onTimePeriodSelected,
            selectType: TimePeriodSelect.day,
            buttonText: 'Today',
          ),
          SelectTimePeriodButton(
            onTimePeriodSelected: onTimePeriodSelected,
            selectType: TimePeriodSelect.week,
            buttonText: 'Week',
          ),
          SelectTimePeriodButton(
            onTimePeriodSelected: onTimePeriodSelected,
            selectType: TimePeriodSelect.month,
            buttonText: 'Month',
          ),
          SelectTimePeriodButton(
            onTimePeriodSelected: onTimePeriodSelected,
            selectType: TimePeriodSelect.year,
            buttonText: 'Year',
          ),
          SelectTimePeriodButton(
            onTimePeriodSelected: onTimePeriodSelected,
            selectType: TimePeriodSelect.total,
            buttonText: 'Total',
          ),
        ],
      ),
    );
  }
}

class SelectTimePeriodButton extends StatelessWidget {
  const SelectTimePeriodButton({
    super.key,
    required this.onTimePeriodSelected,
    required this.selectType,
    required this.buttonText,
  });

  final TimePeriodButtonCallback onTimePeriodSelected;
  final TimePeriodSelect selectType;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          onTimePeriodSelected(selectType);
        },
        child: Text(buttonText),
      ),
    );
  }
}

class BarChartView extends StatelessWidget {
  const BarChartView({
    super.key,
    required this.groupData,
    required this.bottomTile,
  });

  final List<BarChartGroupData> groupData;
  final SideTitles bottomTile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          barGroups: groupData,
          borderData: FlBorderData(
            border: const Border(
              bottom: BorderSide(),
              left: BorderSide(),
            ),
          ),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: bottomTile,
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    );
  }
}
