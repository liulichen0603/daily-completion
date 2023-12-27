import 'package:daily_completion/base/datetime_utils.dart';
import 'package:daily_completion/data/task_info.dart';
import 'package:daily_completion/data/task_storage.dart';
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
  const ChartTab({super.key, required this.taskModelStorage});

  final TaskModelStorage taskModelStorage;

  @override
  State<ChartTab> createState() => _ChartTabState();
}

class _ChartTabState extends State<ChartTab> {
  TimePeriodSelect _timePeriodSelect = TimePeriodSelect.total;
  TimePeriodButtonCallback _buttonCallback = (timePeriod) {};

  @override
  void initState() {
    super.initState();
    _buttonCallback = (timePeriod) {
      setState(() {
        _timePeriodSelect = timePeriod;
      });
    };
  }

  Future<List<TaskInfo>> _readTaskList() async {
    return await widget.taskModelStorage.readTaskList();
  }

  Future<Map<int, List<TaskInfo>>> _getGroupData() async {
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
    Map<int, List<TaskInfo>> groupData = {};

    for (var task in taskList) {
      if (dateComparison(now, task.createdTime)) {
        int catagoryId = task.catagory.id;
        if (!groupData.containsKey(catagoryId)) {
          groupData[catagoryId] = [];
        }
        groupData[catagoryId]!.add(task);
      }
    }

    return groupData;
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
        const BarChartView(),
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              groupVertically: true,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 5,
                  color: Colors.blue,
                ),
                BarChartRodData(
                  fromY: 5,
                  toY: 30,
                  color: Colors.red,
                ),
                BarChartRodData(
                  fromY: 30,
                  toY: 100,
                  color: Colors.green,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 25,
                  color: Colors.green,
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 100,
                  color: Colors.orange,
                ),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  toY: 75,
                  color: Colors.red,
                ),
              ],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                  toY: 120,
                  color: Colors.red,
                ),
              ],
            ),
            BarChartGroupData(
              x: 5,
              barRods: [
                BarChartRodData(
                  toY: 30,
                  color: Colors.red,
                ),
              ],
            ),
            BarChartGroupData(
              x: 6,
              barRods: [
                BarChartRodData(
                  toY: 50,
                  color: Colors.red,
                ),
              ],
            ),
          ],
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
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                String text = '';
                switch (value.toInt()) {
                  case 0:
                    text = 'Mon';
                    break;
                  case 1:
                    text = 'Tue';
                    break;
                  case 2:
                    text = 'Wed';
                    break;
                  case 3:
                    text = 'Thu';
                    break;
                  case 4:
                    text = 'Fri';
                    break;
                  case 5:
                    text = 'Sat';
                    break;
                  case 6:
                    text = 'Sun';
                    break;
                }

                return Text(
                  text,
                  style: const TextStyle(fontSize: 10),
                );
              },
            )),
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
