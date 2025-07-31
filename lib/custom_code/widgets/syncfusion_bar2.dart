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

class SyncfusionBar2 extends StatefulWidget {
  const SyncfusionBar2({super.key, this.width, this.height, this.selected});

  final double? width;
  final double? height;
  final int? selected;

  @override
  State<SyncfusionBar2> createState() => _SyncfusionBar2State();
}

class _SyncfusionBar2State extends State<SyncfusionBar2> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  final numberFormat = NumberFormat('#,###');

  final getX = Get.find<NCDsgetX>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getX.fetchRegionRatePer1000(fiscalYear: widget.selected ?? 0);
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
      final data = List.generate(13, (index) {
        final rate = getX.regionRatePer1000.length > index ? getX.regionRatePer1000[index] : 0.0;
        return _ChartData('เขตสุขภาพที่ ${index + 1}', rate);
      });

      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 450,
        child: SfCartesianChart(
          tooltipBehavior: _tooltip,
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <CartesianSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData d, _) => d.x,
              yValueMapper: (_ChartData d, _) => d.y,
              pointColorMapper: (_ChartData d, _) => d.y == 0 ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromRGBO(8, 142, 255, 1),
              // dataLabelMapper: (_ChartData d, _) => d.y == 0 ? '' : d.y.toString(), // ซ่อน label ถ้า y = 0
              dataLabelMapper: (_ChartData d, _) => d.y == 0 ? '' : numberFormat.format(d.y),
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
