import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  String day;
  int value;

  ChartData(
    this.day,
    this.value,
  );
}

class MonthChartStats extends StatefulWidget {
  Map monthStat;

  MonthChartStats({
    @required this.monthStat,
  });

  @override
  _MonthChartStatsState createState() => _MonthChartStatsState();
}

class _MonthChartStatsState extends State<MonthChartStats> {
  List<ChartData> getData() {
    return List.generate(widget.monthStat['chart'].length, (int i) {
      return ChartData((i * 5 + 5).toString(), widget.monthStat['chart'][i]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
      child: SfCartesianChart(
        backgroundColor: Theme.of(context).backgroundColor,
        tooltipBehavior: TooltipBehavior(enable: true),
        // Initialize category axis
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries<ChartData, String>>[
          SplineSeries<ChartData, String>(
            width: 5,
            animationDuration: 3000,
            splineType: SplineType.natural,
            color: Theme.of(context).primaryColor,
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Color(0xFF8d68dd),
            ]),
            // Bind data source
            dataSource: getData(),
            xValueMapper: (ChartData data, _) => data.day,
            yValueMapper: (ChartData data, _) => data.value,
          )
        ],
      ),
    );
  }
}
