import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/statistic.dart';

class DailyPerfomanceWidget extends StatefulWidget {
  List<DailyPerfomance> stat;

  DailyPerfomanceWidget(this.stat);

  @override
  _DailyPerfomanceWidgetState createState() => _DailyPerfomanceWidgetState();
}

class _DailyPerfomanceWidgetState extends State<DailyPerfomanceWidget> {
  bool isMainChart = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 300)).then((_) {
      setState(() {
        isMainChart = true;
      });
    });
  }

  BarChartData mainData() {
    return BarChartData(
      minY: 0,
      maxY: 100,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 14,
          ),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(enabled: false),
      alignment: BarChartAlignment.spaceBetween,
      barGroups: List.generate(
        widget.stat.length,
        (int i) => BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: widget.stat[i].y,
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF6C3CD1),
              width: 20,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                y: 100,
                color: Theme.of(context).disabledColor.withOpacity(0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartData animation() {
    return BarChartData(
      minY: 0,
      maxY: 100,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 14,
          ),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barTouchData: BarTouchData(
        enabled: false,
      ),
      alignment: BarChartAlignment.spaceBetween,
      barGroups: List.generate(
        7,
        (int i) => BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: 0,
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF6C3CD1),
              width: 20,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                y: 100,
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 150,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: AspectRatio(
        aspectRatio: 2.81,
        child: BarChart(
          isMainChart ? mainData() : animation(),
          swapAnimationDuration: Duration(milliseconds: 400),
        ),
      ),
    );
  }
}
