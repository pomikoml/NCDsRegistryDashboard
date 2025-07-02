import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:n_c_ds_registry_dashboard/pages/patient_n_c_d/patient_n_c_d_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:js' as js;

class NCDsgetX extends GetxController {
  // final baseurl = 'http://192.168.30.73:8000';

  // final baseurl = 'http://127.0.0.1:18001';
  // final client = http.Client();
  // RxList<Map<String, dynamic>> summaryList = <Map<String, dynamic>>[].obs;

  // RxString apiToken = ''.obs;
  // RxBool isLoading = false.obs;
  int pageSize = 20;
  late String baseurl;
  late String username;
  late String password;
  final client = http.Client();
  RxList<Map<String, dynamic>> summaryList = <Map<String, dynamic>>[].obs;
  RxString apiToken = ''.obs;
  RxBool isLoading = false.obs;

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

  // var searchBy = 'name'.obs; // 'name' หรือ 'cid'

  @override
  void onInit() {
    super.onInit();

    // โหลดค่าจาก JS
    baseurl = EnvService.apiUrl;
    username = EnvService.username;
    password = EnvService.password;

    // //debugPrint('🌐 baseurl: $baseurl');
    // //debugPrint('👤 username: $username');
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

  Future<void> _loadLoginData() async {
    userLogin = await _getUserLogin();
    hospitalCode = await _getHospitalCode();
    hospitalName = await _getHospitalName();
    scopeList = await _getScopeList();
    cid = await _getcid();

    final List<String> query2 = await getProvinceQueryParams();
    print('org_province_codes: $query2');
    query = query2.map((e) => e.toString()).toList();
    final List<String> querylv42 = await getProvinceQuerylv4Params();
    querylv4 = querylv42.map((e) => e.toString()).toList();
    check_access_level =
        // '4';
        await getCheckAccessLevel();
    // print('User Login: $userLogin');
    // print('Hospital Code: $hospitalCode');
    // print('Hospital Name: $hospitalName');
    // print('Scope List: $scopeList');

    print('querylv4: $querylv4');

    // คุณสามารถใช้ค่าที่ดึงมาเพื่อทำสิ่งต่างๆ ตามที่คุณต้องการ
  }

  // Rx ตัวแปรทั้งหมดที่เคยใช้ใน setState
  // ความดันโลหิตสูง (cd_code: 002)
  RxString diseaseHypertensionDisplay = ''.obs;
  RxInt diseaseHypertensionCount = 0.obs;
  RxDouble diseaseHypertensionPercent = 0.0.obs;

// เบาหวาน (cd_code: 001)
  RxString diseaseDiabetesDisplay = ''.obs;
  RxInt diseaseDiabetesCount = 0.obs;
  RxDouble diseaseDiabetesPercent = 0.0.obs;

// อ้วน (cd_code: 027)
  RxString diseaseObesityDisplay = ''.obs;
  RxInt diseaseObesityCount = 0.obs;
  RxDouble diseaseObesityPercent = 0.0.obs;

// ไต (cd_code: 009)
  RxString diseaseKidneyDisplay = ''.obs;
  RxInt diseaseKidneyCount = 0.obs;
  RxDouble diseaseKidneyPercent = 0.0.obs;
//โรคหัวใจ
  RxString diseaseHeartDisplay = ''.obs;
  RxInt diseaseHeartCount = 0.obs;
  RxDouble diseaseHeartPercent = 0.0.obs;
//โรคหลดเลือดสมอง
  RxString diseaseStrokeDisplay = ''.obs;
  RxInt diseaseStrokeCount = 0.obs;
  RxDouble diseaseStrokePercent = 0.0.obs;

// ไขมันในเลือดสูง (cd_code: 014)
  RxString diseaseCholesterolDisplay = ''.obs;
  RxInt diseaseCholesterolCount = 0.obs;
  RxDouble diseaseCholesterolPercent = 0.0.obs;

// ถุงลมโป่งพอง (cd_code: 008)
  RxString diseaseEmphysemaDisplay = ''.obs;
  RxInt diseaseEmphysemaCount = 0.obs;
  RxDouble diseaseEmphysemaPercent = 0.0.obs;

// มะเร็ง (cd_code: 006)
  RxString diseaseCancerDisplay = ''.obs;
  RxInt diseaseCancerCount = 0.obs;
  RxDouble diseaseCancerPercent = 0.0.obs;

  // บุหรี่ไฟฟ้า (cd_code: 026)
  RxString e_cigaretteDisplay = ''.obs;
  RxInt e_cigaretteCount = 0.obs;
  RxDouble e_cigarettePercent = 0.0.obs;

//-------------------------------patient NCDs
  RxList<Map<String, dynamic>> ncdList = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool isNCDLoading = false.obs;
  var nameFilter = ''.obs; // เก็บชื่อที่ใช้ค้นหา

  // เก็บค่าที่ใช้ filter ล่าสุด
  var lastName = ''.obs;
  var lastCid = ''.obs;
  var lastCdCode = ''.obs;
  var laststatus = ''.obs;
  DateTime? lastStartDate;
  DateTime? lastEndDate;

  Future<void> callAuthAPI() async {
    final url = Uri.parse('$baseurl/api/auth');
    final headers = {
      'Content-Type': 'application/json'
    };
    final body = jsonEncode({
      "username": username,
      "password": password
    });

    try {
      isLoading.value = true;
      final response = await client.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        apiToken.value = responseData['access_token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('apiToken', apiToken.value);

        // //debugPrint('✅ Auth Success: ${response.body}');
        await Future.delayed(Duration(milliseconds: 100));
        await _loadLoginData();
        await fetchGroupByCdCode(fiscalYear: 0); // เรียกหลัง auth
        await fetchGroupByGender(fiscalYear: 0);
        await fetchRegionRatePer1000(fiscalYear: 0);
        await fetchGroupByRegion(fiscalYear: 0);

        await fetchNCDList();
      } else {
        //debugPrint('❌ Auth Failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      //debugPrint('🚫 Error calling API: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic>? findDiseaseByCode(String code) {
    try {
      return summaryList.firstWhere((item) => item['cd_code'] == code);
    } catch (e) {
      return null;
    }
  }

  void resetDiseaseSummaryValues() {
    diseaseHypertensionCount.value = 0;
    diseaseHypertensionPercent.value = 0;
    diseaseHypertensionDisplay.value = '-';

    diseaseDiabetesCount.value = 0;
    diseaseDiabetesPercent.value = 0;
    diseaseDiabetesDisplay.value = '-';

    diseaseObesityCount.value = 0;
    diseaseObesityPercent.value = 0;
    diseaseObesityDisplay.value = '-';

    diseaseKidneyCount.value = 0;
    diseaseKidneyPercent.value = 0;
    diseaseKidneyDisplay.value = '-';

    diseaseHeartCount.value = 0;
    diseaseHeartPercent.value = 0;
    diseaseHeartDisplay.value = '-';

    diseaseStrokeCount.value = 0;
    diseaseStrokePercent.value = 0;
    diseaseStrokeDisplay.value = '-';

    diseaseCholesterolCount.value = 0;
    diseaseCholesterolPercent.value = 0;
    diseaseCholesterolDisplay.value = '-';

    diseaseEmphysemaCount.value = 0;
    diseaseEmphysemaPercent.value = 0;
    diseaseEmphysemaDisplay.value = '-';

    diseaseCancerCount.value = 0;
    diseaseCancerPercent.value = 0;
    diseaseCancerDisplay.value = '-';
  }

  Future<void> fetchGroupByCdCode({required int fiscalYear}) async {
    //debugPrint('apiToken: ${apiToken.value}');

    print('check_access_level = $check_access_level');

    // final url;
    // print('คิวรี่  $query');
    // final fiscalParam = 'fiscal_year=$fiscalYear';

    final isAllHospital = hospitalCode == null || hospitalCode == '25039' || hospitalCode == '99999' || hospitalCode == '00000';
    // final hasQuery = query != null && query!.trim().isNotEmpty;

//     String queryString = '$fiscalParam';

//     if (check_access_level == '5') {
//       // ไม่มี query เพิ่มเติม
//     } else if (check_access_level == '4') {
//       queryString += '&$querylv4';
//     } else if (check_access_level == '3') {
//       if (hasQuery) queryString += '&$query';
//     } else {
//       queryString += '&organization_code=$hospitalCode';
//       // if (hasQuery) queryString += '&$query';
//     }

// // แก้เฉพาะกรณีที่ไม่ได้อยู่ใน level 3 หรือ 4
//     if (isAllHospital && !hasQuery && !(check_access_level == '3' || check_access_level == '4')) {
//       queryString += '&organization_code=$hospitalCode';
//     }

//     url = Uri.parse('$baseurl/api/summary/group-by-cd-code?$queryString');

//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${apiToken.value}',
//     };

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
    if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
      body.addAll({
        'organization_code': hospitalCode
      });
    }

    final url = Uri.parse('$baseurl/api/summary/group-by-cd-code');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      // final response = await client.get(url, headers: headers);
      final response = await client.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 401) {
        //debugPrint('🔐 Token หมดอายุ กำลัง refresh...');
        await callAuthAPI(); // รับ token ใหม่
        return await fetchGroupByCdCode(fiscalYear: fiscalYear); // 🔁 เรียกใหม่
      }
      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);
        final dataList = List<Map<String, dynamic>>.from(data['data']);
        summaryList.clear();
        summaryList.assignAll(dataList);

        resetDiseaseSummaryValues();
        for (var item in dataList) {
          final String code = item['cd_code'];
          final String name = item['cd_display'] ?? 'ไม่มีข้อมูล';
          final int count = item['count'] ?? 0;
          final double percent = (item['percent'] ?? 0).toDouble();
          print('[DEBUG] cd_code=$code, name="$name", count=$count, percent=$percent');
          switch (code) {
            case '002': //โรคความดันโลหิตสูง
              diseaseHypertensionDisplay.value = name.isNotEmpty ? name : 'โรคความดันโลหิตสูง';
              diseaseHypertensionCount.value = count;
              diseaseHypertensionPercent.value = percent;
              break;
            case '001': //โรคเบาหวาน
              diseaseDiabetesDisplay.value = name.isNotEmpty ? name : 'โรคเบาหวาน';
              diseaseDiabetesCount.value = count;
              diseaseDiabetesPercent.value = percent;
              break;
            case '027': //โรคอ้วนลงพุง
              diseaseObesityDisplay.value = name.isNotEmpty ? name : 'โรคอ้วนลงพุง';
              diseaseObesityCount.value = count;
              diseaseObesityPercent.value = percent;
              break;
            case '009': //โรคไตวายเรื้อรัง
              diseaseKidneyDisplay.value = name.isNotEmpty ? name : 'โรคไตวายเรื้อรัง';
              diseaseKidneyCount.value = count;
              diseaseKidneyPercent.value = percent;
              break;
            case '005': //โรคหลอดเลือดสมอง//โรคหัวใจ
              final cleanedName = name.trim();
              if (cleanedName == 'โรคหัวใจ') {
                diseaseHeartDisplay.value = cleanedName.isNotEmpty ? cleanedName : 'โรคหัวใจ';
                diseaseHeartCount.value = count;
                diseaseHeartPercent.value = percent;
              }
              if (cleanedName == 'โรคหลอดเลือดสมอง') {
                diseaseStrokeDisplay.value = cleanedName.isNotEmpty ? cleanedName : 'โรคหลอดเลือดสมอง';
                diseaseStrokeCount.value = count;
                diseaseStrokePercent.value = percent;
              }
              break;
            case '014': //โรคไขมันในเลือดสูง
              diseaseCholesterolDisplay.value = name.isNotEmpty ? name : 'โรคไขมันในเลือดสูง';
              diseaseCholesterolCount.value = count;
              diseaseCholesterolPercent.value = percent;
              break;
            case '008': //โรคถุงลมโป่งพอง
              diseaseEmphysemaDisplay.value = name.isNotEmpty ? name : 'โรคถุงลมโป่งพอง';
              diseaseEmphysemaCount.value = count;
              diseaseEmphysemaPercent.value = percent;
              break;
            case '006': //โรคมะเร็ง
              diseaseCancerDisplay.value = name.isNotEmpty ? name : 'โรคมะเร็ง';
              diseaseCancerCount.value = count;
              diseaseCancerPercent.value = percent;
              break;
            case '026': // บุหรี่ไฟฟ้า
              e_cigaretteDisplay.value = name.isNotEmpty ? name : 'บุหรี่ไฟฟ้า';
              e_cigaretteCount.value = count;
              e_cigarettePercent.value = percent;
              break;

            default:
              //debugPrint('⚠️ ไม่รู้จัก cd_code: $code');
              break;
          }
        }

        //debugPrint('✅ Summary Data Loaded');
      } else {
        //debugPrint('❌ Failed to fetch summary: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      //debugPrint('🚫 Error fetching summary: $e');
    }
  }

  Future<void> fetchNCDList({
    String? name,
    String? cid,
    String? cdCode,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (page < 1) return;

    // จำค่า filter ที่ใช้ล่าสุด
    if (startDate != null) lastStartDate = startDate;
    if (endDate != null) lastEndDate = endDate;
    if (name != null) lastName.value = name;
    if (cid != null) lastCid.value = cid;
    if (cdCode != null) lastCdCode.value = cdCode;
    if (status != null) laststatus.value = status;
    final usedName = name ?? lastName.value;
    final usedCid = cid ?? lastCid.value;
    // final usedCdCode = cdCode ?? lastCdCode.value;
    // เอาค่าที่จะใช้งานจริง
    final usedStart = startDate ?? lastStartDate;
    final usedEnd = endDate ?? lastEndDate;

    if (apiToken.value.isEmpty) {
      await callAuthAPI();
    }
    final url = Uri.parse('$baseurl/api/ncd_list');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };
    final body = {
      'patient_name_text': usedName,
      'cid': usedCid,
      'cd_code': cdCode,
      "status_display": status,
      'page': page,
      'page_size': pageSize,
      "organization_code": hospitalCode,
      if (usedStart != null && usedEnd != null)
        'register_datetime': {
          'start': usedStart.toUtc().toIso8601String(),
          'end': usedEnd.toUtc().toIso8601String(),
        },
    };

    try {
      isNCDLoading.value = true;
      final response = await client.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 401) {
        await callAuthAPI();
        return fetchNCDList(
          name: name,
          cid: cid,
          cdCode: cdCode,
          page: page,
        );
      }

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);
        ncdList.assignAll(List<Map<String, dynamic>>.from(data['data']));
        currentPage.value = data['page'];
        totalPages.value = data['total_pages'];
      } else {
        ncdList.clear();
      }
    } catch (e) {
      print('🚫 Error fetching NCD list: $e');
    } finally {
      isNCDLoading.value = false;
    }
  }

  // ตัวแปร Rx (ตั้งไว้ใน GetX Controller เช่น NCDsgetX)
  final RxInt totalGender = 0.obs;
  final RxString genderF = ''.obs;
  final RxInt countF = 0.obs;
  final RxDouble percentF = 0.0.obs;
  final RxString genderM = ''.obs;
  final RxInt countM = 0.obs;
  final RxDouble percentM = 0.0.obs;
  // final RxBool isGenderLoading = false.obs;

  Future<void> fetchGroupByGender({required int fiscalYear}) async {
    if (apiToken.value.isEmpty) {
      await callAuthAPI();
    }
    // final fiscalParam = 'fiscal_year=$fiscalYear';

    //-----------
    // if (hospitalCode == null || hospitalCode == '25039' || hospitalCode == '99999' || hospitalCode == '00000') {
    //   // url = Uri.parse('$baseurl/api/summary/group-by-cd-code');
    //   if (query != null && query!.trim().isNotEmpty) {
    //     // url = Uri.parse('$baseurl/api/summary/group-by-cd-code?$fiscalParam&organization_code=$hospitalCode&$query');
    //     // url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam&$query');
    //     if (check_access_level == '5') {
    //       url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam');
    //     } else {
    //       url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam&$query');
    //     }
    //   } else {
    //     // url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam&organization_code=$hospitalCode');
    //     url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam');
    //   }
    //   // url = Uri.parse('$baseurl/api/summary/group-by-gender?org_province_code=0254545&org_province_code=05454545');
    // } else if (query != null && query!.trim().isNotEmpty) {
    //   // url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam&organization_code=$hospitalCode&$query');
    //   // url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam&$query');
    //   if (check_access_level == '5') {
    //     url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam');
    //   } else {
    //     url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam&$query');
    //   }
    // } else {
    //   // url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam&organization_code=$hospitalCode');
    //   url = Uri.parse('$baseurl/api/summary/group-by-gender?$fiscalParam');
    // }

    final isAllHospital = hospitalCode == null || hospitalCode == '25039' || hospitalCode == '99999' || hospitalCode == '00000';
    // final hasQuery = query != null && query!.trim().isNotEmpty;

//     String queryString = '$fiscalParam';

//     if (check_access_level == '5') {
//       // ไม่มี query เพิ่มเติม
//     } else if (check_access_level == '4') {
//       queryString += '&$querylv4';
//     } else if (check_access_level == '3') {
//       // if (hasQuery)
//       queryString += '&$query';
//     } else {
//       queryString += '&organization_code=$hospitalCode';
//       // if (hasQuery) queryString += '&$query';
//     }

// // เงื่อนไขเฉพาะกรณี level อื่น ที่เป็น allHospital
//     if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
//       queryString += '&organization_code=$hospitalCode';
//     }

    // final url = Uri.parse('$baseurl/api/summary/group-by-gender?$queryString');

    // final headers = {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer ${apiToken.value}',
    // };

    // try {
    //   final response = await client.get(url, headers: headers);
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
    if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
      body.addAll({
        'organization_code': hospitalCode
      });
    }

    final url = Uri.parse('$baseurl/api/summary/group-by-gender');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      // final response = await client.get(url, headers: headers);
      final response = await client.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 401) {
        //debugPrint('🔐 Token หมดอายุ กำลัง refresh...');
        await callAuthAPI(); // รีเฟรช token
        return await fetchGroupByGender(fiscalYear: fiscalYear); // 🔁 เรียกซ้ำ
      }
      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);
        //debugPrint('✅ Gender Data: $data');
        final List<dynamic> genderData = data['data'];
        totalGender.value = data['total'] ?? 0;
        countM.value = 0;
        countF.value = 0;
        percentM.value = 0.0;
        percentF.value = 0.0;

        for (var item in genderData) {
          final int count = item['count'] ?? 0;
          final String gender = item['gender'] ?? 'ไม่มีข้อมูล';
          final double percent = (item['percent'] ?? 0).toDouble();
          switch (gender) {
            case 'F':
              genderF.value = gender;
              countF.value = count;
              percentF.value = percent.isNaN ? 0.0 : percent;
              break;
            case 'M':
              genderM.value = gender;
              countM.value = count;
              percentM.value = percent.isNaN ? 0.0 : percent;
              break;
            default:
              //debugPrint('⚠️ ไม่รู้จัก gender: $gender');
              break;
          }
        }
        //debugPrint('✅ Gender summary loaded, total: ${totalGender.value}');
      } else {
        //debugPrint('❌ Failed to fetch gender summary: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      //debugPrint('🚫 Error fetching gender summary: $e');
    }
  }

  var regionCounts = <double>[].obs;
  var totalRegion = 0.obs;

  Future<void> fetchGroupByRegion({required int fiscalYear}) async {
    if (apiToken.value.isEmpty) {
      await callAuthAPI();
    }

    // final url;
    // final fiscalParam = 'fiscal_year=$fiscalYear';

    // if (hospitalCode == null || hospitalCode == '25039' || hospitalCode == '99999' || hospitalCode == '00000') {
    //   if (query != null && query!.trim().isNotEmpty) {
    //     if (check_access_level == '5') {
    //       url = Uri.parse('$baseurl/api/summary/group-by-region?$fiscalParam');
    //     } else if (check_access_level == '3') {
    //       url = Uri.parse('$baseurl/api/summary/group-by-region?$fiscalParam&$query');
    //     } else {
    //       url = Uri.parse('$baseurl/api/summary/group-by-region?$fiscalParam&organization_code=$hospitalCode&$query');
    //     }
    //   } else {
    //     url = Uri.parse('$baseurl/api/summary/group-by-region?$fiscalParam&organization_code=$hospitalCode');
    //   }
    // } else if (query != null && query!.trim().isNotEmpty) {
    //   if (check_access_level == '5') {
    //     url = Uri.parse('$baseurl/api/summary/group-by-region?$fiscalParam');
    //   } else if (check_access_level == '3') {
    //     url = Uri.parse('$baseurl/api/summary/group-by-region?$fiscalParam&$query');
    //   } else {
    //     url = Uri.parse('$baseurl/api/summary/group-by-region?$fiscalParam&organization_code=$hospitalCode&$query');
    //   }
    // } else {
    //   url = Uri.parse('$baseurl/api/summary/group-by-region?$fiscalParam&organization_code=$hospitalCode');
    // }

    // final fiscalParam = 'fiscal_year=$fiscalYear';

    final isAllHospital = hospitalCode == null || hospitalCode == '25039' || hospitalCode == '99999' || hospitalCode == '00000';
    // final hasQuery = query != null && query!.trim().isNotEmpty;

//     String queryString = '$fiscalParam';

//     if (check_access_level == '5') {
//       // ไม่มี query เพิ่มเติม
//     } else if (check_access_level == '4') {
//       queryString += '&$querylv4';
//     } else if (check_access_level == '3') {
//       // if (hasQuery)
//       queryString += '&$query';
//     } else {
//       queryString += '&organization_code=$hospitalCode';
//       // if (hasQuery) queryString += '&$query';
//     }

// // แก้เฉพาะกรณีที่ไม่ได้อยู่ใน level 3 หรือ 4
//     if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
//       queryString += '&organization_code=$hospitalCode';
//     }

//     final url = Uri.parse('$baseurl/api/summary/group-by-region?$queryString');

//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${apiToken.value}',
//     };

//     try {
//       final response = await client.get(url, headers: headers);

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
    if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
      body.addAll({
        'organization_code': hospitalCode
      });
    }

    final url = Uri.parse('$baseurl/api/summary/group-by-region');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      // final response = await client.get(url, headers: headers);
      final response = await client.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 401) {
        await callAuthAPI();
        return fetchGroupByRegion(fiscalYear: fiscalYear);
      }

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);
        totalRegion.value = data['total'];

        final counts = List.generate(13, (_) => 0.0);
        if (data['data'] is List) {
          for (var item in data['data']) {
            final int regionId = item['region_id'] ?? 0;
            final double count = (item['count'] ?? 0).toDouble();
            if (regionId >= 1 && regionId <= 13) {
              counts[regionId - 1] = count;
            }
          }
          regionCounts.value = counts;
        }
      } else {
        //debugPrint('❌ Fetch Region Failed: ${response.statusCode}');
      }
    } catch (e) {
      //debugPrint('🚫 Error fetchGroupByRegion: $e');
    }
  }

  RxList<double> regionRatePer1000 = <double>[].obs;

  Future<void> fetchRegionRatePer1000({required int fiscalYear}) async {
    if (apiToken.value.isEmpty) {
      await callAuthAPI();
    }

    // final fiscalParam = 'fiscal_year=$fiscalYear';

    final isAllHospital = hospitalCode == null || hospitalCode == '25039' || hospitalCode == '99999' || hospitalCode == '00000';
    // final hasQuery = query != null && query!.trim().isNotEmpty;

    // String queryString = '$fiscalParam';

    // if (check_access_level == '5') {
    //   // ไม่มี query เพิ่มเติม
    // } else if (check_access_level == '4') {
    //   queryString += '&$querylv4';
    // } else if (check_access_level == '3') {
    //   // if (hasQuery)
    //   queryString += '&$query';
    // } else {
    //   queryString += '&organization_code=$hospitalCode';
    //   // if (hasQuery) queryString += '&$query';
    // }

// // แก้เฉพาะกรณีที่ไม่ได้อยู่ใน level 3 หรือ 4
//     if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
//       queryString += '&organization_code=$hospitalCode';
//     }

//     final url = Uri.parse('$baseurl/api/summary/group-by-region?$queryString');

//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${apiToken.value}',
//     };

//     try {
//       final response = await client.get(url, headers: headers);

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
    if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
      body.addAll({
        'organization_code': hospitalCode
      });
    }

    final url = Uri.parse('$baseurl/api/summary/group-by-region');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      // final response = await client.get(url, headers: headers);
      final response = await client.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);
        final items = List<Map<String, dynamic>>.from(data['data']);

        List<double> rates = List.filled(13, 0.0);

        for (var item in items) {
          int regionId = item['region_id'];
          double rate = (item['rate_per_1000'] ?? 0).toDouble();
          if (regionId >= 1 && regionId <= 13) {
            rates[regionId - 1] = rate;
          }
        }

        regionRatePer1000.assignAll(rates);
      } else {
        //debugPrint('❌ Failed to fetch: ${response.statusCode}');
      }
    } catch (e) {
      //debugPrint('🚫 Error: $e');
    }
  }
}

class EnvService {
  static String get apiUrl => js.context['env']?['API_URL'] ?? '';
  static String get username => js.context['env']?['API_USERNAME'] ?? '';
  static String get password => js.context['env']?['API_PASSWORD'] ?? '';
}

class HospitalController extends GetxController {
  var organizationList = <Map<String, dynamic>>[].obs;

  void logCurrentState() {
    log('📦 [HospitalController] organizationList: $organizationList');
    log('📦 [HospitalController] length: ${organizationList.length}');
  }
}
