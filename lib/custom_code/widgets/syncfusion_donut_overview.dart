// Automatic FlutterFlow imports
// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion chart package
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class SyncfusionDonutOverview extends StatefulWidget {
  const SyncfusionDonutOverview({
    super.key,
    this.width,
    this.height,
    this.cancerPercent,
    this.EmphysemaPercent,
    this.CholesterolPercent,
    this.HeartPercent,
    this.StrokePercent,
    this.KidneyPercent,
    this.ObesityPercent,
    this.DiabetesPercent,
    this.HypertensionPercent,
  });

  final double? width;
  final double? height;
  final double? cancerPercent; //006
  final double? EmphysemaPercent; //008
  final double? CholesterolPercent; //014
  final double? StrokePercent; //005
  final double? HeartPercent; //005/2
  final double? KidneyPercent; //009
  final double? ObesityPercent; //027
  final double? DiabetesPercent; //001
  final double? HypertensionPercent; //002

  @override
  State<SyncfusionDonutOverview> createState() => _SyncfusionDonutOverviewState();
}

class _SyncfusionDonutOverviewState extends State<SyncfusionDonutOverview> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Replace the old data with the new data structure
    // data = [
    //   _ChartData('มะเร็งทุกชนิด', widget.cancerPercent ?? 0), //15.33
    //   _ChartData('เบาหวาน', widget.DiabetesPercent ?? 0), //18.95
    //   _ChartData('โรคอ้วนลงพุง', widget.ObesityPercent ?? 0), //8.53
    //   _ChartData('ความดันโลหิตสูง', widget.HypertensionPercent ?? 0), //29.83
    //   _ChartData('หลอดเลือดหัวใจ', widget.HeartStrokePercent ?? 0), //6.13
    //   _ChartData('หลอดเลือดสมอง', widget.HeartStrokePercent ?? 0), //7.13
    //   _ChartData('COPD', widget.EmphysemaPercent ?? 0), //3.71
    //   _ChartData('ไตวาย', widget.KidneyPercent ?? 0), //10.38
    // ];
    _tooltip = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y%', // Tooltip format
      tooltipPosition: TooltipPosition.pointer,
    );
  }

  final Color grayColor = Color.fromRGBO(200, 200, 200, 1);

  final Map<String, Color> diseaseColorMap = {
    'มะเร็งทุกชนิด': Colors.red,
    'เบาหวาน': Colors.orange,
    'โรคอ้วนลงพุง': Colors.pink,
    'ความดันโลหิตสูง': Colors.green,
    'โรคหัวใจ': Colors.indigo,
    'โรคหลอดเลือดสมอง': Colors.blue,
    'COPD': Colors.cyan,
    'ไตวาย': Colors.brown,
    'ไขมันในเลือดสูง': Colors.deepPurple,
  };

  @override
  Widget build(BuildContext context) {
    // final data = [
    //   _ChartData('มะเร็งทุกชนิด', widget.cancerPercent ?? 0),
    //   _ChartData('เบาหวาน', widget.DiabetesPercent ?? 0),
    //   _ChartData('โรคอ้วนลงพุง', widget.ObesityPercent ?? 0),
    //   _ChartData('ความดันโลหิตสูง', widget.HypertensionPercent ?? 0),
    //   _ChartData('โรคหัวใจ', widget.HeartPercent ?? 0),
    //   _ChartData('โรคหลอดเลือดสมอง', widget.StrokePercent ?? 0),
    //   _ChartData('COPD', widget.EmphysemaPercent ?? 0),
    //   _ChartData('ไตวาย', widget.KidneyPercent ?? 0),
    //   _ChartData('ไขมันในเลือดสูง', widget.CholesterolPercent ?? 0),
    // ];

    final fullData = <_ChartData>[
      _ChartData('โรคเบาหวาน', widget.DiabetesPercent ?? 0),
      _ChartData('โรคอ้วน', widget.ObesityPercent ?? 0),
      _ChartData('โรคความดันโลหิตสูง', widget.HypertensionPercent ?? 0),
      _ChartData('โรคหัวใจ', widget.HeartPercent ?? 0),
      _ChartData('โรคหลอดเลือดสมอง', widget.StrokePercent ?? 0),
      _ChartData('โรคถุงลมโป่งพอง', widget.EmphysemaPercent ?? 0),
      _ChartData('โรคไตวายเรื้อรัง', widget.KidneyPercent ?? 0),
      _ChartData('โรคไขมันในเลือดสูง', widget.CholesterolPercent ?? 0),
      _ChartData('บุหรี่ไฟฟ้า', 0),
    ];

    // final dataNonZero = fullData.where((d) => d.y > 0).toList();

    // final dataNonZero = fullData.where((d) => d.y > 0).toList();
    // final dataZero = fullData.where((d) => d.y == 0).toList();

    return Container(
      width: widget.width,
      height: widget.height,
      child: Scrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: SizedBox(
            width: (widget.width ?? 256) + 400, // เพิ่มเผื่อขนาด legend
            height: widget.height,
            child: SfCircularChart(
              tooltipBehavior: _tooltip,
              legend: Legend(
                isVisible: true,
                // width: '200px',
                position: LegendPosition.right,
                overflowMode: LegendItemOverflowMode.wrap,
                // overflowMode: LegendItemOverflowMode.scroll, // เปลี่ยนตรงนี้
                toggleSeriesVisibility: true,
                title: LegendTitle(
                  text: 'กลุ่มโรคไม่ติดต่อเรื้อรัง',
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              // series: <CircularSeries<_ChartData, String>>[
              //   DoughnutSeries<_ChartData, String>(

              //     // dataSource: data,
              //     dataSource: dataNonZero,
              //     xValueMapper: (_ChartData data, _) => data.x,
              //     yValueMapper: (_ChartData data, _) => data.y,
              //     dataLabelSettings: DataLabelSettings(

              //       isVisible: true,
              //       labelPosition: ChartDataLabelPosition.outside,

              //       useSeriesColor: true,
              //       builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
              //         // Formatting the label as percentage
              //         double percentage = (point.y as double);
              //         return Text('${percentage.toStringAsFixed(2)}%', style: TextStyle(fontSize: 12));
              //       },
              //     ),
              //     name: 'Values',
              //   ),
              // ],
              series: [
                DoughnutSeries<_ChartData, String>(
                  dataSource: fullData,
                  xValueMapper: (d, _) => d.x,
                  yValueMapper: (d, _) => d.y,
                  // showInLegend: true,                   // แสดงทุกจุดใน legend
                  pointColorMapper: (d, _) => d.y > 0
                      ? diseaseColorMap[d.x] // สีปกติ
                      : Color.fromRGBO(200, 200, 200, 1), // สีเทา ถ้า = 0%
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    useSeriesColor: true,
                    // connectorLineSettings: ConnectorLineSettings(
                    //   length: '0%', // ไม่มีความยาว เส้นก็ไม่โผล่
                    //   color: Colors.transparent,
                    // ),
                    builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                      double pct = point.y as double;
                      if (pct == 0) {
                        // ถ้า 0% คืน widget เปล่าไปเลย
                        return const SizedBox.shrink();
                      }
                      return Text(
                        '${pct.toStringAsFixed(2)}%',
                        style: TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Data class to store chart values
class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
