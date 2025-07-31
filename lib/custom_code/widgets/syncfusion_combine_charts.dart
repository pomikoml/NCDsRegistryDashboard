import 'dart:math';

import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class SyncfusionCombineCharts extends StatefulWidget {
  const SyncfusionCombineCharts({super.key, this.width, this.height, this.selected});

  final double? width;
  final double? height;
  final int? selected;
  @override
  State<SyncfusionCombineCharts> createState() => _SyncfusionCombineChartsState();
}

class _SyncfusionCombineChartsState extends State<SyncfusionCombineCharts> {
  late List<ChartSampleData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  ChartSeriesController? _chartSeriesController1;
  ChartSeriesController? _chartSeriesController2;
  late ZoomPanBehavior _zoomPan;

  String apiToken = '';
  dynamic responseData;

  // final client = http.Client();
  // final baseurl = 'http://192.168.30.73:8000';
  // final baseurl = 'http://127.0.0.1:18001';
  final client = http.Client();
  final baseurl = EnvService.apiUrl;
  final username = EnvService.username;
  final password = EnvService.password;

  List<dynamic> yearList = [];
  int totalYear = 0;

  int ipd_year1 = 0;
  int ipd_count1 = 0;
  double ipd_per100000_1 = 0.0;

  int ipd_year2 = 0;
  int ipd_count2 = 0;
  double ipd_per100000_2 = 0.0;

  int ipd_year3 = 0;
  int ipd_count3 = 0;
  double ipd_per100000_3 = 0.0;

  List<Map<String, dynamic>> yearDataList = [];

  String? userLogin;
  String? hospitalCode;
  String? hospitalName;
  String? scopeList;
  String? cid = '';
  // String? query = '';
  // String? querylv4 = '';
  String? check_access_level = '';
  List<String> query = [];
  List<String> querylv4 = [];

  @override
  void initState() {
    super.initState();
    _loadLoginData();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        if (series.name == 'อัตราประชากรต่อแสนคน') {
          final value = NumberFormat.decimalPattern().format(data.secondSeriesYValue);
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black, // Dark grey background color
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'อัตราประชากรต่อแสนคน',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white, // White text color
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white, // White text color
                  ),
                ),
              ],
            ),
          );
        }
        if (series.name == 'จำนวนผู้ป่วย') {
          final value = NumberFormat.decimalPattern().format(data.y);
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'จำนวนผู้ป่วย',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
    _zoomPan = ZoomPanBehavior(
      enablePanning: true,
      zoomMode: ZoomMode.x,
      // เริ่มต้นให้ซูมออกเหลือแค่ 30% ของข้อมูล
      // initialZoomPosition: 0,
      // initialZoomFactor: 0.3,
      enablePinching: true,
      // enablePinching: false,
      enableDoubleTapZooming: true,
    );
    callAuthAPI();
  }

  void didUpdateWidget(covariant SyncfusionCombineCharts oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selected != oldWidget.selected) {
      debugPrint('📌 ปีเปลี่ยนจาก ${oldWidget.selected} -> ${widget.selected}');
      fetchGroupByCdCode(fiscalYear: widget.selected ?? DateTime.now().year + 543);
    }
  }

  // ฟังก์ชันเพื่อดึงข้อมูล user_login
  Future<String> _getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_login') ?? '-'; // หากไม่มีข้อมูล จะคืนค่าเป็น "-"
  }

// ฟังก์ชันเพื่อดึงข้อมูล hospital_code
  Future<String> _getHospitalCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('hospital_code') ?? '-';
  }

// ฟังก์ชันเพื่อดึงข้อมูล hospital_name
  Future<String> _getHospitalName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('hospital_name') ?? '-';
  }

