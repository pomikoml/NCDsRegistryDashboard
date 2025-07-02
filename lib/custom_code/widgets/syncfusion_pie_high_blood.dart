// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart';

class SyncfusionPieHighBlood extends StatefulWidget {
  const SyncfusionPieHighBlood({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<SyncfusionPieHighBlood> createState() => _SyncfusionPieHighBloodState();
}

class _SyncfusionPieHighBloodState extends State<SyncfusionPieHighBlood> {
  late TooltipBehavior _tooltip;

  final List<ChartData> chartData = [
    ChartData('ความดันล่างสูง > 90', 2452, Color(0xFFD32F2F)),
    ChartData('ความดันล่างต่ำ < 60', 301, Color(0xFF7E57C2)),
    ChartData('ความดันล่างปกติ 60-90', 7617, Color(0xFFFFCDD2)),
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
