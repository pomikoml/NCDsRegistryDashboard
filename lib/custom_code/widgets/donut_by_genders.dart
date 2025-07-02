// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // for number formatting

class DonutByGenders extends StatefulWidget {
  const DonutByGenders({
    super.key,
    this.width,
    this.height,
    this.male,
    this.female,
  });

  final double? width;
  final double? height;
  final int? male;
  final int? female;

  @override
  State<DonutByGenders> createState() => _DonutByGendersState();
}

class _DonutByGendersState extends State<DonutByGenders> {
  late List<_GenderChartData> data;
  late TooltipBehavior _tooltip;
  late int total;
  late NumberFormat numberFormat;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = [
      //widget.male ?? 0 //widget.female ?? 0
      _GenderChartData('ชาย', widget.male ?? 0, const Color(0xFF0079C5)), // Male
      _GenderChartData('หญิง', widget.female ?? 0, Colors.pink.shade400), // Female
    ];
    total = data.fold(0, (sum, item) => sum + item.amount);
    numberFormat = NumberFormat('#,###', 'en_US');

    _tooltip = TooltipBehavior(
      enable: true,
      tooltipPosition: TooltipPosition.pointer,
      format: null, // Use builder instead
      builder: (dynamic dataPoint, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        final value = point.y as int;
        final percent = (value / total * 100).toStringAsFixed(2);
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${point.x} : ${numberFormat.format(value)} คน\n($percent%)',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        );
      },
    );
    return Container(
      width: widget.width,
      height: widget.height,
      child: SfCircularChart(
        tooltipBehavior: _tooltip,
        legend: Legend(
          isVisible: true,
          position: LegendPosition.right,
          overflowMode: LegendItemOverflowMode.wrap,
          title: LegendTitle(
            text: 'สัดส่วนตามเพศ',
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12, // Smaller font size for legend title
            ),
          ),
        ),
        series: <CircularSeries<_GenderChartData, String>>[
          DoughnutSeries<_GenderChartData, String>(
            dataSource: data,
            xValueMapper: (_GenderChartData data, _) => data.gender,
            yValueMapper: (_GenderChartData data, _) => data.amount,
            pointColorMapper: (_GenderChartData data, _) => data.color,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
              useSeriesColor: false,
              builder: (dynamic dataPoint, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                final value = point.y as int;
                final percent = (value / total * 100).toStringAsFixed(2);
                return Text(
                  '${numberFormat.format(value)}\n($percent%)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            name: 'เพศ',
          ),
        ],
      ),
    );
  }
}

class _GenderChartData {
  final String gender;
  final int amount;
  final Color color;

  _GenderChartData(this.gender, this.amount, this.color);
}
