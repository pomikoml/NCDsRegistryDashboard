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

class BloodSummaryProvince extends StatefulWidget {
  const BloodSummaryProvince({
    super.key,
    this.width,
    this.height,
    required this.provinceDataList,
    this.selectedRegionId,
  });

  final double? width;
  final double? height;
  final List<Map<String, dynamic>> provinceDataList;
  final String? selectedRegionId;

  @override
  State<BloodSummaryProvince> createState() => _BloodSummaryProvinceState();
}

class _BloodSummaryProvinceState extends State<BloodSummaryProvince> {
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _chartData;
  final NumberFormat numberFormat = NumberFormat('#,###');
  // int c13 = 0;
  late ZoomPanBehavior _zoomPanBehavior;

  final Map<String, String> provinceCodeMap = {
    '10': 'กรุงเทพมหานคร',
    '11': 'สมุทรปราการ',
    '12': 'นนทบุรี',
    '13': 'ปทุมธานี',
    '14': 'พระนครศรีอยุธยา',
    '15': 'อ่างทอง',
    '16': 'ลพบุรี',
    '17': 'สิงห์บุรี',
    '18': 'ชัยนาท',
    '19': 'สระบุรี',
    '20': 'ชลบุรี',
    '21': 'ระยอง',
    '22': 'จันทบุรี',
    '23': 'ตราด',
    '24': 'ฉะเชิงเทรา',
    '25': 'ปราจีนบุรี',
    '26': 'นครนายก',
    '27': 'สระแก้ว',
    '30': 'นครราชสีมา',
    '31': 'บุรีรัมย์',
    '32': 'สุรินทร์',
    '33': 'ศรีสะเกษ',
    '34': 'อุบลราชธานี',
    '35': 'ยโสธร',
    '36': 'ชัยภูมิ',
    '37': 'อำนาจเจริญ',
    '38': 'บึงกาฬ',
    '39': 'หนองบัวลำภู',
    '40': 'ขอนแก่น',
    '41': 'อุดรธานี',
    '42': 'เลย',
    '43': 'หนองคาย',
    '44': 'มหาสารคาม',
    '45': 'ร้อยเอ็ด',
    '46': 'กาฬสินธุ์',
    '47': 'สกลนคร',
    '48': 'นครพนม',
    '49': 'มุกดาหาร',
    '50': 'เชียงใหม่',
    '51': 'ลำพูน',
    '52': 'ลำปาง',
    '53': 'อุตรดิตถ์',
    '54': 'แพร่',
    '55': 'น่าน',
    '56': 'พะเยา',
    '57': 'เชียงราย',
    '58': 'แม่ฮ่องสอน',
    '60': 'นครสวรรค์',
    '61': 'อุทัยธานี',
    '62': 'กำแพงเพชร',
    '63': 'ตาก',
    '64': 'สุโขทัย',
    '65': 'พิษณุโลก',
    '66': 'พิจิตร',
    '67': 'เพชรบูรณ์',
    '70': 'ราชบุรี',
    '71': 'กาญจนบุรี',
    '72': 'สุพรรณบุรี',
    '73': 'นครปฐม',
    '74': 'สมุทรสาคร',
    '75': 'สมุทรสงคราม',
    '76': 'เพชรบุรี',
    '77': 'ประจวบคีรีขันธ์',
    '80': 'นครศรีธรรมราช',
    '81': 'กระบี่',
    '82': 'พังงา',
    '83': 'ภูเก็ต',
    '84': 'สุราษฎร์ธานี',
    '85': 'ระนอง',
    '86': 'ชุมพร',
    '90': 'สงขลา',
    '91': 'สตูล',
    '92': 'ตรัง',
    '93': 'พัทลุง',
    '94': 'ปัตตานี',
    '95': 'ยะลา',
    '96': 'นราธิวาส',
  };

