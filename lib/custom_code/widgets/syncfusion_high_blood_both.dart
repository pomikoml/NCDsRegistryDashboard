// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart';

class SyncfusionHighBloodBoth extends StatefulWidget {
  const SyncfusionHighBloodBoth({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<SyncfusionHighBloodBoth> createState() =>
      _SyncfusionHighBloodBothState();
}

class _SyncfusionHighBloodBothState extends State<SyncfusionHighBloodBoth> {
  late TooltipBehavior _tooltip;

  final List<ChartData> chartData = [
    ChartData('ค่าความดันสูงทั้งสองตัว', 3073, Color(0xFFC62828)), // Red
    ChartData(
        'ค่าความดันตัวล่างสูงอย่างเดียว', 986, Color(0xFFFFEB3B)), // Yellow
    ChartData(
        'ค่าความดันตัวบนสูงอย่างเดียว', 8643, Color(0xFFFF9800)), // Orange
  ];

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
      tooltipPosition: TooltipPosition.pointer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 300,
      child: SfCircularChart(
        tooltipBehavior: _tooltip,
        legend: const Legend(
          isVisible: false,
        ),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            pointColorMapper: (ChartData data, _) => data.color,
            dataLabelMapper: (ChartData data, _) =>
                '${data.x}\n${data.y.toStringAsFixed(0)}',
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
