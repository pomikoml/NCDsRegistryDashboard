// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion chart package

class SyncfusionStackedBarByGender extends StatefulWidget {
  const SyncfusionStackedBarByGender({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<SyncfusionStackedBarByGender> createState() =>
      _SyncfusionStackedBarByGenderState();
}

class _SyncfusionStackedBarByGenderState
    extends State<SyncfusionStackedBarByGender> {
  late List<_ChartData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: '{point.y}', // Only show the value (y value) without the label
      canShowMarker: false, // Hides the marker icon from the tooltip
      header: '', // Empty header to prevent default behavior
    );
    _chartData = <_ChartData>[
      _ChartData('Gender', 3358805, 3325080),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ??
          double.infinity, // Stretch width to fill available space
      height: widget.height ??
          double.infinity, // Stretch height to fill available space
      padding: EdgeInsets.zero, // Remove any internal padding of the container
      alignment: Alignment.center, // Center the chart within the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0, // Remove plot area border width
        margin: EdgeInsets.zero, // Remove margin from the chart
        primaryXAxis: CategoryAxis(
          isVisible: false,
          majorGridLines:
              const MajorGridLines(width: 0), // Hide grid lines for the X-axis
          axisLine: const AxisLine(width: 0), // Hide axis line for the X-axis
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
          majorGridLines:
              const MajorGridLines(width: 0), // Hide grid lines for the Y-axis
          axisLine: const AxisLine(width: 0), // Hide axis line for the Y-axis
        ),
        tooltipBehavior: _tooltipBehavior,
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.bottom,
        ),
        series: <CartesianSeries>[
          StackedBarSeries<_ChartData, String>(
            dataSource: _chartData,
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.male,
            pointColorMapper: (_, __) =>
                const Color(0xFF4285F4), // Blue for Male
            name:
                'Male', // Tooltip will display "Male" when hovering over this series
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold, // Set font weight to bold
              ),
              labelPosition: ChartDataLabelPosition.inside, // Inside the bar
            ),
          ),
          StackedBarSeries<_ChartData, String>(
            dataSource: _chartData,
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.female,
            pointColorMapper: (_, __) =>
                const Color(0xFFE9A9C7), // Pink for Female
            name:
                'Female', // Tooltip will display "Female" when hovering over this series
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold, // Set font weight to bold
              ),
              labelPosition: ChartDataLabelPosition.inside, // Inside the bar
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.male, this.female);
  final String x;
  final num male;
  final num female;
}
