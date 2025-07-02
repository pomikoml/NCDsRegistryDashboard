import 'dart:math';

import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // for number formatting

class HighBloodPressureByAges extends StatefulWidget {
  const HighBloodPressureByAges({
    super.key,
    this.width,
    this.height,
    this.a1,
    this.a2,
    this.a3,
    this.a4,
    this.a5,
  });

  final double? width;
  final double? height;
  final double? a1;
  final double? a2;
  final double? a3;
  final double? a4;
  final double? a5;

  @override
  State<HighBloodPressureByAges> createState() => _HighBloodPressureByAgesState();
}

class _HighBloodPressureByAgesState extends State<HighBloodPressureByAges> {
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _chartData;
  // late Double fmax;

  @override
  void initState() {
    super.initState();

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
      format: 'point.x: point.y',
    );
  }

  @override
  Widget build(BuildContext context) {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'อายุ 0-4 ปี', y: widget.a1 ?? 0),
      ChartSampleData(x: 'อายุ 5-11 ปี', y: widget.a2 ?? 0),
      ChartSampleData(x: 'อายุ 12-17 ปี', y: widget.a3 ?? 0),
      ChartSampleData(x: 'อายุ 18-59 ปี', y: widget.a4 ?? 0),
      ChartSampleData(x: 'อายุ 60 ปีขึ้นไป', y: widget.a5 ?? 0),
    ];
    // fmax = widget.a1 + widget.a2 + widget.a3 + widget.a4 + widget.a5;
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: _buildCartesianChart(),
    );
  }

  // SfCartesianChart _buildCartesianChart() {
  //   return SfCartesianChart(
  //     title: ChartTitle(
  //       textStyle: const TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     plotAreaBorderWidth: 0,
  //     primaryXAxis: CategoryAxis(
  //       labelRotation: 45,
  //       majorGridLines: const MajorGridLines(width: 0),
  //     ),
  //     primaryYAxis: NumericAxis(
  //       minimum: 0,
  //       maximum: 100000,
  //       interval: 5000,
  //       numberFormat: NumberFormat.decimalPattern('en_US'),
  //       axisLine: const AxisLine(width: 0),
  //       majorTickLines: const MajorTickLines(size: 0),
  //       labelStyle: const TextStyle(fontSize: 12),
  //     ),
  //     tooltipBehavior: _tooltipBehavior,
  //     series: <CartesianSeries<ChartSampleData, String>>[
  //       ColumnSeries<ChartSampleData, String>(
  //         dataSource: _chartData,
  //         xValueMapper: (ChartSampleData data, _) => data.x,
  //         yValueMapper: (ChartSampleData data, _) => data.y,
  //         dataLabelSettings: const DataLabelSettings(
  //           isVisible: true,
  //           textStyle: TextStyle(fontSize: 14),
  //         ),
  //         color: Color(0xFFFF8A80),
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //     ],
  //   );
  // }

  double roundUpToNiceNumber(double value) {
    if (value <= 0) return 10;
    final exponent = (log(value) / log(10)).floor();
    final base = pow(10, exponent).toDouble();
    return ((value / base).ceil()) * base;
  }

  SfCartesianChart _buildCartesianChart() {
    // คำนวณ max y จากข้อมูลจริง
    // final double maxY = _chartData.map((d) => d.y).reduce(max);
    // final double suggestedMaxY = (maxY * 1.2).ceilToDouble(); // เพิ่ม buffer 20%
    // final double suggestedInterval = (suggestedMaxY / 5).ceilToDouble();
    final double maxY = _chartData.map((d) => d.y).reduce(max);
    final double suggestedMaxY = roundUpToNiceNumber(maxY); // ✅ ปรับให้กลม
    final double suggestedInterval = (suggestedMaxY / 5).ceilToDouble(); // แบ่งเป็น 5 ช่อง

    return SfCartesianChart(
      title: ChartTitle(
        text: 'จำนวนประชากรตามช่วงอายุ',
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelRotation: 45,
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: const TextStyle(fontSize: 13),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: suggestedMaxY == 0 ? 100 : suggestedMaxY,
        interval: suggestedInterval == 0 ? 20 : suggestedInterval,
        numberFormat: NumberFormat.decimalPattern('en_US'),
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        labelStyle: const TextStyle(fontSize: 13),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        format: 'point.x: point.y คน',
        canShowMarker: false,
        textStyle: const TextStyle(fontSize: 13),
      ),
      series: <CartesianSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          dataSource: _chartData,
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.y,
          width: _chartData.length == 1 ? 0.3 : 0.7, // ปรับขนาดแท่งถ้ามีอันเดียว
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          color: const Color(0xFFFF8A80),
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ChartSampleData {
  final String x;
  final double y;

  ChartSampleData({
    required this.x,
    required this.y,
  });
}
