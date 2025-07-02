// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';
import 'package:n_c_ds_registry_dashboard/custom_code/widgets/blood_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/blood_pressure_grouping_d_ialog/blood_pressure_grouping_d_ialog_widget.dart';
import '/components/header/header_widget.dart';
import '/components/heatmap/heatmap_widget.dart';
import '/components/remark_widget/remark_widget_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'stroke_model.dart';
export 'stroke_model.dart';
import 'package:http/http.dart' as http;

class StrokeWidget extends StatefulWidget {
  const StrokeWidget({super.key});

  static String routeName = 'Stroke';
  static String routePath = '/Stroke';

  @override
  State<StrokeWidget> createState() => _StrokeWidgetState();
}

class _StrokeWidgetState extends State<StrokeWidget> with TickerProviderStateMixin {
  late StrokeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  String? userLogin;
  String? hospitalCode;
  String? hospitalName;
  String? scopeList;
  String? cid = '';
  String apiToken = '';
  dynamic responseData;
  final client = http.Client();
  final baseurl = EnvService.apiUrl;
  final username = EnvService.username;
  final password = EnvService.password;

  int countRegion1 = 0;
  int countRegion2 = 0;
  int countRegion3 = 0;
  int countRegion4 = 0;
  int countRegion5 = 0;
  int countRegion6 = 0;
  int countRegion7 = 0;
  int countRegion8 = 0;
  int countRegion9 = 0;
  int countRegion10 = 0;
  int countRegion11 = 0;
  int countRegion12 = 0;
  int countRegion13 = 0;
  int countTotalRegion = 0;

  // สร้างตัวแปรกลุ่มช่วงอายุ 7 กลุ่ม
  double age0_4 = 0;
  double age5_11 = 0;
  double age12_17 = 0;
  double age18_59 = 0;
  double age60plus = 0;
  int totalage = 0;

  int male = 0;
  int female = 0;
  int totalgender = 0;

  int checkfilter = 0;
  int checkregionfilter = 4;
  String regionIdFilter = '';
  String hospitalselect = '';
  List<Map<String, dynamic>> convertedList = [];
  List<Map<String, dynamic>> convertedHospitalList = [];
  List<String> provinceOptions = [];
  List<String> HospitalOptions = [];
  late List<String> hcodelist;
  List<String> orgProvinceCodes = [];
  List<String> hcodeList = [];

  String? check_access_level = '';

