// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // ใช้สำหรับฟอร์แมตตัวเลข

class BloodSummary extends StatefulWidget {
  const BloodSummary({
    super.key,
    this.width,
    this.height,
    this.c1,
    this.c2,
    this.c3,
    this.c4,
    this.c5,
    this.c6,
    this.c7,
    this.c8,
    this.c9,
    this.c10,
    this.c11,
    this.c12,
    this.c13,
  });

  final double? width;
  final double? height;
  final int? c1;
  final int? c2;
  final int? c3;
  final int? c4;
  final int? c5;
  final int? c6;
  final int? c7;
  final int? c8;
  final int? c9;
  final int? c10;
  final int? c11;
  final int? c12;
  final int? c13;

  @override
  State<BloodSummary> createState() => _BloodSummaryState();
}

class _BloodSummaryState extends State<BloodSummary> {
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _chartData;
  final NumberFormat numberFormat = NumberFormat('#,###');
  // int c13 = 0;
  @override
  void initState() {
    super.initState();
    // c13 = widget.c13 ?? 0;

    _tooltipBehavior = TooltipBehavior(enable: true, header: '', canShowMarker: false);
  }

  @override
  Widget build(BuildContext context) {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'เขตสุขภาพที่ 1', y: widget.c1 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 2', y: widget.c2 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 3', y: widget.c3 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 4', y: widget.c4 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 5', y: widget.c5 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 6', y: widget.c6 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 7', y: widget.c7 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 8', y: widget.c8 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 9', y: widget.c9 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 10', y: widget.c10 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 11', y: widget.c11 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 12', y: widget.c12 ?? 0),
      ChartSampleData(x: 'เขตสุขภาพที่ 13', y: widget.c13 ?? 0),
    ];
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: _buildCartesianChart(),
    );
  }

  int _getMaxY() {
    final values = _chartData.map((e) => e.y).toList();
    final max = values.isEmpty ? 1000 : values.reduce((a, b) => a > b ? a : b);
    return ((max + 4999) ~/ 5000) * 5000;
  }

  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelRotation: 45, // หมุนข้อความในแกน X ให้เอียง
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        // maximum: 30000,
        maximum: _getMaxY().toDouble(),
        interval: 5000,
        axisLine: const AxisLine(width: 0),
        labelFormat: '{value}',
        numberFormat: numberFormat, // ฟอร์แมตให้มี comma
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          labelAlignment: ChartDataLabelAlignment.outer,
          builder: (data, _, __, ___, ____) {
            return Text(numberFormat.format((data as ChartSampleData).y));
          },
        ),
        color: const Color.fromARGB(255, 27, 136, 224),
        borderRadius: const BorderRadius.all(Radius.circular(8)), // โค้ง 8 px บนล่าง
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ChartSampleData {
  final String x;
  final int y;

  ChartSampleData({
    required this.x,
    required this.y,
  });
}
