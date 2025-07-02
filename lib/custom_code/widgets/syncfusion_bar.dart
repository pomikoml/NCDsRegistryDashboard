// Automatic FlutterFlow imports

import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion chart package
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:math'; // for random

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';

class SyncfusionBar extends StatefulWidget {
  const SyncfusionBar({super.key, this.width, this.height, this.rate, this.selected});

  final double? width;
  final double? height;
  final String? rate;
  final int? selected;
  @override
  State<SyncfusionBar> createState() => _SyncfusionBarState();
}

class _SyncfusionBarState extends State<SyncfusionBar> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  

  String apiToken = '';
  dynamic responseData;

  double count1 = 0.0;
  double count2 = 0.0;
  double count3 = 0.0;
  double count4 = 0.0;
  double count5 = 0.0;
  double count6 = 0.0;
  double count7 = 0.0;
  double count8 = 0.0;
  double count9 = 0.0;
  double count10 = 0.0;
  double count11 = 0.0;
  double count12 = 0.0;
  double count13 = 0.0;

  double percent1 = 0.0;
  double percent2 = 0.0;
  double percent3 = 0.0;
  double percent4 = 0.0;
  double percent5 = 0.0;
  double percent6 = 0.0;
  double percent7 = 0.0;
  double percent8 = 0.0;
  double percent9 = 0.0;
  double percent10 = 0.0;
  double percent11 = 0.0;
  double percent12 = 0.0;
  double percent13 = 0.0;

  List<double> counts = [];

  // final client = http.Client();
  // final baseurl = 'http://192.168.30.73:8000';
  // final baseurl = 'http://127.0.0.1:18001';
  final client = http.Client();
  final baseurl = EnvService.apiUrl;
  final username = EnvService.username;

  List<dynamic> regionList = [];
  int totalregion = 0;
final getX = Get.find<NCDsgetX>();
  @override
  void initState() {
    super.initState();

    // callAuthAPI();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getX.fetchGroupByRegion(fiscalYear: widget.selected ?? 0);
    });

    _tooltip = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = List.generate(
        getX.regionCounts.length,
        (index) => _ChartData('เขตสุขภาพที่ ${index + 1}', getX.regionCounts[index]),
      );

      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 450,
        child: SfCartesianChart(
          tooltipBehavior: _tooltip,
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            isVisible: false,
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
          ),
          primaryYAxis: NumericAxis(
            isVisible: false,
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
          ),
          series: <CartesianSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              pointColorMapper: (_ChartData data, _) => data.y == 0 ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromRGBO(8, 142, 255, 1),
              dataLabelMapper: (_ChartData data, _) => data.y == 0 ? '' : data.y.toString(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
