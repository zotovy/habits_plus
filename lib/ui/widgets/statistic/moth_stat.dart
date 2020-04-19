import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/statistic.dart';

class MonthStatWidget extends StatefulWidget {
  List<FlSpot> stat;

  MonthStatWidget(this.stat);

  @override
  _MonthStatWidgetState createState() => _MonthStatWidgetState();
}

class _MonthStatWidgetState extends State<MonthStatWidget> {
  bool isMainAnimation = false;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300)).then((_) {
      setState(() {
        isMainAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: LineChart(
          isMainAnimation ? mainChart() : startChart(),
          swapAnimationDuration: Duration(milliseconds: 300),
        ),
      ),
    );
  }

  LineChartData mainChart() {
    return LineChartData(
      backgroundColor: Theme.of(context).backgroundColor,
      minX: 0,
      maxX: 30,
      minY: 0,
      maxY: 100,
      gridData: FlGridData(
        show: true,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Theme.of(context).disabledColor,
          strokeWidth: 0.5,
          dashArray: [
            10,
          ],
        ),
      ),
      showingTooltipIndicators: [
        ShowingTooltipIndicators(0, [
          LineBarSpot(
            LineChartBarData(),
            1,
            FlSpot(5, 10),
          ),
        ]),
      ],
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 5:
                return '5';
              case 10:
                return '10';
              case 15:
                return '15';
              case 20:
                return '20';
              case 25:
                return '25';
              case 30:
                return '30';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0%';
              case 20:
                return '20%';
              case 40:
                return '40%';
              case 60:
                return '60%';
              case 80:
                return '80%';
              case 100:
                return '100%';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).textSelectionColor,
            width: 1,
          ),
          left: BorderSide(
            color: Theme.of(context).textSelectionColor,
            width: 1,
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: widget.stat.length == 0
              ? [
                  FlSpot(0, 0),
                  FlSpot(5, 0),
                  FlSpot(10, 0),
                  FlSpot(15, 0),
                  FlSpot(20, 0),
                  FlSpot(25, 0),
                  FlSpot(30, 0),
                ]
              : widget.stat,
          isCurved: true,
          colors: [
            Theme.of(context).primaryColor,
          ],
          preventCurveOverShooting: false,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotColor:
                (FlSpot spot, double _double, LineChartBarData barData) =>
                    Theme.of(context).backgroundColor,
            getStrokeColor:
                (FlSpot spot, double _double, LineChartBarData barData) =>
                    Theme.of(context).primaryColor,
            strokeWidth: 2,
            dotSize: 3,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.15),
            ],
          ),
        ),
      ],
    );
  }

  LineChartData startChart() {
    return LineChartData(
      backgroundColor: Theme.of(context).backgroundColor,
      minX: 0,
      maxX: 30,
      minY: 0,
      maxY: 100,
      gridData: FlGridData(
        show: true,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Theme.of(context).disabledColor,
            strokeWidth: 0.5,
            dashArray: [
              10,
            ],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 5:
                return '5';
              case 10:
                return '10';
              case 15:
                return '15';
              case 20:
                return '20';
              case 25:
                return '25';
              case 30:
                return '30';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0%';
              case 20:
                return '20%';
              case 40:
                return '40%';
              case 60:
                return '60%';
              case 80:
                return '80%';
              case 100:
                return '100%';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).textSelectionColor,
            width: 1,
          ),
          left: BorderSide(
            color: Theme.of(context).textSelectionColor,
            width: 1,
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 0),
            FlSpot(5, 0),
            FlSpot(10, 0),
            FlSpot(15, 0),
            FlSpot(20, 0),
            FlSpot(25, 0),
            FlSpot(30, 0),
          ],
          isCurved: true,
          colors: [
            Theme.of(context).primaryColor,
          ],
          preventCurveOverShooting: false,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotColor:
                (FlSpot spot, double _double, LineChartBarData barData) =>
                    Theme.of(context).backgroundColor,
            getStrokeColor:
                (FlSpot spot, double _double, LineChartBarData barData) =>
                    Theme.of(context).primaryColor,
            strokeWidth: 2,
            dotSize: 3,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.15),
            ],
          ),
        ),
      ],
    );
  }
}
