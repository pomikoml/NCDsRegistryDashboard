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

  // เพิ่มตัวแปรสำหรับควบคุมการอัพเดต UI
  bool _isDataLoaded = false;
  bool _hasDataChanged = false;
  int _lastSelectedYear = 0;

  @override
  void initState() {
    super.initState();
    _loadLoginData();
    _initializeTooltipAndZoom();
    callAuthAPI();
  }

  void _initializeTooltipAndZoom() {
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

    // กำหนด ZoomPanBehavior เริ่มต้น (จะถูกปรับใน build method)
    _zoomPan = ZoomPanBehavior(
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enablePinching: true,
      enableDoubleTapZooming: true,
    );
  }

  @override
  void didUpdateWidget(covariant SyncfusionCombineCharts oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selected != oldWidget.selected) {
      debugPrint('📌 ปีเปลี่ยนจาก ${oldWidget.selected} -> ${widget.selected}');
      _lastSelectedYear = widget.selected ?? 0;
      _hasDataChanged = true;

      // รีเซ็ตสถานะการโหลดข้อมูล
      setState(() {
        _isDataLoaded = false;
      });

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

  Future<List<String>> getProvinceQueryParams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('org_province_codes') ?? [];
  }

  Future<List<String>> getProvinceQuerylv4Params() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
  }

  Future<void> callAuthAPI() async {
    final url = Uri.parse('$baseurl/api/auth');

    final headers = {
      'Content-Type': 'application/json',
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

    await fetchGroupByCdCode(fiscalYear: widget.selected ?? 0);
  }

  Future<void> fetchGroupByCdCode({required int fiscalYear}) async {
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

    // --- สร้าง body แทน query string ---
    Map<String, dynamic> body = {
      'fiscal_year': fiscalYear,
    };

    if (check_access_level == '5') {
      // ไม่มีอะไรเพิ่ม
    } else if (check_access_level == '4') {
      body.addAll({
        'org_province_code': querylv4
      });
    } else if (check_access_level == '3') {
      body.addAll({
        'org_province_code': query
      });
    } else {
      body.addAll({
        'organization_code': [
          hospitalCode
        ]
      });
    }

    final url = Uri.parse('$baseurl/api/summary/group-by-year');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken}',
    };

    try {
      final response = await client.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);

        setState(() {
          yearDataList = List<Map<String, dynamic>>.from(data['data']);
          _isDataLoaded = true;
          _hasDataChanged = true;
        });

        debugPrint('✅ Year Data Loaded, items: ${yearDataList.length}');

        // บังคับให้ UI อัพเดตหลังจากข้อมูลโหลดเสร็จ
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _hasDataChanged = false;
            });
          }
        });
      } else {
        debugPrint('❌ Failed to fetch year: ${response.statusCode} ${response.body}');
        setState(() {
          _isDataLoaded = true;
          yearDataList = [];
        });
      }
    } catch (e) {
      debugPrint('🚫 Error fetching Year: $e');
      setState(() {
        _isDataLoaded = true;
        yearDataList = [];
      });
    }
  }

  double roundUpToNiceNumber(double value) {
    if (value <= 0) return 1000;

    final exponent = (log(value) / log(10)).floor();
    final base = pow(10, exponent).toDouble(); // ✅

    final rounded = ((value / base).ceil()) * base;

    return rounded;
  }

  // ฟังก์ชันสร้าง ZoomPanBehavior ตามจำนวนข้อมูล
  ZoomPanBehavior _createZoomPanBehavior(int dataLength, bool isSingleYear) {
    if (dataLength <= 1) {
      // ข้อมูลเท่ากับ 1 หรือไม่มีข้อมูล - ใช้กราฟปกติไม่ต้องซูม
      return ZoomPanBehavior(
        enablePanning: false,
        enablePinching: false,
        enableDoubleTapZooming: false,
        zoomMode: ZoomMode.x,
      );
    } else {
      // ข้อมูลมากกว่า 1 - ใช้กราฟแบบซูม
      return ZoomPanBehavior(
        enablePanning: true,
        zoomMode: ZoomMode.x,
        enablePinching: true,
        enableDoubleTapZooming: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // แสดง loading indicator ถ้าข้อมูลยังไม่โหลดเสร็จ
    if (!_isDataLoaded) {
      return Container(
        width: widget.width,
        height: widget.height ?? 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('กำลังโหลดข้อมูล...', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      );
    }

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

    // ตรวจสอบว่าเป็นการดูปีเฉพาะหรือไม่
    final bool isSingleYear = (widget.selected != null && widget.selected! > 0);
    final int dataLength = _chartData.length;

    // สร้าง ZoomPanBehavior ตามเงื่อนไข
    _zoomPan = _createZoomPanBehavior(dataLength, isSingleYear);

    // แสดงข้อความเมื่อไม่มีข้อมูล
    if (_chartData.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height ?? 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'ไม่มีข้อมูลในช่วงที่เลือก',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height ?? 300,
      child: LayoutBuilder(
        builder: (context, constraints) {
          late double maxY;
          late double suggestedMaxY;
          late double suggestedInterval;

          if (_chartData.isNotEmpty) {
            maxY = _chartData.map((d) => d.y).reduce(max);
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
            suggestedLineMaxY = roundUpToNiceNumber(maxLineY);
            suggestedLineInterval = (suggestedLineMaxY / 5).ceilToDouble();
          }

          return SizedBox(
            width: widget.width,
            height: widget.height ?? 300,
            child: SfCartesianChart(
              key: ValueKey('chart_${widget.selected}_${_chartData.length}_${_hasDataChanged}'),
              zoomPanBehavior: _zoomPan,
              legend: Legend(
                isVisible: true,
                position: LegendPosition.top,
                alignment: ChartAlignment.center,
                itemPadding: 10,
              ),
              tooltipBehavior: _tooltipBehavior,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                // ใช้ initialZoomPosition และ initialZoomFactor ใน CategoryAxis แทน
                initialZoomPosition: (dataLength > 1 && !isSingleYear) ? 0.7 : 0.0,
                initialZoomFactor: (dataLength > 1 && !isSingleYear) ? 0.3 : 1.0,
                majorGridLines: MajorGridLines(width: 0),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              primaryYAxis: NumericAxis(
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
                  spacing: (isSingleYear || dataLength == 1) ? 0.5 : 0.3,
                  width: dataLength == 1 ? 0.2 : 0.8,
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