  @override
  void initState() {
    super.initState();
    // c13 = widget.c13 ?? 0;

    _tooltipBehavior = TooltipBehavior(enable: true, header: '', canShowMarker: false);

    // กำหนด ZoomPanBehavior
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      zoomMode: ZoomMode.x,
      // เริ่มต้นให้ซูมออกเหลือแค่ 30% ของข้อมูล
      // initialZoomPosition: 0,
      // initialZoomFactor: 0.3,
      enablePinching: true,
      // enablePinching: false,
      enableDoubleTapZooming: true,
    );
  }

  final Map<String, String> provinceToRegionMap = {
    // เขต 1
    '50': '1', '51': '1', '52': '1', '54': '1', '55': '1', '56': '1', '57': '1', '58': '1',

    // เขต 2
    '63': '2', '64': '2', '65': '2', '67': '2', '53': '2',

    // เขต 3
    '60': '3', '61': '3', '62': '3', '66': '3', '18': '3',

    // เขต 4
    '12': '4', '13': '4', '14': '4', '15': '4', '16': '4', '17': '4', '19': '4', '26': '4',

    // เขต 5
    '70': '5', '71': '5', '72': '5', '73': '5', '74': '5', '75': '5', '76': '5', '77': '5',

    // เขต 6
    '11': '6', '20': '6', '21': '6', '22': '6', '23': '6', '24': '6', '25': '6', '27': '6',

    // เขต 7
    '40': '7', '44': '7', '45': '7', '46': '7',

    // เขต 8
    '38': '8', '39': '8', '41': '8', '42': '8', '43': '8', '47': '8', '48': '8',

    // เขต 9
    '30': '9', '31': '9', '32': '9', '36': '9',

    // เขต 10
    '33': '10', '34': '10', '35': '10', '37': '10', '49': '10',

    // เขต 11
    '80': '11', '81': '11', '82': '11', '83': '11', '84': '11', '85': '11', '86': '11',

    // เขต 12
    '90': '12', '91': '12', '92': '12', '93': '12', '94': '12', '95': '12', '96': '12',

    // เขต 13 (เฉพาะกรุงเทพฯ)
    '10': '13',
  };

  @override
  Widget build(BuildContext context) {
    // final filteredDataList = widget.provinceDataList.where((e) {
    //   final code = e['provinceCode'] ?? '';
    //   if (widget.selectedRegionId == null || widget.selectedRegionId!.isEmpty) {
    //     return true;
    //   }
    //   final region = provinceToRegionMap[code];
    //   return region == widget.selectedRegionId;
    // }).toList();

//     final filteredDataList = widget.provinceDataList.where((e) {
//   final code = e['provinceCode'] ?? '';

//   if (widget.userLevel == '5') {
//     // ✅ เงื่อนไขเวล 5: แสดงเฉพาะจังหวัดใน orgProvinceCodes ที่ส่งมา
//     return widget.orgProvinceCodes?.contains(code) ?? false;
//   }

//   if (widget.selectedRegionId == null || widget.selectedRegionId!.isEmpty) {
//     return true;
//   }

//   final region = provinceToRegionMap[code];
//   return region == widget.selectedRegionId;
// }).toList();

    // print('[DEBUG] filteredDataList = $filteredDataList');

    // _chartData = filteredDataList.map((e) {
    //   final code = e['provinceCode'] ?? '';
    //   final label = provinceCodeMap[code] ?? 'ไม่ทราบจังหวัด';
    //   final value = e['value'] ?? 0;
    //   return ChartSampleData(x: label, y: value);
    // }).toList();

    _chartData = widget.provinceDataList.map((e) {
      final code = e['provinceCode'] ?? '';
      final label = provinceCodeMap[code] ?? 'ไม่ทราบจังหวัด';
      final value = e['value'] ?? 0;
      return ChartSampleData(x: label, y: value);
    }).toList();
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: _buildCartesianChart(),
    );
  }