// ฟังก์ชันเพื่อดึงข้อมูล scope_list
  Future<String> _getScopeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('scope_list') ?? '-';
  }

  Future<String> _getcid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cid') ?? '-';
  }

  // Future<String> getProvinceQueryParams() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final codes = prefs.getStringList('org_province_codes') ?? [];
  //   return codes.map((c) => 'org_province_code=$c').join('&');
  // }

  // Future<String> getProvinceQuerylv4Params() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final codes = prefs.getStringList('access_level4_province_codes') ?? [];
  //   return codes.map((c) => 'org_province_code=$c').join('&');
  // }
  Future<List<String>> getProvinceQueryParams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final codes = prefs.getStringList('org_province_codes') ?? [];
    return prefs.getStringList('org_province_codes') ?? [];
    // return codes.map((c) => 'org_province_code=$c').join('&');
  }

  Future<List<String>> getProvinceQuerylv4Params() async {
    // final prefs = await SharedPreferences.getInstance();
    // final codes = prefs.getStringList('access_level4_province_codes') ?? [];
    // return codes.map((c) => 'org_province_code=$c').join('&');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final codes = prefs.getStringList('org_province_codes') ?? [];
    return prefs.getStringList('access_level4_province_codes') ?? [];
  }

  Future<String> getCheckAccessLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('check_access_level') ?? '1';
  }

  void _loadLoginData() async {
    userLogin = await _getUserLogin();
    hospitalCode = await _getHospitalCode();
    hospitalName = await _getHospitalName();
    scopeList = await _getScopeList();
    cid = await _getcid();
    final List<String> query2 = await getProvinceQueryParams();
    query = query2.map((e) => e.toString()).toList();
    final List<String> querylv42 = await getProvinceQuerylv4Params();
    querylv4 = querylv42.map((e) => e.toString()).toList();
    check_access_level =
        // '5';
        await getCheckAccessLevel();

    // print('User Login: $userLogin');
    // print('Hospital Code: $hospitalCode');
    // print('Hospital Name: $hospitalName');
    // print('Scope List: $scopeList');

    // คุณสามารถใช้ค่าที่ดึงมาเพื่อทำสิ่งต่างๆ ตามที่คุณต้องการ
  }

  Future<void> callAuthAPI() async {
    final url = Uri.parse('$baseurl/api/auth');

    // const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc0NTkzMTQ4NX0.EYIBiGIOzhvFo71BMjEYbGzrcfwv8rhz6ZKu-M9XWkg';

    final headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      "username": username, //admin
      "password": password,
    });

    try {
      final response = await client.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body);
        apiToken = responseData['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('apiToken', apiToken);
        setState(() {});
        debugPrint('✅ Auth Success: ${response.body}');
      } else {
        debugPrint('❌ Auth Failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      //debugPrint('🚫 Error calling API: $e');
    }

    // await fetchGroupByCdCode(fiscalYear: 0);
    await fetchGroupByCdCode(fiscalYear: widget.selected ?? 0);
  }

  // Map<String, dynamic>? findDiseaseByCode(String code) {
  //   return summaryList.firstWhere(
  //     (item) => item['cd_code'] == code,
  //     orElse: () => null,
  //   );
  // }

  Future<void> fetchGroupByCdCode({required int fiscalYear}) async {
    //debugPrint('apiToken: ${apiToken}');
    // final url = Uri.parse('$baseurl/api/summary/group-by-year?start_year=2023&end_year=2025&organization_code=$hospitalCode');

    // final url;
    // final fiscalParam = '${fiscalYear}';
    final int currentYear = DateTime.now().year;

    int startY;
    int endY;

    if (widget.selected == null || widget.selected == 0) {
      startY = 2020;
      endY = currentYear;
    } else {
      // แปลง พ.ศ. เป็น ค.ศ.
      startY = (widget.selected ?? 0) - 543;
      endY = startY;
    }
    final isAllHospital = hospitalCode == null || hospitalCode == '25039' || hospitalCode == '99999' || hospitalCode == '00000';
    // final hasQuery = query != null && query!.trim().isNotEmpty;

    // String urlStr = '$baseurl/api/summary/group-by-year?start_year=$startY&end_year=$endY';

    // if (check_access_level == '5') {
    //   // ไม่มีการกรองเพิ่มเติม
    // } else if (check_access_level == '4') {
    //   urlStr += '&$querylv4';
    // } else if (check_access_level == '3') {
    //   if (hasQuery) {
    //     urlStr += '&$query';
    //   }
    // } else {
    //   if (isAllHospital) {
    //     // ไม่เพิ่ม organization_code
    //     urlStr += '&organization_code=$hospitalCode';
    //   } else {
    //     urlStr += '&organization_code=$hospitalCode';
    //   }
    // }

    // url = Uri.parse(urlStr);

    // final headers = {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer $apiToken', // ใช้ token ที่ได้จาก login
    // };

    // try {
    //   final response = await client.get(
    //     url,
    //     headers: headers,
    //   );

    // --- สร้าง body แทน query string ---
    Map<String, dynamic> body = {
      // 'start_year': startY,
      // 'end_year': endY,
      'fiscal_year': fiscalYear,
    };

    if (check_access_level == '5') {
      // ไม่มีอะไรเพิ่ม
    } else if (check_access_level == '4') {
      body.addAll({
        'org_province_code': querylv4
      });
    } else if (check_access_level == '3') {
      // if (hasQuery)
      body.addAll({
        'org_province_code': query
      });
    } else {
      body.addAll({
        'organization_code': [
          hospitalCode
        ]
      });
      // if (hasQuery) body.addAll({'query': query});
    }

    // เงื่อนไขเฉพาะกรณีที่ไม่ได้อยู่ใน level 3 หรือ 4
    // if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
    //   body.addAll({
    //     'organization_code': [
    //       hospitalCode
    //     ]
    //   });
    // }

    final url = Uri.parse('$baseurl/api/summary/group-by-year');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken}',
    };

    try {
      // final response = await client.get(url, headers: headers);
      final response = await client.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);
        //debugPrint('✅ year Data: $data');
        // ใช้ setState() หรือเก็บ data ตามที่ต้องการ
        setState(() {
          yearDataList = List<Map<String, dynamic>>.from(data['data']);
        });

        // Reset zoom to ensure proper display when data length changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _zoomPan.reset();
        });

        //debugPrint('✅ Year Data Loaded, total: ${(totalYear)}');
      } else {
        //debugPrint('❌ Failed to fetch year: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      //debugPrint('🚫 Error fetching Year: $e');
    }
  }

  double roundUpToNiceNumber(double value) {
    if (value <= 0) return 1000;

    final exponent = (log(value) / log(10)).floor();
    final base = pow(10, exponent).toDouble(); // ✅

    final rounded = ((value / base).ceil()) * base;

    return rounded;
  }

  @override
  Widget build(BuildContext context) {
    // _chartData = List.generate(yearDataList.length, (index) {
    //   final item = yearDataList[index];
    //   return ChartSampleData(
    //     // x: '${index + 1}',
    //     x: '${(item['fiscal_year'] ?? 0)}', // ✅ แสดงเป็นปี พ.ศ.

    //     y: (item['count'] ?? 0).toDouble(),
    //     // y: 2000000,
    //     secondSeriesYValue: (item['rate_per_100000'] ?? 0).toDouble(),
    //   );
    // });

    // หาปี พ.ศ. ปัจจุบัน
    final int currentThaiYear = DateTime.now().year + 543;

    // กรองเอาเฉพาะ item ที่ fiscal_year <= ปีปัจจุบัน
    final validItems = yearDataList.where((item) {
      final fy = item['fiscal_year'] as int? ?? 0;
      return fy <= currentThaiYear;
    }).toList();

    // สร้าง chartData จาก validItems แทน
    _chartData = validItems.map((item) {
      return ChartSampleData(
        x: '${item['fiscal_year']}',
        y: (item['count'] ?? 0).toDouble(),
        secondSeriesYValue: (item['rate_per_100000'] ?? 0).toDouble(),
      );
    }).toList();

    final bool isSingleBar = _chartData.length == 1;

    return Container(
      width: widget.width,
      height: widget.height ?? 300, // Provide a default height if none is provided
      child: LayoutBuilder(
        builder: (context, constraints) {
          late double maxY;
          late double suggestedMaxY;
          late double suggestedInterval;

          if (_chartData.isNotEmpty) {
            maxY = _chartData.map((d) => d.y).reduce(max);
            // suggestedMaxY = (maxY * 1.2).ceilToDouble();
            suggestedMaxY = roundUpToNiceNumber(maxY * 1.2);

            suggestedInterval = (suggestedMaxY / 5).ceilToDouble();
          } else {
            maxY = 0;
            suggestedMaxY = 5000;
            suggestedInterval = 1000;
          }

          late double maxLineY = 0;
          late double suggestedLineMaxY = 0;
          late double suggestedLineInterval = 5000;

          if (_chartData.isNotEmpty) {
            maxLineY = _chartData.map((d) => d.secondSeriesYValue).reduce(max);
            suggestedLineMaxY = roundUpToNiceNumber(maxLineY); // ✅ ใช้ฟังก์ชันนี้
            suggestedLineInterval = (suggestedLineMaxY / 5).ceilToDouble(); // แบ่งเป็น 5 ช่วง
          }

          return SizedBox(
            width: widget.width,
            height: widget.height ?? 300,
            child: SfCartesianChart(
              zoomPanBehavior: _zoomPan,
              legend: Legend(
                isVisible: true,
                position: LegendPosition.top,
                alignment: ChartAlignment.center,
                itemPadding: 10,
                // overflowMode: LegendItemOverflowMode.scroll,
              ),
              tooltipBehavior: _tooltipBehavior,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                // เมื่อกรองดูเฉพาะปีเดียว หรือเหลือข้อมูลเพียงรายการเดียว ให้แสดงเต็มโดยไม่ซูม
                initialZoomPosition: (widget.selected != null && widget.selected! > 0) || isSingleBar ? 0 : 0.8,
                initialZoomFactor: (widget.selected != null && widget.selected! > 0) || isSingleBar ? 1 : 0.3,
                majorGridLines: MajorGridLines(width: 0),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                // labelStyle: TextStyle(color: Colors.transparent,),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ), // ✅ ปรับให้แสดงปี
              ),
              primaryYAxis: NumericAxis(
                // initialZoomPosition: 0,
                // initialZoomFactor: 0.3,
                minimum: 0,
                maximum: suggestedMaxY.toDouble(),
                numberFormat: NumberFormat.decimalPattern(),
                interval: suggestedInterval.toDouble(),
                majorGridLines: MajorGridLines(width: 0),
              ),
              axes: <ChartAxis>[
                NumericAxis(
                  name: 'yAxis1',
                  opposedPosition: true,
                  isVisible: true,
                  minimum: 0,
                  maximum: suggestedLineMaxY.toDouble(),
                  interval: suggestedLineInterval.toDouble(),
                  numberFormat: NumberFormat.decimalPattern(),
                  majorGridLines: MajorGridLines(width: 0),
                  labelStyle: TextStyle(color: Colors.black),
                  title: AxisTitle(text: 'อัตราประชากรต่อแสนคน'),
                ),
              ],
              series: <CartesianSeries>[
                ColumnSeries<ChartSampleData, String>(
                  name: 'จำนวนผู้ป่วย',
                  dataSource: _chartData,
                  spacing: isSingleBar ? 0 : (widget.selected! > 0 ? 0.5 : 0.3),
                  // ใช้ความกว้างคงที่เพื่อให้เลื่อนดูได้ต่อเนื่อง
                  width: 0.1,
                  xValueMapper: (ChartSampleData data, _) => data.x,
                  yValueMapper: (ChartSampleData data, _) => data.y,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  color: Color(0xFF2196F3),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  onRendererCreated: (controller) {
                    _chartSeriesController1 = controller;
                  },
                ),
                LineSeries<ChartSampleData, String>(
                  name: 'อัตราประชากรต่อแสนคน',
                  dataSource: _chartData,
                  xValueMapper: (ChartSampleData data, _) => data.x,
                  yValueMapper: (ChartSampleData data, _) => data.secondSeriesYValue,
                  yAxisName: 'yAxis1',
                  color: Color(0xFF1A237E),
                  markerSettings: MarkerSettings(isVisible: true),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onRendererCreated: (controller) {
                    _chartSeriesController2 = controller;
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _chartData.clear();
    _chartSeriesController1 = null;
    _chartSeriesController2 = null;
    super.dispose();
  }
}

class ChartSampleData {
  final String x;
  final double y;
  final double secondSeriesYValue;

  ChartSampleData({
    required this.x,
    required this.y,
    required this.secondSeriesYValue,
  });
}

void main() {
  runApp(MaterialApp(home: SyncfusionCombineCharts()));
}
