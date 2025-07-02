// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart';

class SyncfusionScatter extends StatefulWidget {
  const SyncfusionScatter({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<SyncfusionScatter> createState() => _SyncfusionScatterState();
}

class _SyncfusionScatterState extends State<SyncfusionScatter> {
  late TooltipBehavior _tooltipBehavior;

  // Separate data for each group
  final List<ChartSampleData> highBoth = [
    ChartSampleData(x: 165, y: 70),
    ChartSampleData(x: 160, y: 65),
    ChartSampleData(x: 170, y: 73),
  ];

  final List<ChartSampleData> highLowerOnly = [
    ChartSampleData(x: 155, y: 45),
    ChartSampleData(x: 160, y: 47),
  ];

  final List<ChartSampleData> highUpperOnly = [
    ChartSampleData(x: 175, y: 60),
    ChartSampleData(x: 180, y: 62),
    ChartSampleData(x: 185, y: 64),
  ];

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 300,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(
          title: AxisTitle(text: 'Height (CM)'),
          minimum: 0,
          maximum: 220,
          interval: 20,
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'Weight (KG)'),
          minimum: 0,
          maximum: 80,
          interval: 20,
          labelFormat: '{value} KG',
          axisLine: const AxisLine(width: 0),
        ),
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.top,
        ),
        tooltipBehavior: _tooltipBehavior,
        series: <ScatterSeries<ChartSampleData, num>>[
          ScatterSeries<ChartSampleData, num>(
            name: 'ค่าความดันสูงทั้งสองตัว',
            dataSource: highBoth,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.y,
            color: Color(0xFFC62828), // Red
            markerSettings: const MarkerSettings(height: 8, width: 8),
            opacity: 1.0,
          ),
          ScatterSeries<ChartSampleData, num>(
            name: 'ค่าความดันตัวล่างสูงอย่างเดียว',
            dataSource: highLowerOnly,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.y,
            color: Color(0xFFFFEB3B), // Yellow
            markerSettings: const MarkerSettings(height: 8, width: 8),
            opacity: 1.0,
          ),
          ScatterSeries<ChartSampleData, num>(
            name: 'ค่าความดันตัวบนสูงอย่างเดียว',
            dataSource: highUpperOnly,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.y,
            color: Color(0xFFFF9800), // Orange
            markerSettings: const MarkerSettings(height: 8, width: 8),
            opacity: 1.0,
          ),
        ],
      ),
    );
  }
}

class ChartSampleData {
  final double x;
  final double y;

  ChartSampleData({
    required this.x,
    required this.y,
  });
}