// ...existing code...

  // --- เดิม ---
  // int _getMaxY() {
  //   final values = _chartData.map((e) => e.y).toList();
  //   final max = values.isEmpty ? 1000 : values.reduce((a, b) => a > b ? a : b);
  //   return ((max + 4999) ~/ 5000) * 5000;
  // }

  // --- ปรับใหม่ให้ช่วงกราฟเหมาะสมกับข้อมูล และแบ่งเป็น 5 ช่วง ---
  int _getMaxY() {
    final values = _chartData.map((e) => e.y).toList();
    if (values.isEmpty) return 1000;
    final max = values.reduce((a, b) => a > b ? a : b);

    // คำนวณ maxY ให้หาร 5 ลงตัว
    final interval = _getNiceInterval(max ~/ 5);
    return interval * 5;
  }

  // ฟังก์ชันสำหรับหา interval ที่เหมาะสม (เช่น 200, 500, 1000, 5000, ...)
  int _getNiceInterval(int approx) {
    if (approx <= 200) return 200;
    if (approx <= 500) return 500;
    if (approx <= 1000) return 1000;
    if (approx <= 5000) return 5000;
    if (approx <= 10000) return 10000;
    if (approx <= 20000) return 20000;
    return ((approx / 10000).ceil()) * 10000;
  }

  // SfCartesianChart _buildCartesianChart() {
  //   final maxY = _getMaxY();
  //   final interval = (maxY / 5).ceil(); // แบ่งเป็น 5 ช่วง

  //   return SfCartesianChart(
  //     plotAreaBorderWidth: 0,
  //     primaryXAxis: CategoryAxis(
  //       initialZoomFactor: 0.3, // เริ่มต้นที่ 50% ของแกน X
  //       // initialZoomPosition: 0.2, // เริ่มต้นที่ตำแหน่งเริ่มต้นของแกน X
  //       labelRotation: 45, // หมุนข้อความในแกน X ให้เอียง

  //       majorGridLines: const MajorGridLines(width: 0),
  //     ),
  //     primaryYAxis: NumericAxis(
  //       minimum: 0,
  //       maximum: maxY.toDouble(),
  //       interval: interval.toDouble(), // แบ่งเป็น 5 ช่วง
  //       axisLine: const AxisLine(width: 0),
  //       labelFormat: '{value}',
  //       numberFormat: numberFormat, // ฟอร์แมตให้มี comma
  //       majorTickLines: const MajorTickLines(size: 0),
  //     ),
  //     series: _buildColumnSeries(),
  //     tooltipBehavior: _tooltipBehavior,
  //     zoomPanBehavior: _zoomPanBehavior,
  //   );
  // }

  // แทนที่ฟังก์ชัน _buildCartesianChart() เดิม
  SfCartesianChart _buildCartesianChart() {
    final maxY = _getMaxY();
    final interval = (maxY / 5).ceil();

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        initialZoomFactor: _chartData.length <= 5 ? 1.0 : 0.3,
        labelRotation: 45,
        majorGridLines: const MajorGridLines(width: 0),

        // 🔧 ปรับ plotOffset เพื่อลดพื้นที่ว่างข้างต้น/ข้างล่าง
        plotOffset: _chartData.length <= 3 ? 50 : 20,

        // ควบคุมการแสดงผล label
        labelIntersectAction: AxisLabelIntersectAction.none,

        // ปรับ range mode
        rangePadding: _chartData.length <= 3
            ? ChartRangePadding.none // ไม่เพิ่ม padding เมื่อข้อมูลน้อย
            : ChartRangePadding.auto,
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: maxY.toDouble(),
        interval: interval.toDouble(),
        axisLine: const AxisLine(width: 0),
        labelFormat: '{value}',
        numberFormat: numberFormat,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
      zoomPanBehavior: _chartData.length <= 5
          ? ZoomPanBehavior(
              enablePanning: false,
              enablePinching: false,
              enableDoubleTapZooming: false,
            )
          : _zoomPanBehavior,
    );
  }

// ...existing code...
  // int _getMaxY() {
  //   final values = _chartData.map((e) => e.y).toList();
  //   final max = values.isEmpty ? 1000 : values.reduce((a, b) => a > b ? a : b);
  //   return ((max + 4999) ~/ 5000) * 5000;
  // }

  // SfCartesianChart _buildCartesianChart() {
  //   return SfCartesianChart(
  //     plotAreaBorderWidth: 0,
  //     primaryXAxis: CategoryAxis(
  //       labelRotation: 45, // หมุนข้อความในแกน X ให้เอียง
  //       majorGridLines: const MajorGridLines(width: 0),
  //     ),
  //     primaryYAxis: NumericAxis(
  //       minimum: 0,
  //       maximum: _getMaxY().toDouble(),
  //       interval: 5000,
  //       axisLine: const AxisLine(width: 0),
  //       labelFormat: '{value}',
  //       numberFormat: numberFormat, // ฟอร์แมตให้มี comma
  //       majorTickLines: const MajorTickLines(size: 0),
  //     ),
  //     series: _buildColumnSeries(),
  //     tooltipBehavior: _tooltipBehavior,
  //   );
  // }

  // ปรับปรุงในส่วน _buildColumnSeries()
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    // คำนวณขนาดแท่งและระยะห่างตามจำนวนข้อมูล
    double columnWidth;
    double columnSpacing;

    if (_chartData.length <= 2) {
      // เมื่อมีข้อมูลน้อย ให้แท่งเล็กลงและระยะห่างมากขึ้น
      columnWidth = 0.5;
      columnSpacing = 0.8;
    } else if (_chartData.length <= 5) {
      columnWidth = 0.5;
      columnSpacing = 0.6;
    } else if (_chartData.length <= 10) {
      columnWidth = 0.5;
      columnSpacing = 0.4;
    } else {
      columnWidth = 0.5;
      columnSpacing = 0.3;
    }

    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        width: columnWidth, // ขนาดแท่งแบบไดนามิก
        spacing: columnSpacing, // ระยะห่างแบบไดนามิก
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
        borderRadius: const BorderRadius.all(Radius.circular(8)),
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
