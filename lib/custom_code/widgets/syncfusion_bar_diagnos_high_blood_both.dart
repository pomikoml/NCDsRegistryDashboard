// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion chart package

class SyncfusionBarDiagnosHighBloodBoth extends StatefulWidget {
  const SyncfusionBarDiagnosHighBloodBoth({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<SyncfusionBarDiagnosHighBloodBoth> createState() =>
      _SyncfusionBarDiagnosHighBloodBothState();
}

class _SyncfusionBarDiagnosHighBloodBothState
    extends State<SyncfusionBarDiagnosHighBloodBoth> {
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    super.initState();
    // Initialize chart data
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'จำนวนโรค 1', y: 18506),
      ChartSampleData(x: 'จำนวนโรค 2', y: 14793),
      ChartSampleData(x: 'จำนวนโรค 3', y: 4597),
      ChartSampleData(x: 'จำนวนโรค 4', y: 648),
      ChartSampleData(x: 'จำนวนโรค 5', y: 47),
      ChartSampleData(x: 'จำนวนโรค 6', y: 4),
    ];
    // Tooltip settings
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: _buildCartesianChart(),
    );
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 16000,
        interval: 5000,
        axisLine: const AxisLine(width: 0),
        labelFormat: '{value}',
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 10),
        ),
        color: const Color(0xFFAB98BF), // Set the bar color as requested
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the chart data
    _chartData.clear();
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