  var orgProvinceCodesList;
  var queryhcodeList = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StrokeModel());
    _loadLoginData();
    loadProvinces();

    // provinceOptions = [
    //   'ทั้งหมด',
    //   ...provinceCodeMap.keys
    // ];
    animationsMap.addAll({
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, -15.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    callAuthAPI();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  final Map<String, String> provinceCodeMap = {
    'กรุงเทพมหานคร': '10',
    'สมุทรปราการ': '11',
    'นนทบุรี': '12',
    'ปทุมธานี': '13',
    'พระนครศรีอยุธยา': '14',
    'อ่างทอง': '15',
    'ลพบุรี': '16',
    'สิงห์บุรี': '17',
    'ชัยนาท': '18',
    'สระบุรี': '19',
    'ชลบุรี': '20',
    'ระยอง': '21',
    'จันทบุรี': '22',
    'ตราด': '23',
    'ฉะเชิงเทรา': '24',
    'ปราจีนบุรี': '25',
    'นครนายก': '26',
    'สระแก้ว': '27',
    'นครราชสีมา': '30',
    'บุรีรัมย์': '31',
    'สุรินทร์': '32',
    'ศรีสะเกษ': '33',
    'อุบลราชธานี': '34',
    'ยโสธร': '35',
    'ชัยภูมิ': '36',
    'อำนาจเจริญ': '37',
    'บึงกาฬ': '38',
    'หนองบัวลำภู': '39',
    'ขอนแก่น': '40',
    'อุดรธานี': '41',
    'เลย': '42',
    'หนองคาย': '43',
    'มหาสารคาม': '44',
    'ร้อยเอ็ด': '45',
    'กาฬสินธุ์': '46',
    'สกลนคร': '47',
    'นครพนม': '48',
    'มุกดาหาร': '49',
    'เชียงใหม่': '50',
    'ลำพูน': '51',
    'ลำปาง': '52',
    'อุตรดิตถ์': '53',
    'แพร่': '54',
    'น่าน': '55',
    'พะเยา': '56',
    'เชียงราย': '57',
    'แม่ฮ่องสอน': '58',
    'นครสวรรค์': '60',
    'อุทัยธานี': '61',
    'กำแพงเพชร': '62',
    'ตาก': '63',
    'สุโขทัย': '64',
    'พิษณุโลก': '65',
    'พิจิตร': '66',
    'เพชรบูรณ์': '67',
    'ราชบุรี': '70',
    'กาญจนบุรี': '71',
    'สุพรรณบุรี': '72',
    'นครปฐม': '73',
    'สมุทรสาคร': '74',
    'สมุทรสงคราม': '75',
    'เพชรบุรี': '76',
    'ประจวบคีรีขันธ์': '77',
    'นครศรีธรรมราช': '80',
    'กระบี่': '81',
    'พังงา': '82',
    'ภูเก็ต': '83',
    'สุราษฎร์ธานี': '84',
    'ระนอง': '85',
    'ชุมพร': '86',
    'สงขลา': '90',
    'สตูล': '91',
    'ตรัง': '92',
    'พัทลุง': '93',
    'ปัตตานี': '94',
    'ยะลา': '95',
    'นราธิวาส': '96',
  };

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // Future<List<String>> getFilteredProvinceNames() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   print('[DEBUG] check_access_level getFilteredProvinceNames = $check_access_level');
  //   final accessLevel =
  //   // check_access_level;
  //   // '3';
  //   prefs.getString('check_access_level') ?? '1';

  //   if (accessLevel == '5') {
  //     // เวล 5 แสดงทั้งหมด
  //     return provinceCodeMap.keys.toList()..sort();
  //   }

  //   List<String> rawCodes = [];

  //   if (accessLevel == '4') {
  //     rawCodes = prefs.getStringList('access_level4_province_codes') ?? [];
  //   } else if (accessLevel == '3') {
  //     rawCodes = prefs.getStringList('org_province_codes') ?? [];
  //   } else {
  //     // เวล 1–2: ไม่อนุญาตให้ดู → คืน empty list
  //     return [];
  //   }

  //   final allowedCodes = rawCodes.map((e) => e.trim()).toSet();

  //   final filtered = provinceCodeMap.entries.where((entry) => allowedCodes.contains(entry.value)).map((entry) => entry.key).toList()..sort();

  //   return filtered;
  // }

  Future<void> loadProvinces({String? selectedRegion}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessLevel =
        // '5';
        prefs.getString('check_access_level') ?? '1';

    List<String> filtered = [];

    if (accessLevel == '5') {
      if (selectedRegion != null && healthRegionToProvinceCodes.containsKey(selectedRegion)) {
        final codes = healthRegionToProvinceCodes[selectedRegion]!;
        filtered = provinceCodeMap.entries.where((entry) => codes.contains(entry.value)).map((entry) => entry.key).toList()..sort();
      } else {
        filtered = provinceCodeMap.keys.toList()..sort();
      }
    } else {
      // เวลา 4 หรือ 3
      List<String> rawCodes = [];
      if (accessLevel == '4') {
        rawCodes = prefs.getStringList('access_level4_province_codes') ?? [];
      } else if (accessLevel == '3') {
        rawCodes = prefs.getStringList('org_province_codes') ?? [];
      } else {
        filtered = [];
      }

      final allowedCodes = rawCodes.map((e) => e.trim()).toSet();
      filtered = provinceCodeMap.entries.where((entry) => allowedCodes.contains(entry.value)).map((entry) => entry.key).toList()..sort();
    }

    setState(() {
      provinceOptions = [
        'ทั้งหมด',
        ...filtered
      ];
    });
  }

  final Map<String, List<String>> healthRegionToProvinceCodes = {
    'เขตสุขภาพที่ 1': [
      '50',
      '57',
      '54',
      '55',
      '56',
      '52',
      '51',
      '58'
    ],
    'เขตสุขภาพที่ 2': [
      '63',
      '67',
      '65',
      '53',
      '64'
    ],
    'เขตสุขภาพที่ 3': [
      '62',
      '66',
      '60',
      '18',
      '61'
    ],
    'เขตสุขภาพที่ 4': [
      '19',
      '12',
      '16',
      '15',
      '26',
      '17',
      '14',
      '13'
    ],
    'เขตสุขภาพที่ 5': [
      '76',
      '74',
      '75',
      '77',
      '72',
      '73',
      '70',
      '71'
    ],
    'เขตสุขภาพที่ 6': [
      '27',
      '25',
      '24',
      '11',
      '20',
      '22',
      '21',
      '23'
    ],
    'เขตสุขภาพที่ 7': [
      '46',
      '40',
      '44',
      '45'
    ],
    'เขตสุขภาพที่ 8': [
      '41',
      '47',
      '48',
      '42',
      '43',
      '39',
      '38'
    ],
    'เขตสุขภาพที่ 9': [
      '36',
      '30',
      '31',
      '32'
    ],
    'เขตสุขภาพที่ 10': [
      '34',
      '33',
      '49',
      '37',
      '35'
    ],
    'เขตสุขภาพที่ 11': [
      '80',
      '84',
      '83',
      '81',
      '82',
      '85',
      '86'
    ],
    'เขตสุขภาพที่ 12': [
      '90',
      '91',
      '92',
      '93',
      '94',
      '95',
      '96'
    ],
    'เขตสุขภาพที่ 13': [
      '10'
    ], // เฉพาะกรุงเทพมหานคร
  };

  Future<void> loadHospitalByProvinceCode(String provinceCode) async {
    final url = Uri.parse('$baseurl/api/hospital');
    final headers = {
      'Authorization': 'Bearer $apiToken',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'page_size': 10000,
      'province_code': provinceCode,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> data = decoded['data'] ?? [];

        setState(() {
          hcodeList = [
            'ทั้งหมด',
            ...data.map<String>((e) => '${e["hospital_name"]} (${e["hospital_code"]})').toList()
          ];
        });
      } else {
        print('[ERROR] ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] loadHospitalByProvinceCode: $e');
    }
  }

  // Future<void> loadProvinces() async {
  //   final list = await getFilteredProvinceNames();
  //   setState(() {
  //     provinceOptions = [
  //       'ทั้งหมด',
  //       ...list
  //     ];
  //   });
  // }

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
        //debugPrint('✅ Auth Success: ${response.body}');
      } else {
        //debugPrint('❌ Auth Failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      //debugPrint('🚫 Error calling API: $e');
    }

    await fetchRegionChartData(district: '', hospital: queryhcodeList, province: orgProvinceCodesList, regionName: '', year: '');
    await fetchHighBloodPressureByAge(district: '', hospital: queryhcodeList, province: orgProvinceCodesList, regionName: '', year: '');
    await fetchHighBloodPressureByGender(district: '', hospital: queryhcodeList, province: orgProvinceCodesList, regionName: '', year: '');
  }

  String _getRegionId(String? name) {
    switch (name) {
      case 'เขตสุขภาพที่ 1':
        return '1';
      case 'เขตสุขภาพที่ 2':
        return '2';
      case 'เขตสุขภาพที่ 3':
        return '3';
      case 'เขตสุขภาพที่ 4':
        return '4';
      case 'เขตสุขภาพที่ 5':
        return '5';
      case 'เขตสุขภาพที่ 6':
        return '6';
      case 'เขตสุขภาพที่ 7':
        return '7';
      case 'เขตสุขภาพที่ 8':
        return '8';
      case 'เขตสุขภาพที่ 9':
        return '9';
      case 'เขตสุขภาพที่ 10':
        return '10';
      case 'เขตสุขภาพที่ 11':
        return '11';
      case 'เขตสุขภาพที่ 12':
        return '12';
      case 'เขตสุขภาพที่ 13':
        return '13';
      default:
        return '';
    }
  }

  Future<void> fetchRegionChartData({
    required String? year,
    required String? regionName,
    required String? province,
    required String? district,
    required String? hospital,
  }) async {
    final url = Uri.parse('$baseurl/api/ncd_detail/region');

    final int fiscalYear = int.tryParse(year ?? '') ?? 0;
    print('[DEBUG] hospital : $hospital');

    String fhospital;
    if (check_access_level == '5') {
      fhospital = (hospital != null && hospital.isNotEmpty) ? hospital : '';
    } else {
      fhospital = hospital ?? queryhcodeList;
    }

    final List<String> hospitalList = fhospital.isEmpty
        ? []
        : fhospital
            .split(',')
            .map((e) {
              final match = RegExp(r'\((\d+)\)').firstMatch(e);
              // ถ้าหาเจอในวงเล็บ ให้เอาตัวเลขจากวงเล็บ
              if (match != null) {
                return match.group(1) ?? '';
              }
              // ถ้าไม่เจอวงเล็บ ให้เอา string ทั้งหมด (สำหรับกรณี "99999")
              final trimmed = e.trim();
              return trimmed;
            })
            .where((e) => e.isNotEmpty)
            .toList();

    final String regionId = _getRegionId(regionName);

    final List<String> provinceList = (province ?? '').isEmpty ? [] : province!.split(',').map((e) => e.trim()).toList();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiToken', // หรือใส่เป็นตัวแปร
    };
    late var body;
    final fcdcode = '0052';
    if (check_access_level == '5') {
      if (checkregionfilter == 4) {
        if (checkfilter == 0) {
          body = jsonEncode({
            'cd_code': fcdcode,
            'level': check_access_level,
            'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
            'region_id': regionId == ''
                ? null
                : [
                    regionId
                  ],
            'organization_code': null,
            'org_province_code': []
          });
        } else if (checkfilter == 1) {
          body = jsonEncode({
            'cd_code': fcdcode,
            'level': check_access_level,
            'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
            'region_id': regionId == ''
                ? null
                : [
                    regionId
                  ],
            'organization_code': null,
            'org_province_code': provinceList
          });
        }
      } else {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code':
              // [],
              hospitalList.isEmpty ? null : hospitalList,
          'org_province_code': provinceList
        });
      }
    }
    if (check_access_level == '3') {
      if (checkfilter == 0) {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code': null,
          'org_province_code': provinceList
        });
      } else if (checkfilter == 1) {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code': null,
          'org_province_code': provinceList
        });
      } else if (checkfilter == 2) {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code': hospitalList.isEmpty ? null : hospitalList,
          'org_province_code': provinceList
        });
      }
    } else {
      body = jsonEncode({
        'cd_code': fcdcode,
        'level': check_access_level,
        'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
        'region_id': regionId == ''
            ? null
            : [
                regionId
              ],
        'organization_code':
            // [],
            hospitalList.isEmpty ? null : hospitalList,
        // (check_access_level == '1' || check_access_level == '2') ? (fhospital.isEmpty ? null : fhospital) : (hospitalList.isEmpty ? null : hospitalList),
        'org_province_code': provinceList
      });
      //--------4321
      // if (checkfilter == 0) {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': null,
      //     'org_province_code': provinceList
      //   });
      // } else if (checkfilter == 1) {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': null,
      //     'org_province_code': provinceList
      //   });
      // } else if (checkfilter == 2) {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': hospitalList.isEmpty ? null : hospitalList,
      //     'org_province_code': provinceList
      //   });
      // } else {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': hospitalList.isEmpty ? null : hospitalList,
      //     'org_province_code': null
      //   });
      // }
    }

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));

      // if (check_access_level == '5') {
      //   convertedList = [];

      //   for (var item in jsonList) {
      //     final List provinceObjects = item['org_province_codes'] ?? [];

      //     for (var p in provinceObjects) {
      //       final String code = p['code'] ?? '';
      //       final int value = (p['count'] ?? 0).toInt();

      //       final map = {
      //         'provinceCode': code,
      //         'value': value,
      //       };

      //       convertedList.add(map);
      //       print('[DEBUG] convertedList (L5): $map');
      //     }
      //   }
      // } else {
      //   convertedList = jsonList.map<Map<String, dynamic>>((item) {
      //     final map = {
      //       'provinceCode': item['org_province_code'] ?? '',
      //       'value': item['count'] ?? 0,
      //     };
      //     print('[DEBUG] convertedList (L<5): $map');
      //     return map;
      //   }).toList();
      // }

      // countTotalRegion = 0;
      // convertedHospitalList.clear();

      // for (var item in jsonList) {
      //   final List orgCodes = item['organization_codes'] ?? [];

      //   for (var h in orgCodes) {
      //     final String hcode = h['code'] ?? '';
      //     final int value = (h['count'] ?? 0).toInt();

      //     convertedHospitalList.add({
      //       'hcode': hcode,
      //       'value': value,
      //     });

      //     countTotalRegion += value;
      //   }
      // }
      if (check_access_level == '1' || check_access_level == '2') {
        // สำหรับ access level 1 และ 2 - JSON format: [{"organization_code": "99999", "count": 18}]
        convertedList = [];
        convertedHospitalList.clear();
        countTotalRegion = 0;

        for (var item in jsonList) {
          final String orgCode = item['organization_code'] ?? '';
          final int count = (item['count'] ?? 0).toInt();

          // เพิ่มลงใน convertedHospitalList
          convertedHospitalList.add({
            'hcode': orgCode,
            'value': count,
          });

          countTotalRegion += count;

          print('[DEBUG] convertedHospitalList (L1-2): hcode=$orgCode, value=$count');
        }

        // สำหรับ access level 1 และ 2 อาจไม่มีข้อมูล province แยก
        // ถ้าต้องการให้ convertedList มีข้อมูล ให้ใส่ข้อมูลเดียวกัน
        // convertedList = convertedHospitalList.map((item) => {
        //   'provinceCode': item['hcode'],
        //   'value': item['value'],
        // }).toList();
      } else if (check_access_level == '5') {
        convertedList = [];

        for (var item in jsonList) {
          final List provinceObjects = item['org_province_codes'] ?? [];

          for (var p in provinceObjects) {
            final String code = p['code'] ?? '';
            final int value = (p['count'] ?? 0).toInt();

            final map = {
              'provinceCode': code,
              'value': value,
            };

            convertedList.add(map);
            print('[DEBUG] convertedList (L5): $map');
          }
        }

        countTotalRegion = 0;
        convertedHospitalList.clear();

        for (var item in jsonList) {
          final List orgCodes = item['organization_codes'] ?? [];

          for (var h in orgCodes) {
            final String hcode = h['code'] ?? '';
            final int value = (h['count'] ?? 0).toInt();

            convertedHospitalList.add({
              'hcode': hcode,
              'value': value,
            });

            countTotalRegion += value;
          }
        }
      } else {
        // สำหรับ access level อื่นๆ (3, 4, etc.)
        convertedList = jsonList.map<Map<String, dynamic>>((item) {
          final map = {
            'provinceCode': item['org_province_code'] ?? '',
            'value': item['count'] ?? 0,
          };
          print('[DEBUG] convertedList (L<5): $map');
          return map;
        }).toList();

        countTotalRegion = 0;
        convertedHospitalList.clear();

        for (var item in jsonList) {
          final List orgCodes = item['organization_codes'] ?? [];

          for (var h in orgCodes) {
            final String hcode = h['code'] ?? '';
            final int value = (h['count'] ?? 0).toInt();

            convertedHospitalList.add({
              'hcode': hcode,
              'value': value,
            });

            countTotalRegion += value;
          }
        }
      }

      if (check_access_level == '5') {
        if (checkregionfilter == 4) {
          print('jsonList $jsonList');
          setState(() {
            // reset ก่อน
            countRegion1 = countRegion2 = countRegion3 = countRegion4 = countRegion5 = countRegion6 = countRegion7 = countRegion8 = countRegion9 = countRegion10 = countRegion11 = countRegion12 = countRegion13 = 0;

            for (final item in jsonList) {
              final int regionId = item['region_id'] ?? 0;
              final int count = item['count'] ?? 0;
              switch (regionId) {
                case 1:
                  countRegion1 = count;
                  break;
                case 2:
                  countRegion2 = count;
                  break;
                case 3:
                  countRegion3 = count;
                  break;
                case 4:
                  countRegion4 = count;
                  break;
                case 5:
                  countRegion5 = count;
                  break;
                case 6:
                  countRegion6 = count;
                  break;
                case 7:
                  countRegion7 = count;
                  break;
                case 8:
                  countRegion8 = count;
                  break;
                case 9:
                  countRegion9 = count;
                  break;
                case 10:
                  countRegion10 = count;
                  break;
                case 11:
                  countRegion11 = count;
                  break;
                case 12:
                  countRegion12 = count;
                  break;
                case 13:
                  countRegion13 = count;
                  break;
              }
            }
            countTotalRegion = countRegion1 + countRegion2 + countRegion3 + countRegion4 + countRegion5 + countRegion6 + countRegion7 + countRegion8 + countRegion9 + countRegion10 + countRegion11 + countRegion12 + countRegion13;
          });
        }
      }

      setState(() {});
    }
  }

  // Future<String?> getProvinceFilter() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final accessLevel = prefs.getString('check_access_level') ?? '1';

  //   if (accessLevel == '5') {
  //     return null; // ไม่ต้องกรองจังหวัด
  //   }

  //   final provinceCodes =
  //       //  [
  //       //   '10',
  //       //   '13'
  //       // ];
  //       prefs.getStringList('org_province_codes') ?? [];
  //   if (provinceCodes.isEmpty) return null;

  //   return provinceCodes.join(','); // เช่น "10,12,96"
  // }

  Future<void> fetchHighBloodPressureByAge({
    required String? year,
    required String? regionName,
    required String? province,
    required String? district,
    required String? hospital,
  }) async {
    final url = Uri.parse('$baseurl/api/ncd_detail/age');

    final int fiscalYear = int.tryParse(year ?? '') ?? 0;

    String fhospital;
    if (check_access_level == '5') {
      // ใช้เฉพาะกรณีที่เลือกเอง
      fhospital = (hospital != null && hospital.isNotEmpty) ? hospital : '';
    } else {
      // สิทธิ์อื่น fallback ไปใช้ queryhcodeList
      fhospital = hospital ?? queryhcodeList;
    }
    // final List<String> hospitalList = fhospital.isEmpty ? [] : fhospital.split(',').map((e) => RegExp(r'\((\d+)\)').firstMatch(e)?.group(1) ?? '').where((e) => e.isNotEmpty).toList();
    final List<String> hospitalList = fhospital.isEmpty
        ? []
        : fhospital
            .split(',')
            .map((e) {
              final match = RegExp(r'\((\d+)\)').firstMatch(e);
              // ถ้าหาเจอในวงเล็บ ให้เอาตัวเลขจากวงเล็บ
              if (match != null) {
                return match.group(1) ?? '';
              }
              // ถ้าไม่เจอวงเล็บ ให้เอา string ทั้งหมด (สำหรับกรณี "99999")
              final trimmed = e.trim();
              return trimmed;
            })
            .where((e) => e.isNotEmpty)
            .toList();

    print('[DEBUG] hospital f : $fhospital');
    final String fprovince = province ?? orgProvinceCodesList;
    final String regionId = _getRegionId(regionName);

    // final List<String> hospitalList = fhospital.split(',').map((e) => e.trim()).toList();
    // final provinceCode = await getProvinceFilter();
    final List<String> provinceList = (province ?? '').isEmpty ? [] : province!.split(',').map((e) => e.trim()).toList();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiToken', // หรือใส่เป็นตัวแปร
    };
    late var body;
    final fcdcode = '0052';
    if (check_access_level == '5') {
      if (checkregionfilter == 4) {
        if (checkfilter == 0) {
          body = jsonEncode({
            'cd_code': fcdcode,
            'level': check_access_level,
            'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
            'region_id': regionId == ''
                ? null
                : [
                    regionId
                  ],
            'organization_code': null,
            'org_province_code': []
          });
        } else if (checkfilter == 1) {
          body = jsonEncode({
            'cd_code': fcdcode,
            'level': check_access_level,
            'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
            'region_id': regionId == ''
                ? null
                : [
                    regionId
                  ],
            'organization_code': null,
            'org_province_code': provinceList
          });
        }
      } else {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code':
              // [],
              hospitalList.isEmpty ? null : hospitalList,
          'org_province_code': provinceList
        });
      }
    }
    if (check_access_level == '3') {
      if (checkfilter == 0) {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code': null,
          'org_province_code': provinceList
        });
      } else if (checkfilter == 1) {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code': null,
          'org_province_code': provinceList
        });
      } else if (checkfilter == 2) {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code': hospitalList.isEmpty ? null : hospitalList,
          'org_province_code': provinceList
        });
      }
    } else {
      body = jsonEncode({
        'cd_code': fcdcode,
        'level': check_access_level,
        'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
        'region_id': regionId == ''
            ? null
            : [
                regionId
              ],
        'organization_code':
            // [],
            hospitalList.isEmpty ? null : hospitalList,
        // (check_access_level == '1' || check_access_level == '2') ? (fhospital.isEmpty ? null : fhospital) : (hospitalList.isEmpty ? null : hospitalList),
        'org_province_code': provinceList
      });
      //--------4321
      // if (checkfilter == 0) {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': null,
      //     'org_province_code': provinceList
      //   });
      // } else if (checkfilter == 1) {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': null,
      //     'org_province_code': provinceList
      //   });
      // } else if (checkfilter == 2) {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': hospitalList.isEmpty ? null : hospitalList,
      //     'org_province_code': provinceList
      //   });
      // } else {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': hospitalList.isEmpty ? null : hospitalList,
      //     'org_province_code': null
      //   });
      // }
    }

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        totalage = (age0_4 = age5_11 = age12_17 = age18_59 = age60plus = 0) as int;
        for (final item in jsonList) {
          final String age = item['age_range'];
          final int count = item['count'] ?? 0;

          // if (orgProvinceCodesList != '') {
          if (age.contains('0-4')) {
            age0_4 += count;
          } else if (age.contains('5-11')) {
            age5_11 += count;
          } else if (age.contains('12-17')) {
            age12_17 += count;
          } else if (age.contains('18-59')) {
            age18_59 += count;
          } else if (age.contains('60')) {
            age60plus += count;
          }
          // }
        }
        totalage = (age0_4 + age5_11 + age12_17 + age18_59 + age60plus) as int;
      });
    } else {
      debugPrint('❌ Failed to load data: ${response.statusCode}');
    }
  }

  Future<void> fetchHighBloodPressureByGender({
    required String? year,
    required String? regionName,
    required String? province,
    required String? district,
    required String? hospital,
  }) async {
    // final int fiscalYear = int.tryParse(year ?? '') ?? 0;
    // final String fprovince = province ?? '';
    // final String fhospital = province ?? '';
    // final String regionId = _getRegionId(regionName);
    final url = Uri.parse('$baseurl/api/ncd_detail/gender');

    final int fiscalYear = int.tryParse(year ?? '') ?? 0;
    // print('[DEBUG] hospital : $hospital');
    // final String fhospital = hospital ?? queryhcodeList;
    // print('[DEBUG] hospital f : $fhospital');
    // final String regionId = _getRegionId(regionName);

    // final List<String> hospitalList = fhospital.split(',').map((e) => e.trim()).toList();
    // final List<String> provinceList = (province ?? '').isEmpty ? [] : province!.split(',').map((e) => e.trim()).toList();

    // 2. ถ้าเป็น level 5 → ไม่ใช้ queryhcodeList (เพราะจะเห็นทั้งหมด) ยกเว้นเลือกเอง
    // final String fhospital = hospital ?? queryhcodeList;
    String fhospital;
    if (check_access_level == '5') {
      // ใช้เฉพาะกรณีที่เลือกเอง
      fhospital = (hospital != null && hospital.isNotEmpty) ? hospital : '';
    } else {
      // สิทธิ์อื่น fallback ไปใช้ queryhcodeList
      fhospital = hospital ?? queryhcodeList;
    }

// 3. สร้าง hospitalList
    final List<String> hospitalList = fhospital.isEmpty
        ? []
        : fhospital
            .split(',')
            .map((e) {
              final match = RegExp(r'\((\d+)\)').firstMatch(e);
              // ถ้าหาเจอในวงเล็บ ให้เอาตัวเลขจากวงเล็บ
              if (match != null) {
                return match.group(1) ?? '';
              }
              // ถ้าไม่เจอวงเล็บ ให้เอา string ทั้งหมด (สำหรับกรณี "99999")
              final trimmed = e.trim();
              return trimmed;
            })
            .where((e) => e.isNotEmpty)
            .toList();

    print('[DEBUG] hospital f : $fhospital');
    final String fprovince = province ?? orgProvinceCodesList;
    final String regionId = _getRegionId(regionName);

    // final List<String> hospitalList = fhospital.split(',').map((e) => e.trim()).toList();
    // final provinceCode = await getProvinceFilter();
    final List<String> provinceList = (province ?? '').isEmpty ? [] : province!.split(',').map((e) => e.trim()).toList();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiToken', // หรือใส่เป็นตัวแปร
    };
    late var body;
    final fcdcode = '0052';
    if (check_access_level == '5') {
      if (checkregionfilter == 4) {
        if (checkfilter == 0) {
          body = jsonEncode({
            'cd_code': fcdcode,
            'level': check_access_level,
            'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
            'region_id': regionId == ''
                ? null
                : [
                    regionId
                  ],
            'organization_code': null,
            'org_province_code': []
          });
        } else if (checkfilter == 1) {
          body = jsonEncode({
            'cd_code': fcdcode,
            'level': check_access_level,
            'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
            'region_id': regionId == ''
                ? null
                : [
                    regionId
                  ],
            'organization_code': null,
            'org_province_code': provinceList
          });
        }
      } else {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code':
              // [],
              hospitalList.isEmpty ? null : hospitalList,
          'org_province_code': provinceList
        });
      }
    }
    if (check_access_level == '3') {
      if (checkfilter == 0) {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code': null,
          'org_province_code': provinceList
        });
      } else if (checkfilter == 1) {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code': null,
          'org_province_code': provinceList
        });
      } else if (checkfilter == 2) {
        body = jsonEncode({
          'cd_code': fcdcode,
          'level': check_access_level,
          'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
          'region_id': regionId == ''
              ? null
              : [
                  regionId
                ],
          'organization_code': hospitalList.isEmpty ? null : hospitalList,
          'org_province_code': provinceList
        });
      }
    } else {
      body = jsonEncode({
        'cd_code': fcdcode,
        'level': check_access_level,
        'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
        'region_id': regionId == ''
            ? null
            : [
                regionId
              ],
        'organization_code':
            // [],
            hospitalList.isEmpty ? null : hospitalList,
        // (check_access_level == '1' || check_access_level == '2') ? (fhospital.isEmpty ? null : fhospital) : (hospitalList.isEmpty ? null : hospitalList),
        'org_province_code': provinceList
      });
      //--------4321
      // if (checkfilter == 0) {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': null,
      //     'org_province_code': provinceList
      //   });
      // } else if (checkfilter == 1) {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': null,
      //     'org_province_code': provinceList
      //   });
      // } else if (checkfilter == 2) {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': hospitalList.isEmpty ? null : hospitalList,
      //     'org_province_code': provinceList
      //   });
      // } else {
      //   body = jsonEncode({
      //     'cd_code': fcdcode,
      //     'level': check_access_level,
      //     'fiscal_year': fiscalYear == 0 ? null : fiscalYear,
      //     'region_id': regionId == ''
      //         ? null
      //         : [
      //             regionId
      //           ],
      //     'organization_code': hospitalList.isEmpty ? null : hospitalList,
      //     'org_province_code': null
      //   });
      // }
    }

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(response.bodyBytes));
        debugPrint('[DEBUG] gender response: $jsonMap'); // เพิ่ม debug ตรงนี้
        setState(() {
          totalgender = male = female = 0;
          // if (orgProvinceCodesList != '') {
          male = jsonMap['male'] ?? 0;
          female = jsonMap['female'] ?? 0;
          totalgender = male + female;
          // }
          debugPrint('[DEBUG] male: $male, female: $female, totalgender: $totalgender'); // เพิ่ม debug ตรงนี้
          // ตัวอย่างการสร้าง chart data
        });
      } else {
        debugPrint('❌ Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('🚫 Exception: $e');
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

  Future<String> getCheckAccessLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('check_access_level') ?? '1';
  }

  Future<List<String>> _getOrgProvinceCodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('org_province_codes') ?? [];
  }

  Future<List<String>> _gethcodelist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('hcodelist') ?? [];
  }

  Future<List<String>> _getrowcodeslist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('org_province_codes') ?? [];
  }

  void _loadLoginData() async {
    userLogin = await _getUserLogin();
    hospitalCode = await _getHospitalCode();
    hospitalName = await _getHospitalName();
    scopeList = await _getScopeList();
    cid = await _getcid();
    check_access_level =
        // '5';
        await getCheckAccessLevel();
    // if (check_access_level != '5') {
    //   checkfilter = 0;
    // }

    // await _getcheck_access_level();
    // final List<String> rowcodes = await _getrowcodeslist();
    final List<String> rawCodes = await _getrowcodeslist();

    //     [
    //   '10',
    //   '13'
    // ];
    print('[DEBUG] rawCodes: $rawCodes');
    orgProvinceCodes = rawCodes.map((e) => e.toString()).toList();

    // await loadHcodeListByAccessLevel();
    // hcodeList = await loadHcodeListByAccessLevel();
    hcodeList = await _gethcodelist();
    //   '99999',
    //   '12345'
    // ];
    // await _gethcodelist();
    print('[DEBUG] hcodeList=$hcodeList');
    queryhcodeList = hcodeList.join(','); // เช่นได้ '99999'

    print('[DEBUG] orgProvinceCodes  =$orgProvinceCodes');
    orgProvinceCodesList = orgProvinceCodes.join(','); // เช่นได้ '99999'
    print('[DEBUG] orgProvinceCodesList  =$orgProvinceCodesList');

    // print('User Login: $userLogin');
    setState(() {});
    // print('Hospital Code: $hospitalCode');
    // print('Hospital Name: $hospitalName');
    // print('Scope List: $scopeList');

    // คุณสามารถใช้ค่าที่ดึงมาเพื่อทำสิ่งต่างๆ ตามที่คุณต้องการ
  }

  @override
  Widget build(BuildContext context) {
    print('[DEBUG] countRegion13=$countRegion13');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: AlignmentDirectional(0.0, -1.0),
                      image: Image.asset(
                        'assets/images/App_BG.png',
                      ).image,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        0,
                        24.0,
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        wrapWithModel(
                          model: _model.headerModel,
                          updateCallback: () => safeSetState(() {}),
                          child: Hero(
                            tag: 'AppLogo',
                            transitionOnUserGestures: true,
                            child: Material(
                              color: Colors.transparent,
                              child: HeaderWidget(
                                username: '$userLogin',
                                // 'ทดสอบ สมมติฐาน',
                                position: '$scopeList',
                                // 'นักวิชาการคอมพิวเตอร์',
                                organiazation: '$hospitalName ',
                                // 'bms ทดสอบ',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(
                              0xCDFFFFFF,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 24.0,
                                color: Color(
                                  0x1E666666,
                                ),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(
                              18.0,
                            ),
                            border: Border.all(
                              color: FlutterFlowTheme.of(
                                context,
                              ).secondaryBackground,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xCDFFFFFF,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 24.0,
                                              color: Color(
                                                0x1E666666,
                                              ),
                                              offset: Offset(
                                                0.0,
                                                2.0,
                                              ),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                            100.0,
                                          ),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).secondaryBackground,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            4.0,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  context.pushNamed(
                                                    DashboardOverviewWidget.routeName,
                                                    extra: <String, dynamic>{
                                                      kTransitionInfoKey: TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType: PageTransitionType.fade,
                                                        duration: Duration(
                                                          milliseconds: 300,
                                                        ),
                                                      ),
                                                    },
                                                  );
                                                },
                                                text: 'แดชบอร์ด',
                                                icon: Icon(
                                                  Icons.dashboard_rounded,
                                                  size: 16.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 36.0,
                                                  padding: EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                                  iconColor: FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryText,
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryBackground,
                                                  textStyle: FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                        fontFamily: 'IBM Plex Sans Thai Looped',
                                                        letterSpacing: 0.0,
                                                      ),
                                                  elevation: 0.0,
                                                  borderRadius: BorderRadius.circular(
                                                    24.0,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_right_rounded,
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).primaryText,
                                                size: 24.0,
                                              ),
                                              Container(
                                                height: 36.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                                  borderRadius: BorderRadius.circular(
                                                    100.0,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'โรคหลอดเลือดสมอง',
                                                        style: FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.override(
                                                              fontFamily: 'IBM Plex Sans Thai Looped',
                                                              color: FlutterFlowTheme.of(
                                                                context,
                                                              ).secondaryBackground,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                      ),
                                                    ].divide(
                                                      SizedBox(
                                                        width: 8.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].divide(
                                              SizedBox(
                                                width: 4.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(
                                //   height: 4,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Sidebar ด้านซ้าย
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context).size.height * 1.30,
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xCDFFFFFF,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 13.0,
                                                color: Color(
                                                  0x1E666666,
                                                ),
                                                offset: Offset(
                                                  0.0,
                                                  2.0,
                                                ),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(
                                              18.0,
                                            ),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(
                                                context,
                                              ).secondaryBackground,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SingleChildScrollView(
                                              physics: const NeverScrollableScrollPhysics(),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            width: 24.0,
                                                            height: 24.0,
                                                            decoration: BoxDecoration(
                                                              color: FlutterFlowTheme.of(
                                                                context,
                                                              ).secondaryBackground,
                                                              borderRadius: BorderRadius.circular(
                                                                8.0,
                                                              ),
                                                              border: Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                  context,
                                                                ).alternate,
                                                              ),
                                                            ),
                                                            alignment: AlignmentDirectional(
                                                              0.0,
                                                              0.0,
                                                            ),
                                                            child: Icon(
                                                              Icons.filter_list_alt,
                                                              color: FlutterFlowTheme.of(
                                                                context,
                                                              ).primary,
                                                              size: 16.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            'กรองข้อมูล',
                                                            style: FlutterFlowTheme.of(
                                                              context,
                                                            ).titleSmall.override(
                                                                  fontFamily: 'IBM Plex Sans Thai Looped',
                                                                  letterSpacing: 0.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                          ),
                                                        ].divide(
                                                          SizedBox(
                                                            width: 8.0,
                                                          ),
                                                        ),
                                                      ),
                                                      FFButtonWidget(
                                                        onPressed: () async {
                                                          setState(() {
                                                            _model.dropDownValue1 = null;
                                                            _model.dropDownValueController1?.reset();
                                                            _model.dropDownValue2 = null;
                                                            _model.dropDownValueController2?.reset();
                                                            _model.dropDownValue3 = null;
                                                            _model.dropDownValueController3?.reset();
                                                            _model.dropDownValue4 = null;
                                                            _model.dropDownValueController4?.reset();
                                                            _model.dropDownValue5 = null;
                                                            _model.dropDownValueController5?.reset();
                                                            checkfilter = 0;
                                                            if (check_access_level == '5') {
                                                              checkregionfilter = 4;
                                                            } else {
                                                              checkregionfilter = 5;
                                                            }
                                                          });

                                                          await fetchRegionChartData(
                                                            year: _model.dropDownValue1,
                                                            regionName: _model.dropDownValue2,
                                                            province: orgProvinceCodesList,
                                                            district: _model.dropDownValue4,
                                                            hospital: _model.dropDownValue5,
                                                          );
                                                          await fetchHighBloodPressureByAge(
                                                            year: _model.dropDownValue1,
                                                            regionName: _model.dropDownValue2,
                                                            province: orgProvinceCodesList,
                                                            district: _model.dropDownValue4,
                                                            hospital: _model.dropDownValue5,
                                                          );
                                                          await fetchHighBloodPressureByGender(
                                                            year: _model.dropDownValue1,
                                                            regionName: _model.dropDownValue2,
                                                            province: orgProvinceCodesList,
                                                            district: _model.dropDownValue4,
                                                            hospital: _model.dropDownValue5,
                                                          );

                                                          debugPrint('🎯 รีเซ็ตค่า filter ทั้งหมดเรียบร้อยแล้ว');
                                                          print('checkfilter checkregionfilter = $checkfilter $checkregionfilter');
                                                        },
                                                        text: 'รีเซ็ต',
                                                        icon: Icon(
                                                          Icons.restore_rounded,
                                                          size: 16.0,
                                                        ),
                                                        options: FFButtonOptions(
                                                          height: 26.0,
                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                            8.0,
                                                            0.0,
                                                            8.0,
                                                            0.0,
                                                          ),
                                                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                            0.0,
                                                            0.0,
                                                            0.0,
                                                            0.0,
                                                          ),
                                                          color: FlutterFlowTheme.of(
                                                            context,
                                                          ).primary,
                                                          textStyle: FlutterFlowTheme.of(
                                                            context,
                                                          ).labelSmall.override(
                                                                fontFamily: 'IBM Plex Sans Thai Looped',
                                                                color: FlutterFlowTheme.of(
                                                                  context,
                                                                ).secondaryBackground,
                                                                letterSpacing: 0.0,
                                                              ),
                                                          elevation: 0.0,
                                                          borderRadius: BorderRadius.circular(
                                                            8.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  (check_access_level != '5')
                                                      ? SizedBox(
                                                          height: 0,
                                                        )
                                                      : Container(
                                                          width: double.infinity,
                                                          decoration: BoxDecoration(
                                                            color: Color(
                                                              0xCDFFFFFF,
                                                            ),
                                                            borderRadius: BorderRadius.circular(
                                                              24.0,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme.of(
                                                                context,
                                                              ).secondaryBackground,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.all(
                                                              12.0,
                                                            ),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      width: 24.0,
                                                                      height: 24.0,
                                                                      decoration: BoxDecoration(
                                                                        color: Color(
                                                                          0xFF00855B,
                                                                        ),
                                                                        shape: BoxShape.circle,
                                                                      ),
                                                                      child: Icon(
                                                                        Icons.calendar_month,
                                                                        color: FlutterFlowTheme.of(
                                                                          context,
                                                                        ).secondaryBackground,
                                                                        size: 14.0,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'ปีงบประมาณ',
                                                                      style: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).bodyMedium.override(
                                                                            fontFamily: 'IBM Plex Sans Thai Looped',
                                                                            color: FlutterFlowTheme.of(
                                                                              context,
                                                                            ).secondaryText,
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                    ),
                                                                  ].divide(
                                                                    SizedBox(
                                                                      width: 8.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DropdownButtonHideUnderline(
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).secondaryBackground,
                                                                      borderRadius: BorderRadius.circular(
                                                                        14.0,
                                                                      ),
                                                                      border: Border.all(
                                                                        color: FlutterFlowTheme.of(
                                                                          context,
                                                                        ).alternate,
                                                                      ),
                                                                    ),
                                                                    constraints: BoxConstraints(
                                                                      maxHeight: 200, // <-- กำหนด max height
                                                                    ),
                                                                    child: FlutterFlowDropDown<String>(
                                                                      controller: _model.dropDownValueController1 ??= FormFieldController<String>(
                                                                        _model.dropDownValue1 ??= 'ทั้งหมด',
                                                                      ),
                                                                      // options: [
                                                                      //   'ทั้งหมด',
                                                                      //   '2568',
                                                                      //   '2567',
                                                                      //   '2566',
                                                                      //   '2565',
                                                                      // ],
                                                                      options: [
                                                                        'ทั้งหมด',
                                                                        ...List.generate(10, (index) => (DateTime.now().year + 543 - index).toString()),
                                                                      ],

                                                                      onChanged: (
                                                                        val,
                                                                      ) =>
                                                                          safeSetState(
                                                                        () => _model.dropDownValue1 = val,
                                                                      ),

                                                                      searchHintTextStyle: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).labelMedium.override(
                                                                            fontFamily: 'IBM Plex Sans Thai Looped',
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                      searchTextStyle: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).bodyMedium.override(
                                                                            fontFamily: 'IBM Plex Sans Thai Looped',
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).bodyLarge.override(
                                                                            fontFamily: 'IBM Plex Sans Thai Looped',
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                      hintText: 'ทั้งหมด',
                                                                      searchHintText: 'ค้นหาปี',
                                                                      icon: Icon(
                                                                        Icons.arrow_drop_down_rounded,
                                                                        color: FlutterFlowTheme.of(
                                                                          context,
                                                                        ).primaryText,
                                                                        size: 24.0,
                                                                      ),
                                                                      elevation: 2.0,
                                                                      borderColor: Colors.transparent,
                                                                      borderWidth: 0.0,
                                                                      borderRadius: 8.0,
                                                                      margin: EdgeInsetsDirectional.fromSTEB(
                                                                        8.0,
                                                                        0.0,
                                                                        8.0,
                                                                        0.0,
                                                                      ),
                                                                      hidesUnderline: true,
                                                                      isOverButton: false,
                                                                      isSearchable: true,
                                                                      isMultiSelect: false, dropdownHeight: 150,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ].divide(
                                                                SizedBox(
                                                                  height: 4.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  (check_access_level != '5')
                                                      ? SizedBox(
                                                          height: 0,
                                                        )
                                                      : Container(
                                                          width: double.infinity,
                                                          decoration: BoxDecoration(
                                                            color: Color(
                                                              0xCDFFFFFF,
                                                            ),
                                                            borderRadius: BorderRadius.circular(
                                                              24.0,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme.of(
                                                                context,
                                                              ).secondaryBackground,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.all(
                                                              12.0,
                                                            ),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      width: 24.0,
                                                                      height: 24.0,
                                                                      decoration: BoxDecoration(
                                                                        color: Color(
                                                                          0xFFED007F,
                                                                        ),
                                                                        shape: BoxShape.circle,
                                                                      ),
                                                                      child: Icon(
                                                                        Icons.monitor_heart_outlined,
                                                                        color: FlutterFlowTheme.of(
                                                                          context,
                                                                        ).secondaryBackground,
                                                                        size: 14.0,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'เขตสุขภาพ',
                                                                      style: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).labelMedium.override(
                                                                            fontFamily: 'IBM Plex Sans Thai Looped',
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                    ),
                                                                  ].divide(
                                                                    SizedBox(
                                                                      width: 8.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                      context,
                                                                    ).secondaryBackground,
                                                                    borderRadius: BorderRadius.circular(
                                                                      14.0,
                                                                    ),
                                                                    border: Border.all(
                                                                      color: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).alternate,
                                                                    ),
                                                                  ),
                                                                  child: FlutterFlowDropDown<String>(
                                                                    controller: _model.dropDownValueController2 ??= FormFieldController<String>(
                                                                      null,
                                                                    ),
                                                                    options: [
                                                                      'ทั้งหมด',
                                                                      'เขตสุขภาพที่ 1',
                                                                      'เขตสุขภาพที่ 2',
                                                                      'เขตสุขภาพที่ 3',
                                                                      'เขตสุขภาพที่ 4',
                                                                      'เขตสุขภาพที่ 5',
                                                                      'เขตสุขภาพที่ 6',
                                                                      'เขตสุขภาพที่ 7',
                                                                      'เขตสุขภาพที่ 8',
                                                                      'เขตสุขภาพที่ 9',
                                                                      'เขตสุขภาพที่ 10',
                                                                      'เขตสุขภาพที่ 11',
                                                                      'เขตสุขภาพที่ 12',
                                                                      'เขตสุขภาพที่ 13',
                                                                    ],
                                                                    // onChanged: (
                                                                    //   val,
                                                                    // )=>
                                                                    //     safeSetState(
                                                                    //   () => _model.dropDownValue2 = val,
                                                                    // ),
                                                                    onChanged: (val) async {
                                                                      _model.dropDownValue5 = null;
                                                                      _model.dropDownValue3 = null;
                                                                      setState(() => _model.dropDownValue2 = val);

                                                                      final accessLevel = check_access_level;
                                                                      // (await SharedPreferences.getInstance()).getString('check_access_level') ?? '1';

                                                                      if (accessLevel == '5' && val != null && healthRegionToProvinceCodes.containsKey(val)) {
                                                                        final List<String> codes = healthRegionToProvinceCodes[val]!;
                                                                        final filteredProvinces = provinceCodeMap.entries.where((entry) => codes.contains(entry.value)).map((entry) => entry.key).toList()..sort();

                                                                        setState(() {
                                                                          provinceOptions = [
                                                                            'ทั้งหมด',
                                                                            ...filteredProvinces
                                                                          ];
                                                                        });
                                                                      } else {
                                                                        await loadProvinces(); // เวลอื่น ๆ ทำตาม default
                                                                      }
                                                                    },

                                                                    searchHintTextStyle: FlutterFlowTheme.of(
                                                                      context,
                                                                    ).labelMedium.override(
                                                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                                                          letterSpacing: 0.0,
                                                                        ),
                                                                    searchTextStyle: FlutterFlowTheme.of(
                                                                      context,
                                                                    ).bodyMedium.override(
                                                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                                                          letterSpacing: 0.0,
                                                                        ),
                                                                    textStyle: FlutterFlowTheme.of(
                                                                      context,
                                                                    ).bodyLarge.override(
                                                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                                                          letterSpacing: 0.0,
                                                                        ),
                                                                    hintText: '---กรุณาเลือก---',
                                                                    searchHintText: 'ค้นหาเขต',
                                                                    icon: Icon(
                                                                      Icons.arrow_drop_down_rounded,
                                                                      color: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).primaryText,
                                                                      size: 24.0,
                                                                    ),
                                                                    elevation: 2.0,
                                                                    borderColor: Colors.transparent,
                                                                    borderWidth: 0.0,
                                                                    borderRadius: 8.0,
                                                                    margin: EdgeInsetsDirectional.fromSTEB(
                                                                      8.0,
                                                                      0.0,
                                                                      8.0,
                                                                      0.0,
                                                                    ),
                                                                    hidesUnderline: true,
                                                                    isOverButton: false,
                                                                    isSearchable: true,
                                                                    isMultiSelect: false,
                                                                    dropdownHeight: 300,
                                                                    maxHeight: 300,
                                                                  ),
                                                                ),
                                                              ].divide(
                                                                SizedBox(
                                                                  height: 4.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                        0xCDFFFFFF,
                                                      ),
                                                      borderRadius: BorderRadius.circular(
                                                        24.0,
                                                      ),
                                                      border: Border.all(
                                                        color: FlutterFlowTheme.of(
                                                          context,
                                                        ).secondaryBackground,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        12.0,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width: 24.0,
                                                                height: 24.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(
                                                                    0xFF1596E3,
                                                                  ),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: Icon(
                                                                  Icons.map_outlined,
                                                                  color: FlutterFlowTheme.of(
                                                                    context,
                                                                  ).secondaryBackground,
                                                                  size: 14.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                'จังหวัด',
                                                                style: FlutterFlowTheme.of(
                                                                  context,
                                                                ).labelMedium.override(
                                                                      fontFamily: 'IBM Plex Sans Thai Looped',
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(
                                                              SizedBox(
                                                                width: 8.0,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                              decoration: BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                  context,
                                                                ).secondaryBackground,
                                                                borderRadius: BorderRadius.circular(
                                                                  14.0,
                                                                ),
                                                                border: Border.all(
                                                                  color: FlutterFlowTheme.of(
                                                                    context,
                                                                  ).alternate,
                                                                ),
                                                              ),
                                                              child: FlutterFlowDropDown<String>(
                                                                controller: _model.dropDownValueController3 ??= FormFieldController<String>(null),
                                                                options: provinceOptions,
                                                                // onChanged: (val) => safeSetState(() => _model.dropDownValue3 = val),
                                                                onChanged: (val) async {
                                                                  _model.dropDownValue5 = null;
                                                                  safeSetState(() => _model.dropDownValue3 = val);

                                                                  final accessLevel = check_access_level;
                                                                  // (await SharedPreferences.getInstance())
                                                                  // .getString('check_access_level') ?? '1';

                                                                  if (val != null && val != 'ทั้งหมด') {
                                                                    final provinceCode = provinceCodeMap[val] ?? '';
                                                                    if (provinceCode.isNotEmpty) {
                                                                      // ✅ ตรวจว่า access level 3, 4 หรือ 5
                                                                      if (accessLevel == '3' || accessLevel == '4' || accessLevel == '5') {
                                                                        await loadHospitalByProvinceCode(provinceCode);
                                                                      }
                                                                    }
                                                                  }
                                                                },

                                                                hintText: '---กรุณาเลือก---',
                                                                searchHintText: 'ค้นหาจังหวัด',
                                                                isSearchable: true,
                                                                maxHeight: 300.0,
                                                                dropdownHeight: 300.0,
                                                                isOverButton: false,
                                                                hidesUnderline: true,
                                                                borderRadius: 8.0,
                                                                borderColor: Colors.transparent,
                                                                borderWidth: 0.0,
                                                                margin: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                icon: Icon(
                                                                  Icons.arrow_drop_down_rounded,
                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                  size: 24.0,
                                                                ),
                                                                textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                      fontFamily: 'IBM Plex Sans Thai Looped',
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'IBM Plex Sans Thai Looped',
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                searchHintTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily: 'IBM Plex Sans Thai Looped',
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                elevation: 1,
                                                              )),
                                                        ].divide(
                                                          SizedBox(
                                                            height: 4.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  // Container(
                                                  //   width: double.infinity,
                                                  //   decoration: BoxDecoration(
                                                  //     color: Color(
                                                  //       0xCDFFFFFF,
                                                  //     ),
                                                  //     borderRadius: BorderRadius.circular(
                                                  //       24.0,
                                                  //     ),
                                                  //     border: Border.all(
                                                  //       color: FlutterFlowTheme.of(
                                                  //         context,
                                                  //       ).secondaryBackground,
                                                  //     ),
                                                  //   ),
                                                  //   child: Padding(
                                                  //     padding: EdgeInsets.all(
                                                  //       12.0,
                                                  //     ),
                                                  //     child: Column(
                                                  //       mainAxisSize: MainAxisSize.max,
                                                  //       children: [
                                                  //         Row(
                                                  //           mainAxisSize: MainAxisSize.max,
                                                  //           mainAxisAlignment: MainAxisAlignment.start,
                                                  //           children: [
                                                  //             Container(
                                                  //               width: 24.0,
                                                  //               height: 24.0,
                                                  //               decoration: BoxDecoration(
                                                  //                 color: Color(
                                                  //                   0xFFFF753A,
                                                  //                 ),
                                                  //                 shape: BoxShape.circle,
                                                  //               ),
                                                  //               child: Icon(
                                                  //                 Icons.add_home_outlined,
                                                  //                 color: FlutterFlowTheme.of(
                                                  //                   context,
                                                  //                 ).secondaryBackground,
                                                  //                 size: 14.0,
                                                  //               ),
                                                  //             ),
                                                  //             Text(
                                                  //               'อำเภอ',
                                                  //               style: FlutterFlowTheme.of(
                                                  //                 context,
                                                  //               ).labelMedium.override(
                                                  //                     fontFamily: 'IBM Plex Sans Thai Looped',
                                                  //                     letterSpacing: 0.0,
                                                  //                   ),
                                                  //             ),
                                                  //           ].divide(
                                                  //             SizedBox(
                                                  //               width: 8.0,
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //         Container(
                                                  //           decoration: BoxDecoration(
                                                  //             color: FlutterFlowTheme.of(
                                                  //               context,
                                                  //             ).secondaryBackground,
                                                  //             borderRadius: BorderRadius.circular(
                                                  //               14.0,
                                                  //             ),
                                                  //             border: Border.all(
                                                  //               color: FlutterFlowTheme.of(
                                                  //                 context,
                                                  //               ).alternate,
                                                  //             ),
                                                  //           ),
                                                  //           child: FlutterFlowDropDown<String>(
                                                  //             controller: _model.dropDownValueController4 ??= FormFieldController<String>(
                                                  //               null,
                                                  //             ),
                                                  //             options: [
                                                  //               'ทั้งหมด',
                                                  //               'ขุขันธ์',
                                                  //               'เด่นชัย',
                                                  //               'แม่สอด',
                                                  //               '...',
                                                  //               'หลีเป๊ะ',
                                                  //             ],
                                                  //             onChanged: (
                                                  //               val,
                                                  //             ) =>
                                                  //                 safeSetState(
                                                  //               () => _model.dropDownValue4 = val,
                                                  //             ),
                                                  //             searchHintTextStyle: FlutterFlowTheme.of(
                                                  //               context,
                                                  //             ).labelMedium.override(
                                                  //                   fontFamily: 'IBM Plex Sans Thai Looped',
                                                  //                   letterSpacing: 0.0,
                                                  //                 ),
                                                  //             searchTextStyle: FlutterFlowTheme.of(
                                                  //               context,
                                                  //             ).bodyMedium.override(
                                                  //                   fontFamily: 'IBM Plex Sans Thai Looped',
                                                  //                   letterSpacing: 0.0,
                                                  //                 ),
                                                  //             textStyle: FlutterFlowTheme.of(
                                                  //               context,
                                                  //             ).bodyLarge.override(
                                                  //                   fontFamily: 'IBM Plex Sans Thai Looped',
                                                  //                   letterSpacing: 0.0,
                                                  //                 ),
                                                  //             hintText: '---กรุณาเลือก---',
                                                  //             searchHintText: 'ค้นหาปี',
                                                  //             icon: Icon(
                                                  //               Icons.arrow_drop_down_rounded,
                                                  //               color: FlutterFlowTheme.of(
                                                  //                 context,
                                                  //               ).primaryText,
                                                  //               size: 24.0,
                                                  //             ),
                                                  //             elevation: 2.0,
                                                  //             borderColor: Colors.transparent,
                                                  //             borderWidth: 0.0,
                                                  //             borderRadius: 8.0,
                                                  //             margin: EdgeInsetsDirectional.fromSTEB(
                                                  //               8.0,
                                                  //               0.0,
                                                  //               8.0,
                                                  //               0.0,
                                                  //             ),
                                                  //             hidesUnderline: true,
                                                  //             isOverButton: false,
                                                  //             isSearchable: true,
                                                  //             isMultiSelect: false,
                                                  //           ),
                                                  //         ),
                                                  //       ].divide(
                                                  //         SizedBox(
                                                  //           height: 4.0,
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                        0xCDFFFFFF,
                                                      ),
                                                      borderRadius: BorderRadius.circular(
                                                        24.0,
                                                      ),
                                                      border: Border.all(
                                                        color: FlutterFlowTheme.of(
                                                          context,
                                                        ).secondaryBackground,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        12.0,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width: 24.0,
                                                                height: 24.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(
                                                                    0xFF830FE5,
                                                                  ),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: Icon(
                                                                  Icons.medical_services,
                                                                  color: FlutterFlowTheme.of(
                                                                    context,
                                                                  ).secondaryBackground,
                                                                  size: 14.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                'หน่วยให้บริการ',
                                                                style: FlutterFlowTheme.of(
                                                                  context,
                                                                ).labelMedium.override(
                                                                      fontFamily: 'IBM Plex Sans Thai Looped',
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(
                                                              SizedBox(
                                                                width: 8.0,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: FlutterFlowTheme.of(
                                                                context,
                                                              ).secondaryBackground,
                                                              borderRadius: BorderRadius.circular(
                                                                14.0,
                                                              ),
                                                              border: Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                  context,
                                                                ).alternate,
                                                              ),
                                                            ),
                                                            child: FlutterFlowDropDown<String>(
                                                              controller: _model.dropDownValueController5 ??= FormFieldController<String>(
                                                                null,
                                                              ),
                                                              options: hcodeList,
                                                              onChanged: (
                                                                val,
                                                              ) =>
                                                                  safeSetState(
                                                                () => _model.dropDownValue5 = val,
                                                              ),
                                                              searchHintTextStyle: FlutterFlowTheme.of(
                                                                context,
                                                              ).labelMedium.override(
                                                                    fontFamily: 'IBM Plex Sans Thai Looped',
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                              searchTextStyle: FlutterFlowTheme.of(
                                                                context,
                                                              ).bodyMedium.override(
                                                                    fontFamily: 'IBM Plex Sans Thai Looped',
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                              textStyle: FlutterFlowTheme.of(
                                                                context,
                                                              ).bodyLarge.override(
                                                                    fontFamily: 'IBM Plex Sans Thai Looped',
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                              hintText: '---กรุณาเลือก---',
                                                              searchHintText: 'ค้นหาหน่วย',
                                                              icon: Icon(
                                                                Icons.arrow_drop_down_rounded,
                                                                color: FlutterFlowTheme.of(
                                                                  context,
                                                                ).primaryText,
                                                                size: 24.0,
                                                              ),
                                                              elevation: 2.0,
                                                              borderColor: Colors.transparent,
                                                              borderWidth: 0.0,
                                                              borderRadius: 8.0,
                                                              margin: EdgeInsetsDirectional.fromSTEB(
                                                                8.0,
                                                                0.0,
                                                                8.0,
                                                                0.0,
                                                              ),
                                                              hidesUnderline: true,
                                                              isOverButton: false,
                                                              isSearchable: true,
                                                              isMultiSelect: false,
                                                              dropdownHeight: 300,
                                                              maxHeight: 300,
                                                            ),
                                                          ),
                                                        ].divide(
                                                          SizedBox(
                                                            height: 4.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                      0.0,
                                                      16.0,
                                                      0.0,
                                                      0.0,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        // final selectedProvinceName = _model.dropDownValue3;
                                                        // final selectedProvinceCode = provinceCodeMap[selectedProvinceName] ?? '';
                                                        var selectedProvinceCode = provinceCodeMap[_model.dropDownValue3];
                                                        var selectedHospitalCode = _model.dropDownValue5;

                                                        print('checkfilter $selectedProvinceCode // $selectedHospitalCode');
                                                        final province = selectedProvinceCode ?? '';
                                                        final hospital = selectedHospitalCode ?? '';
                                                        final region = _model.dropDownValue2 ?? '';

                                                        regionIdFilter = _getRegionId(region);
                                                        print('checkfilter region = $region // $regionIdFilter');
                                                        hospitalselect = selectedHospitalCode ?? '';

                                                        if (region.isEmpty) {
                                                          checkregionfilter = 4;
                                                        } else {
                                                          checkregionfilter = 5;
                                                        }

                                                        if (region.isEmpty) {
                                                          if (province.isNotEmpty && hospital.isEmpty) {
                                                            checkfilter = 1;
                                                          } else if (province.isNotEmpty && hospital.isNotEmpty) {
                                                            checkfilter = 2;
                                                          } else if (province.isEmpty && hospital.isNotEmpty) {
                                                            checkfilter = 3;
                                                          } else {
                                                            checkfilter = 0;
                                                          }
                                                        } else {
                                                          if (province.isEmpty && hospital.isEmpty) {
                                                            checkfilter = 6;
                                                          } else if (province.isNotEmpty && hospital.isEmpty) {
                                                            checkfilter = 7;
                                                          } else if (province.isNotEmpty && hospital.isNotEmpty) {
                                                            checkfilter = 8;
                                                          } else if (province.isEmpty && hospital.isNotEmpty) {
                                                            checkfilter = 9;
                                                          }
                                                        }
                                                        if (check_access_level == '4' || check_access_level == '3') {
                                                          if (checkfilter == 0 || checkfilter == 3) {
                                                            selectedProvinceCode = orgProvinceCodesList;
                                                          }
                                                        }
                                                        // else if (check_access_level == '2' || check_access_level == '1') {
                                                        //   if (checkfilter == 3) {
                                                        //     selectedProvinceCode = null;
                                                        //     selectedHospitalCode = queryhcodeList;
                                                        //   }
                                                        // }
                                                        print('checkfilter checkregionfilter = $checkfilter $checkregionfilter');

                                                        await fetchRegionChartData(
                                                          year: _model.dropDownValue1,
                                                          regionName: region,
                                                          province: selectedProvinceCode,
                                                          district: _model.dropDownValue4,
                                                          hospital: selectedHospitalCode,
                                                        );
                                                        await fetchHighBloodPressureByAge(
                                                          year: _model.dropDownValue1,
                                                          regionName: region,
                                                          province: selectedProvinceCode,
                                                          district: _model.dropDownValue4,
                                                          hospital: selectedHospitalCode,
                                                        );
                                                        await fetchHighBloodPressureByGender(
                                                          year: _model.dropDownValue1,
                                                          regionName: region,
                                                          province: selectedProvinceCode,
                                                          district: _model.dropDownValue4,
                                                          hospital: selectedHospitalCode,
                                                        );
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        width: 420.0,
                                                        height: 54.0,
                                                        decoration: BoxDecoration(
                                                          color: FlutterFlowTheme.of(
                                                            context,
                                                          ).primary,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 24.0,
                                                              color: Color(
                                                                0x1F666666,
                                                              ),
                                                              offset: Offset(
                                                                0.0,
                                                                2.0,
                                                              ),
                                                            ),
                                                          ],
                                                          borderRadius: BorderRadius.circular(
                                                            16.0,
                                                          ),
                                                        ),
                                                        child: Align(
                                                          alignment: AlignmentDirectional(
                                                            0.0,
                                                            0.0,
                                                          ),
                                                          child: Text(
                                                            'ประมวลผล',
                                                            style: FlutterFlowTheme.of(
                                                              context,
                                                            ).titleSmall.override(
                                                                  fontFamily: 'IBM Plex Sans Thai Looped',
                                                                  color: FlutterFlowTheme.of(
                                                                    context,
                                                                  ).secondaryBackground,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      // Content ด้านขวา
                                      Expanded(
                                        flex: 7,
                                        child: SingleChildScrollView(
                                          primary: false,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                color: Colors.grey[200],
                                                child: Column(
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0xCDFFFFFF,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 24.0,
                                                            color: Color(
                                                              0x1E666666,
                                                            ),
                                                            offset: Offset(
                                                              0.0,
                                                              2.0,
                                                            ),
                                                          ),
                                                        ],
                                                        borderRadius: BorderRadius.circular(
                                                          24.0,
                                                        ),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(
                                                            context,
                                                          ).secondaryBackground,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                          12.0,
                                                        ),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    children: [
                                                                      Container(
                                                                        width: 24.0,
                                                                        height: 24.0,
                                                                        decoration: BoxDecoration(
                                                                          color: FlutterFlowTheme.of(
                                                                            context,
                                                                          ).secondaryBackground,
                                                                          borderRadius: BorderRadius.circular(
                                                                            8.0,
                                                                          ),
                                                                          border: Border.all(
                                                                            color: FlutterFlowTheme.of(
                                                                              context,
                                                                            ).alternate,
                                                                          ),
                                                                        ),
                                                                        alignment: AlignmentDirectional(
                                                                          0.0,
                                                                          0.0,
                                                                        ),
                                                                        child: Icon(
                                                                          Icons.bar_chart_rounded,
                                                                          color: FlutterFlowTheme.of(
                                                                            context,
                                                                          ).primary,
                                                                          size: 16.0,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'กราฟแสดงผู้ป่วยโรคหลอดเลือดสมองทั้งหมด',
                                                                        style: FlutterFlowTheme.of(
                                                                          context,
                                                                        ).titleSmall.override(
                                                                              fontFamily: 'IBM Plex Sans Thai Looped',
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                      ),
                                                                    ].divide(
                                                                      SizedBox(
                                                                        width: 8.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment: AlignmentDirectional(
                                                                      1.0,
                                                                      0.0,
                                                                    ),
                                                                    child: wrapWithModel(
                                                                      model: _model.remarkWidgetModel1,
                                                                      updateCallback: () => safeSetState(
                                                                        () {},
                                                                      ),
                                                                      child: RemarkWidgetWidget(
                                                                        text: 'ทั้งหมด',
                                                                        count: countTotalRegion,
                                                                        unit: 'คน',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                width: double.infinity,
                                                                height: 450.0,
                                                                decoration: BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                    context,
                                                                  ).secondaryBackground,
                                                                  borderRadius: BorderRadius.circular(
                                                                    24.0,
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(
                                                                    12.0,
                                                                  ),
                                                                  child: Container(
                                                                      width: double.infinity,
                                                                      height: 450.0,
                                                                      child: (check_access_level == '5') // เช็คว่าค้นหาอะไรอยู่ เขต จังหวัด หน่วย
                                                                          ? (checkregionfilter == 4)
                                                                              ? (checkfilter == 0)
                                                                                  ? custom_widgets.BloodSummary(
                                                                                      width: double.infinity,
                                                                                      height: 450.0,
                                                                                      c1: countRegion1,
                                                                                      c2: countRegion2,
                                                                                      c3: countRegion3,
                                                                                      c4: countRegion4,
                                                                                      c5: countRegion5,
                                                                                      c6: countRegion6,
                                                                                      c7: countRegion7,
                                                                                      c8: countRegion8,
                                                                                      c9: countRegion9,
                                                                                      c10: countRegion10,
                                                                                      c11: countRegion11,
                                                                                      c12: countRegion12,
                                                                                      c13: countRegion13,
                                                                                    )
                                                                                  : (checkfilter == 1)
                                                                                      ? custom_widgets.BloodSummaryHospital(
                                                                                          width: double.infinity,
                                                                                          height: 450.0,
                                                                                          hospitalDataList: convertedHospitalList,
                                                                                        )
                                                                                      : custom_widgets.BloodSummaryHospital(
                                                                                          width: double.infinity,
                                                                                          height: 450.0,
                                                                                          hospitalDataList: convertedHospitalList,
                                                                                          selectedHcode: hospitalselect,
                                                                                        )
                                                                              //--------------------------5---
                                                                              : (checkfilter == 6)
                                                                                  ? custom_widgets.BloodSummaryProvince(
                                                                                      width: double.infinity,
                                                                                      height: 450.0,
                                                                                      provinceDataList: convertedList,
                                                                                      selectedRegionId: regionIdFilter,
                                                                                    )
                                                                                  : (checkfilter == 7)
                                                                                      ? custom_widgets.BloodSummaryHospital(
                                                                                          width: double.infinity,
                                                                                          height: 450.0,
                                                                                          hospitalDataList: convertedHospitalList,
                                                                                        )
                                                                                      : (checkfilter == 8)
                                                                                          ? custom_widgets.BloodSummaryHospital(
                                                                                              width: double.infinity,
                                                                                              height: 450.0,
                                                                                              hospitalDataList: convertedHospitalList,
                                                                                              selectedHcode: hospitalselect,
                                                                                            )
                                                                                          : custom_widgets.BloodSummaryHospital(
                                                                                              width: double.infinity,
                                                                                              height: 450.0,
                                                                                              hospitalDataList: convertedHospitalList,
                                                                                              selectedHcode: '',
                                                                                            )
                                                                          : (check_access_level == '4' || check_access_level == '3')
                                                                              ? (checkfilter == 0)
                                                                                  ? custom_widgets.BloodSummaryProvince(
                                                                                      width: double.infinity,
                                                                                      height: 450.0,
                                                                                      provinceDataList: convertedList,
                                                                                      // [
                                                                                      //   {
                                                                                      //     'provinceCode': '10',
                                                                                      //     'value': 12345
                                                                                      //   },
                                                                                      //   {
                                                                                      //     'provinceCode': '12',
                                                                                      //     'value': 6789
                                                                                      //   },
                                                                                      // ],
                                                                                    )
                                                                                  : (checkfilter == 1)
                                                                                      ? custom_widgets.BloodSummaryHospital(
                                                                                          width: double.infinity,
                                                                                          height: 450.0,
                                                                                          hospitalDataList: convertedHospitalList,
                                                                                        )
                                                                                      : custom_widgets.BloodSummaryHospital(
                                                                                          width: double.infinity,
                                                                                          height: 450.0,
                                                                                          hospitalDataList: convertedHospitalList,
                                                                                          selectedHcode: hospitalselect,
                                                                                        )
                                                                              : (checkfilter == 0)
                                                                                  ? custom_widgets.BloodSummaryHospital(
                                                                                      width: double.infinity,
                                                                                      height: 450.0,
                                                                                      hospitalDataList: convertedHospitalList,
                                                                                    )
                                                                                  : custom_widgets.BloodSummaryHospital(
                                                                                      width: double.infinity,
                                                                                      height: 450.0,
                                                                                      hospitalDataList: convertedHospitalList,
                                                                                      selectedHcode: hospitalselect,
                                                                                    )),
                                                                ),
                                                              ),
                                                            ].divide(
                                                              SizedBox(
                                                                height: 12.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  color: Color(
                                                                    0xCDFFFFFF,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(
                                                                    24.0,
                                                                  ),
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(
                                                                      context,
                                                                    ).secondaryBackground,
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(
                                                                    12.0,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            width: 24.0,
                                                                            height: 24.0,
                                                                            decoration: BoxDecoration(
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).secondaryBackground,
                                                                              borderRadius: BorderRadius.circular(
                                                                                8.0,
                                                                              ),
                                                                              border: Border.all(
                                                                                color: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).alternate,
                                                                              ),
                                                                            ),
                                                                            alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0,
                                                                            ),
                                                                            child: Icon(
                                                                              Icons.donut_large_rounded,
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primary,
                                                                              size: 16.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'จำแนกตามเพศ',
                                                                            style: FlutterFlowTheme.of(
                                                                              context,
                                                                            ).titleSmall.override(
                                                                                  fontFamily: 'IBM Plex Sans Thai Looped',
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                          ),
                                                                          Align(
                                                                            alignment: AlignmentDirectional(
                                                                              1.0,
                                                                              0.0,
                                                                            ),
                                                                            child: wrapWithModel(
                                                                              model: _model.remarkWidgetModel2,
                                                                              updateCallback: () => safeSetState(
                                                                                () {},
                                                                              ),
                                                                              child: RemarkWidgetWidget(
                                                                                text: 'ทั้งหมด',
                                                                                count: totalgender,
                                                                                unit: 'คน',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ].divide(
                                                                          SizedBox(
                                                                            width: 8.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                              color: Color(
                                                                                0xCDFFFFFF,
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  blurRadius: 24.0,
                                                                                  color: Color(
                                                                                    0x1E666666,
                                                                                  ),
                                                                                  offset: Offset(
                                                                                    0.0,
                                                                                    2.0,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                              borderRadius: BorderRadius.circular(
                                                                                24.0,
                                                                              ),
                                                                              border: Border.all(
                                                                                color: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).secondaryBackground,
                                                                              ),
                                                                            ),
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(
                                                                                8.0,
                                                                              ),
                                                                              child:
                                                                                  // Row(
                                                                                  //   mainAxisSize: MainAxisSize.max,
                                                                                  //   children: [
                                                                                  Container(
                                                                                width: double.infinity,
                                                                                height: 325.0,
                                                                                child: custom_widgets.DonutByGenders(
                                                                                  width: double.infinity,
                                                                                  height: 325.0,
                                                                                  male: male,
                                                                                  female: female,
                                                                                ),
                                                                              ),
                                                                              //   ].divide(
                                                                              //     SizedBox(
                                                                              //       width: 12.0,
                                                                              //     ),
                                                                              //   ),
                                                                              // ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ].divide(
                                                                      SizedBox(
                                                                        height: 8.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 4,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  color: Color(
                                                                    0xCDFFFFFF,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(
                                                                    24.0,
                                                                  ),
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(
                                                                      context,
                                                                    ).secondaryBackground,
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(
                                                                    12.0,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        children: [
                                                                          Container(
                                                                            width: 24.0,
                                                                            height: 24.0,
                                                                            decoration: BoxDecoration(
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).secondaryBackground,
                                                                              borderRadius: BorderRadius.circular(
                                                                                8.0,
                                                                              ),
                                                                              border: Border.all(
                                                                                color: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).alternate,
                                                                              ),
                                                                            ),
                                                                            alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0,
                                                                            ),
                                                                            child: Icon(
                                                                              Icons.bar_chart_rounded,
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primary,
                                                                              size: 16.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'จำแนกประชากรตามช่วงอายุ',
                                                                            style: FlutterFlowTheme.of(
                                                                              context,
                                                                            ).titleSmall.override(
                                                                                  fontFamily: 'IBM Plex Sans Thai Looped',
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                          ),
                                                                          Align(
                                                                            alignment: AlignmentDirectional(
                                                                              1.0,
                                                                              0.0,
                                                                            ),
                                                                            child: wrapWithModel(
                                                                              model: _model.remarkWidgetModel3,
                                                                              updateCallback: () => safeSetState(
                                                                                () {},
                                                                              ),
                                                                              child: RemarkWidgetWidget(
                                                                                text: 'ทั้งหมด',
                                                                                count: totalage,
                                                                                unit: 'คน',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ].divide(
                                                                          SizedBox(
                                                                            width: 8.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            width: double.infinity,
                                                                            decoration: BoxDecoration(
                                                                              color: Color(
                                                                                0xCDFFFFFF,
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  blurRadius: 24.0,
                                                                                  color: Color(
                                                                                    0x1E666666,
                                                                                  ),
                                                                                  offset: Offset(
                                                                                    0.0,
                                                                                    2.0,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                              borderRadius: BorderRadius.circular(
                                                                                24.0,
                                                                              ),
                                                                              border: Border.all(
                                                                                color: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).secondaryBackground,
                                                                              ),
                                                                            ),
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(
                                                                                8.0,
                                                                              ),
                                                                              child:
                                                                                  // Row(
                                                                                  //   mainAxisSize: MainAxisSize.max,
                                                                                  //   children: [
                                                                                  Container(
                                                                                width: double.infinity,
                                                                                height: 325.0,
                                                                                child: custom_widgets.HighBloodPressureByAges(
                                                                                  width: double.infinity,
                                                                                  height: 325.0,
                                                                                  a1: age0_4,
                                                                                  a2: age5_11,
                                                                                  a3: age12_17,
                                                                                  a4: age18_59,
                                                                                  a5: age60plus,
                                                                                ),
                                                                              ),
                                                                              // ].divide(
                                                                              //   SizedBox(
                                                                              //     width: 12.0,
                                                                              //   ),
                                                                              // ),
                                                                              // ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ].divide(
                                                                      SizedBox(
                                                                        height: 8.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ].divide(
                                                        SizedBox(
                                                          width: 12.0,
                                                        ),
                                                      ),
                                                    ),

                                                    // เพิ่ม Container, Padding ตามที่ต้องการ
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // // .animateOnPageLoad(animationsMap['rowOnPageLoadAnimation3']!),
                      ].divide(SizedBox(height: 12.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
