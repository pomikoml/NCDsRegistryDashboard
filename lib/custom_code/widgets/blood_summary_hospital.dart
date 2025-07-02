import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class BloodSummaryHospital extends StatefulWidget {
  const BloodSummaryHospital({
    super.key,
    this.width,
    this.height,
    required this.hospitalDataList,
    this.selectedHcode,
  });

  final double? width;
  final double? height;
  final List<Map<String, dynamic>> hospitalDataList; // [{hcode: '99999', value: 1234}]
  final String? selectedHcode;

  @override
  State<BloodSummaryHospital> createState() => _BloodSummaryHospitalState();
}

class _BloodSummaryHospitalState extends State<BloodSummaryHospital> {
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _chartData;
  final NumberFormat numberFormat = NumberFormat('#,###');
  final NumberFormat _nf = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true, header: '', canShowMarker: false);
  }

  // @override
  // Widget build(BuildContext context) {
  //   // print('selectedHcode ${widget.selectedHcode}');
  //   final selectedHcodeId = RegExp(r'\((\d+)\)').firstMatch(widget.selectedHcode ?? '')?.group(1) ?? '';

  //   final filteredList = widget.hospitalDataList.where((e) {
  //     final hcode = e['hcode']?.toString() ?? '';
  //     return selectedHcodeId.isEmpty ? true : hcode == selectedHcodeId;
  //   }).toList();

  //   _chartData = filteredList.map((e) {
  //     final code = e['hcode']?.toString() ?? '';
  //     final value = e['value'] ?? 0;
  //     return ChartSampleData(x: code, y: value);
  //     // return ChartSampleData(x: value, y: code);
  //   }).toList();

  //   final chartHeight = (_chartData.length * 50.0).clamp(200.0, 2000.0);
  //   // _chartData = widget.hospitalDataList.map((e) {
  //   //   final code = e['hcode']?.toString() ?? '';
  //   //   final value = e['value'] ?? 0;
  //   //   return ChartSampleData(x: code, y: value);
  //   // }).toList();

  //   // return Container(
  //   //   width: widget.width ?? double.infinity,
  //   //   height: widget.height,
  //   //   child: _buildCartesianChart(),
  //   // );
  //   return
  //   Container(
  //     height: widget.height,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       // scrollDirection: Axis.vertical,
  //       child: SizedBox(
  //         width: (_chartData.length * 80).toDouble(), // 80 คือความกว้างต่อแท่ง ปรับได้
  //         // height: chartHeight,
  //         child: _buildCartesianChart(),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final selectedHcodeId = RegExp(r'\((\d+)\)').firstMatch(widget.selectedHcode ?? '')?.group(1) ?? '';

    final filteredList = widget.hospitalDataList.where((e) {
      final hcode = e['hcode']?.toString() ?? '';
      return selectedHcodeId.isEmpty ? true : hcode == selectedHcodeId;
    }).toList();

    _chartData = filteredList.map((e) {
      final code = e['hcode']?.toString() ?? '';
      final value = e['value'] ?? 0;
      return ChartSampleData(x: code, y: value);
    }).toList();

    final maxY = _getMaxY();
    final interval = _getInterval(maxY);
    final chartWidth = (_chartData.length * 80).toDouble(); // ความกว้างแต่ละแท่ง

    return Container(
      height: widget.height ?? 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ ส่วนแกน Y (ล็อกคงที่)
          Container(
            width: 60,
            height: widget.height ?? 300,
            child: SfCartesianChart(
              // plotAreaBorderWidth: 1, margin: const EdgeInsets.only(top: 10, bottom: 20), plotAreaBackgroundColor: Colors.red.withOpacity(0.05),

              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: maxY.toDouble(),
                interval: interval,
                plotOffset: 42,
                axisLine: const AxisLine(width: 1),
                labelFormat: '{value}',
                majorTickLines: const MajorTickLines(size: 0),
                numberFormat: numberFormat,
              ),
              primaryXAxis: CategoryAxis(isVisible: false),
              series: <CartesianSeries<dynamic, dynamic>>[], // ✅ แบบนี้ถูกต้อง
            ),
          ),

          // ✅ ส่วนกราฟแท่ง (scroll ได้)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: chartWidth,
                height: widget.height ?? 300,
                child: SfCartesianChart(
                  margin: const EdgeInsets.only(right: 2, top: 10, bottom: 10),

                  // plotAreaBorderWidth: 1, margin: const EdgeInsets.only(top: 10, bottom: 20),
                  // plotAreaBackgroundColor: Colors.red.withOpacity(0.05),

                  primaryYAxis: NumericAxis(
                    isVisible: false,
                    minimum: 0,
                    maximum: maxY.toDouble(),
                    interval: interval,
                    // plotOffset: 10,
                  ), // ซ่อนแกน Y
                  primaryXAxis: CategoryAxis(
                    labelRotation: 45,
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  series: _buildColumnSeries(),
                  tooltipBehavior: _tooltipBehavior,
                  // zoomPanBehavior: ZoomPanBehavior(
                  //   enablePanning: true,
                  //   zoomMode: ZoomMode.x,
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SfCartesianChart _buildCartesianChart() {
    final maxY = _getMaxY();
    return SfCartesianChart(
      // isTransposed: true,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelRotation: 45,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        // maximum: _getMaxY().toDouble(),
        maximum: maxY.toDouble(),
        interval: _getInterval(maxY),
        axisLine: const AxisLine(width: 0),
        labelFormat: '{value}',
        numberFormat: numberFormat,
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
        width: 0.7, // 👈 ทำให้แท่งเล็กลง
        spacing: 0.3,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          labelAlignment: ChartDataLabelAlignment.outer,
          builder: (data, _, __, ___, ____) {
            return Text(numberFormat.format((data as ChartSampleData).y));
          },
        ),
        color: const Color.fromARGB(255, 27, 136, 224),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
    ];
  }

  // int _getMaxY() {
  //   final values = _chartData.map((e) => e.y).toList();
  //   // final values = _chartData.map((e) => e.x).toList();
  //   final max = values.isEmpty ? 1000 : values.reduce((a, b) => a > b ? a : b);
  //   return ((max + 4999) ~/ 5000) * 5000;
  // }

  // List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
  //   return [
  //     ColumnSeries<ChartSampleData, String>(
  //       dataSource: _chartData,
  //       xValueMapper: (d, _) => d.x, // String → CategoryAxis
  //       yValueMapper: (d, _) => d.y, // int    → NumericAxis
  //       width: 0.7,
  //       spacing: 0.3,
  //       dataLabelSettings: DataLabelSettings(
  //         isVisible: true,
  //         labelAlignment: ChartDataLabelAlignment.outer,
  //         builder: (data, _, __, ___, ____) {
  //           final item = data as ChartSampleData;
  //           return Text(numberFormat.format(item.y));
  //         },
  //       ),
  //       color: const Color.fromARGB(255, 27, 136, 224),
  //       borderRadius: const BorderRadius.all(Radius.circular(8)),
  //     ),
  //   ];
  // }

  double _getInterval(int maxY) {
    if (maxY <= 1000) return 200;
    if (maxY <= 5000) return 1000;
    if (maxY <= 10000) return 2000;
    if (maxY <= 20000) return 5000;
    return 10000;
  }

  int _getMaxY() {
    final values = _chartData.map((e) => e.y).toList();
    final max = values.isEmpty ? 1000 : values.reduce((a, b) => a > b ? a : b);

    // เพิ่ม buffer 10% แล้วปัดขึ้นเป็นช่วงที่ต้องการ
    final buffer = (max * 0.1).ceil();
    final maxWithBuffer = max + buffer;

    // ปัดขึ้นให้เป็นจำนวนกลม เช่น 5000, 10000
    if (maxWithBuffer <= 1000) return 1000;
    if (maxWithBuffer <= 5000) return 5000;
    if (maxWithBuffer <= 10000) return 10000;
    return ((maxWithBuffer + 999) ~/ 1000) * 1000;
  }

  // int _getMaxY() {
  //   final values = _chartData.map((e) => e.y).toList();
  //   // final values = _chartData.map((e) => e.x).toList();
  //   final max = values.isEmpty ? 1000 : values.reduce((a, b) => a > b ? a : b);
  //   return ((max + 4999) ~/ 5000) * 5000;
  // }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ChartSampleData {
  final String x;
  final int y;
  // final int x;
  // final String y;

  ChartSampleData({
    required this.x,
    required this.y,
  });
}

// //===============================================
