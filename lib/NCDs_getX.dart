import 'dart:async';
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
  List<String> queryprovince = [];
  List<String> querylv4 = [];

  RxBool isInitializing = false.obs;
  RxBool isRefreshingToken = false.obs;

  Timer? _initTimer;

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
    _scheduleInitialization();
  }

  void _scheduleInitialization() {
    _initTimer?.cancel();
    _initTimer = Timer(Duration(milliseconds: 500), () {
      if (!isInitializing.value) {
        initializeData();
      }
    });
  }

  // แยกการ initialize ออกมา
  Future<void> initializeData() async {
    if (isInitializing.value) return;

    isInitializing.value = true;

    try {
      // 1. Auth ก่อน
      await callAuthAPI();

      // 2. โหลดข้อมูลพื้นฐาน
      await _loadLoginData();

      // 3. เรียก API จำเป็นเท่านั้น (ไม่ใช่ทั้งหมด)
      await _loadEssentialData();
    } catch (e) {
      print('🚫 Error during initialization: $e');
    } finally {
      isInitializing.value = false;
    }
  }

  // โหลดเฉพาะข้อมูลสำคัญตอนเริ่มต้น
  Future<void> _loadEssentialData() async {
    try {
      // เรียกเฉพาะข้อมูลที่จำเป็นสำหรับหน้าแรก
      await Future.wait([
        fetchGroupByCdCode(fiscalYear: 0),
        fetchGroupByGender(fiscalYear: 0),
        fetchGroupByRegionAndCd(fiscalYear: 0),
        fetchAllSubmissionData(fiscalYear: 0),
      ]);

      // โหลดข้อมูลอื่นๆ แบบ lazy loading
      _loadSecondaryData();
    } catch (e) {
      print('🚫 Error loading essential data: $e');
    }
  }

  // โหลดข้อมูลรองแบบไม่บล็อก UI
  void _loadSecondaryData() {
    Future.delayed(Duration(milliseconds: 1000), () async {
      try {
        await fetchRegionRatePer1000(fiscalYear: 0);
        await fetchGroupByRegion(fiscalYear: 0);
        await fetchGroupByRegionAndCd(fiscalYear: 0);
      } catch (e) {
        print('🚫 Error loading secondary data: $e');
      }
    });
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
        // '5';
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

  // Future<void> callAuthAPI() async {
  //   final url = Uri.parse('$baseurl/api/auth');
  //   final headers = {
  //     'Content-Type': 'application/json'
  //   };
  //   final body = jsonEncode({
  //     "username": username,
  //     "password": password
  //   });

  //   try {
  //     isLoading.value = true;
  //     final response = await client.post(url, headers: headers, body: body);
  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       apiToken.value = responseData['access_token'];
  //       // apiToken.value = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtb3BoIiwiZXhwIjoxNzUzMTAyMDkyfQ.LTRbxlTGdJ2jfi3MAMXhI0EKhh9eFdBSprmndJAMpeE";

  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('apiToken', apiToken.value);

  //       // //debugPrint('✅ Auth Success: ${response.body}');
  //       await Future.delayed(Duration(milliseconds: 100));
  //       await _loadLoginData();
  //       await fetchGroupByCdCode(fiscalYear: 0); // เรียกหลัง auth
  //       await fetchGroupByGender(fiscalYear: 0);
  //       await fetchRegionRatePer1000(fiscalYear: 0);
  //       await fetchGroupByRegion(fiscalYear: 0);

  //       // ✅ เพิ่มการเรียกใช้ fetchGroupByRegionAndCd
  //       await fetchGroupByRegionAndCd(fiscalYear: 0);
  //       await fetchAllSubmissionData(fiscalYear: 0);

  //       await fetchNCDList();
  //     } else {
  //       //debugPrint('❌ Auth Failed: ${response.statusCode} ${response.body}');
  //     }
  //   } catch (e) {
  //     //debugPrint('🚫 Error calling API: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // ปรับปรุง callAuthAPI
  Future<void> callAuthAPI() async {
    if (isRefreshingToken.value) {
      // ถ้ากำลัง refresh อยู่ ให้รอ
      await Future.doWhile(() async {
        await Future.delayed(Duration(milliseconds: 100));
        return isRefreshingToken.value;
      });
      return;
    }

    isRefreshingToken.value = true;

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

        print('✅ Auth Success');
      } else {
        print('❌ Auth Failed: ${response.statusCode}');
        throw Exception('Auth failed');
      }
    } catch (e) {
      print('🚫 Error calling Auth API: $e');
      rethrow;
    } finally {
      isLoading.value = false;
      isRefreshingToken.value = false;
    }
  }

  // ปรับปรุงการจัดการ 401 Error
  Future<http.Response> _makeAuthenticatedRequest({
    required Future<http.Response> Function() request,
    int maxRetries = 1,
  }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final response = await request();

        if (response.statusCode == 401 && attempt < maxRetries) {
          print('🔐 Token expired, refreshing... (attempt ${attempt + 1})');
          await callAuthAPI();
          continue; // ลองใหม่
        }

        return response;
      } catch (e) {
        if (attempt == maxRetries) rethrow;
        print('⚠️ Request failed, retrying... (attempt ${attempt + 1})');
        await Future.delayed(Duration(milliseconds: 500));
      }
    }

    throw Exception('Max retry attempts reached');
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
          // "11147" // ใช้รหัสโรงพยาบาลที่ต้องการดึงข้อมูล,
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

    final url = Uri.parse('$baseurl/api/summary/group-by-cd-code');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      // final response = await client.get(url, headers: headers);
      final response = await _makeAuthenticatedRequest(
        request: () => client.post(url, headers: headers, body: jsonEncode(body)),
      );

      // if (response.statusCode == 401) {
      //   //debugPrint('🔐 Token หมดอายุ กำลัง refresh...');
      //   await callAuthAPI(); // รับ token ใหม่
      //   // return await fetchGroupByCdCode(fiscalYear: fiscalYear); // 🔁 เรียกใหม่
      // }
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
          // print('[DEBUG] cd_code=$code, name="$name", count=$count, percent=$percent');
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

// ตัวแปรสำหรับเก็บข้อมูล group-by-region-and-cd
  RxList<Map<String, dynamic>> healthRegionCdSummaryList = <Map<String, dynamic>>[].obs;
  RxMap<int, Map<String, int>> healthRegionDiseaseData = <int, Map<String, int>>{}.obs;
  RxMap<int, Map<String, int>> healthRegionDiseaseTableData = <int, Map<String, int>>{}.obs;

// ตัวแปรสำหรับโรคความดันโลหิตสูง (สำหรับ health region)
  RxString healthDiseaseHypertensionDisplay = ''.obs;
  RxInt healthDiseaseHypertensionCount = 0.obs;
  RxDouble healthDiseaseHypertensionPercent = 0.0.obs;

// ตัวแปรสำหรับโรคเบาหวาน (สำหรับ health region)
  RxString healthDiseaseDiabetesDisplay = ''.obs;
  RxInt healthDiseaseDiabetesCount = 0.obs;
  RxDouble healthDiseaseDiabetesPercent = 0.0.obs;

// ตัวแปรสำหรับโรคอ้วนลงพุง (สำหรับ health region)
  RxString healthDiseaseObesityDisplay = ''.obs;
  RxInt healthDiseaseObesityCount = 0.obs;
  RxDouble healthDiseaseObesityPercent = 0.0.obs;

// ตัวแปรสำหรับโรคไตวายเรื้อรัง (สำหรับ health region)
  RxString healthDiseaseKidneyDisplay = ''.obs;
  RxInt healthDiseaseKidneyCount = 0.obs;
  RxDouble healthDiseaseKidneyPercent = 0.0.obs;

// ตัวแปรสำหรับโรคหัวใจ (สำหรับ health region)
  RxString healthDiseaseHeartDisplay = ''.obs;
  RxInt healthDiseaseHeartCount = 0.obs;
  RxDouble healthDiseaseHeartPercent = 0.0.obs;

// ตัวแปรสำหรับโรคหลอดเลือดสมอง (สำหรับ health region)
  RxString healthDiseaseStrokeDisplay = ''.obs;
  RxInt healthDiseaseStrokeCount = 0.obs;
  RxDouble healthDiseaseStrokePercent = 0.0.obs;

// ตัวแปรสำหรับโรคไขมันในเลือดสูง (สำหรับ health region)
  RxString healthDiseaseCholesterolDisplay = ''.obs;
  RxInt healthDiseaseCholesterolCount = 0.obs;
  RxDouble healthDiseaseCholesterolPercent = 0.0.obs;

// ตัวแปรสำหรับโรคถุงลมโป่งพอง (สำหรับ health region)
  RxString healthDiseaseEmphysemaDisplay = ''.obs;
  RxInt healthDiseaseEmphysemaCount = 0.obs;
  RxDouble healthDiseaseEmphysemaPercent = 0.0.obs;

// ตัวแปรสำหรับโรคมะเร็ง (สำหรับ health region)
  RxString healthDiseaseCancerDisplay = ''.obs;
  RxInt healthDiseaseCancerCount = 0.obs;
  RxDouble healthDiseaseCancerPercent = 0.0.obs;

// ตัวแปรสำหรับบุหรี่ไฟฟ้า (สำหรับ health region)
  RxString healthE_cigaretteDisplay = ''.obs;
  RxInt healthE_cigaretteCount = 0.obs;
  RxDouble healthE_cigarettePercent = 0.0.obs;

// ฟังก์ชันสำหรับ reset ค่าทั้งหมด (สำหรับ health region)
  void resetHealthDiseaseSummaryValues() {
    healthDiseaseHypertensionCount.value = 0;
    healthDiseaseHypertensionPercent.value = 0.0;
    healthDiseaseDiabetesCount.value = 0;
    healthDiseaseDiabetesPercent.value = 0.0;
    healthDiseaseObesityCount.value = 0;
    healthDiseaseObesityPercent.value = 0.0;
    healthDiseaseKidneyCount.value = 0;
    healthDiseaseKidneyPercent.value = 0.0;
    healthDiseaseHeartCount.value = 0;
    healthDiseaseHeartPercent.value = 0.0;
    healthDiseaseStrokeCount.value = 0;
    healthDiseaseStrokePercent.value = 0.0;
    healthDiseaseCholesterolCount.value = 0;
    healthDiseaseCholesterolPercent.value = 0.0;
    healthDiseaseEmphysemaCount.value = 0;
    healthDiseaseEmphysemaPercent.value = 0.0;
    healthDiseaseCancerCount.value = 0;
    healthDiseaseCancerPercent.value = 0.0;
    healthE_cigaretteCount.value = 0;
    healthE_cigarettePercent.value = 0.0;
  }

  Future<void> fetchGroupByRegionAndCd({required int fiscalYear}) async {
    print('check_access_level = $check_access_level');

    final isAllHospital = hospitalCode == null || hospitalCode == '25039' || hospitalCode == '99999' || hospitalCode == '00000';

    // สร้าง body สำหรับ API
    Map<String, dynamic> body = {
      'fiscal_year': fiscalYear,
    };

    // if (check_access_level == '5') {
    //   // ไม่มีอะไรเพิ่ม
    // } else if (check_access_level == '4') {
    //   body.addAll({
    //     'org_province_code': querylv4
    //   });
    // } else if (check_access_level == '3') {
    //   body.addAll({
    //     'org_province_code': query
    //   });
    // } else {
    //   body.addAll({
    //     'organization_code': [
    //       hospitalCode
    //     ]
    //   });
    // }

    // // เงื่อนไขเฉพาะกรณีที่ไม่ได้อยู่ใน level 3 หรือ 4
    // if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
    //   body.addAll({
    //     'organization_code': [
    //       hospitalCode
    //     ]
    //   });
    // }

    final url = Uri.parse('$baseurl/api/summary/group-by-region-and-cd');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      final response = await _makeAuthenticatedRequest(
        request: () => client.post(url, headers: headers, body: jsonEncode(body)),
      );
      // client.post(url, headers: headers, body: jsonEncode(body));

      // if (response.statusCode == 401) {
      //   //debugPrint('🔐 Token หมดอายุ กำลัง refresh...');
      //   await callAuthAPI(); // รับ token ใหม่
      //   // return await fetchGroupByRegionAndCd(fiscalYear: fiscalYear); // 🔁 เรียกใหม่
      // }

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);
        final dataList = List<Map<String, dynamic>>.from(data['data']);

        // เก็บข้อมูลดิบไว้
        healthRegionCdSummaryList.clear();
        healthRegionCdSummaryList.assignAll(dataList);

        // Reset ค่าทั้งหมดก่อนประมวลผล
        resetHealthDiseaseSummaryValues();

        // สำหรับเก็บข้อมูลแยกตามภูมิภาค (ถ้าต้องการ)
        Map<int, Map<String, int>> healthRegionDiseaseMap = {};

        // สำหรับเก็บข้อมูลแยกตามเขตสุขภาพ
        Map<int, Map<String, int>> healthRegionDiseaseTableMap = {};

        // ประมวลผลข้อมูลแต่ละภูมิภาค
        for (var regionData in dataList) {
          final int regionId = regionData['region_id'] ?? 0;
          final int total = regionData['total'] ?? 0;
          final List<dynamic> cdDisplayList = regionData['cd_display'] ?? [];

          // print('[DEBUG] Processing region_id=$regionId, total=$total');

          // เก็บข้อมูลภูมิภาคนี้
          healthRegionDiseaseMap[regionId] = {};
          healthRegionDiseaseTableMap[regionId] = {};

          // ประมวลผลข้อมูลโรคในแต่ละภูมิภาค
          for (var cdItem in cdDisplayList) {
            final String cdDisplay = cdItem['cd_display'] ?? '';
            final int count = cdItem['count'] ?? 0;

            // print('[DEBUG] region_id=$regionId, disease="$cdDisplay", count=$count');

            // เก็บข้อมูลแยกตามภูมิภาค
            healthRegionDiseaseMap[regionId]![cdDisplay] = count;

            // เก็บข้อมูลแยกตามเขตสุขภาพ (จัดกลุ่มตามชื่อโรคที่เป็นมาตรฐาน)
            String diseaseKey = '';
            switch (cdDisplay) {
              case 'โรคความดันโลหิตสูง':
                diseaseKey = 'hypertension';
                healthDiseaseHypertensionDisplay.value = cdDisplay;
                healthDiseaseHypertensionCount.value += count; // รวมทุกภูมิภาค
                break;
              case 'โรคเบาหวาน':
                diseaseKey = 'diabetes';
                healthDiseaseDiabetesDisplay.value = cdDisplay;
                healthDiseaseDiabetesCount.value += count;
                break;
              case 'โรคอ้วนลงพุง':
                diseaseKey = 'obesity';
                healthDiseaseObesityDisplay.value = cdDisplay;
                healthDiseaseObesityCount.value += count;
                break;
              case 'โรคไตวายเรื้อรัง':
                diseaseKey = 'kidney';
                healthDiseaseKidneyDisplay.value = cdDisplay;
                healthDiseaseKidneyCount.value += count;
                break;
              case 'โรคหัวใจ':
                diseaseKey = 'heart';
                healthDiseaseHeartDisplay.value = cdDisplay;
                healthDiseaseHeartCount.value += count;
                break;
              case 'โรคหลอดเลือดสมอง':
                diseaseKey = 'stroke';
                healthDiseaseStrokeDisplay.value = cdDisplay;
                healthDiseaseStrokeCount.value += count;
                break;
              case 'โรคไขมันในเลือดสูง':
                diseaseKey = 'cholesterol';
                healthDiseaseCholesterolDisplay.value = cdDisplay;
                healthDiseaseCholesterolCount.value += count;
                break;
              case 'โรคถุงลมโป่งพอง':
                diseaseKey = 'copd'; // เปลี่ยนชื่อให้ตรงกับตาราง
                healthDiseaseEmphysemaDisplay.value = cdDisplay;
                healthDiseaseEmphysemaCount.value += count;
                break;
              case 'โรคมะเร็ง':
                diseaseKey = 'cancer';
                healthDiseaseCancerDisplay.value = cdDisplay;
                healthDiseaseCancerCount.value += count;
                break;
              case 'ผู้ใช้บุหรี่ไฟฟ้า':
                diseaseKey = 'e_cigarette';
                healthE_cigaretteDisplay.value = cdDisplay;
                healthE_cigaretteCount.value += count;
                break;
              default:
                print('⚠️ ไม่รู้จักโรค: $cdDisplay');
                continue;
            }

            // เก็บข้อมูลแยกตามเขตสุขภาพ
            if (diseaseKey.isNotEmpty) {
              healthRegionDiseaseTableMap[regionId]![diseaseKey] = count;
            }
          }
        }

        // คำนวณเปอร์เซ็นต์หลังจากรวมข้อมูลทั้งหมดแล้ว
        final totalAllRegions = healthRegionCdSummaryList.fold<int>(0, (sum, item) => sum + ((item['total'] ?? 0) as int));
        if (totalAllRegions > 0) {
          healthDiseaseHypertensionPercent.value = (healthDiseaseHypertensionCount.value / totalAllRegions * 100);
          healthDiseaseDiabetesPercent.value = (healthDiseaseDiabetesCount.value / totalAllRegions * 100);
          healthDiseaseObesityPercent.value = (healthDiseaseObesityCount.value / totalAllRegions * 100);
          healthDiseaseKidneyPercent.value = (healthDiseaseKidneyCount.value / totalAllRegions * 100);
          healthDiseaseHeartPercent.value = (healthDiseaseHeartCount.value / totalAllRegions * 100);
          healthDiseaseStrokePercent.value = (healthDiseaseStrokeCount.value / totalAllRegions * 100);
          healthDiseaseCholesterolPercent.value = (healthDiseaseCholesterolCount.value / totalAllRegions * 100);
          healthDiseaseEmphysemaPercent.value = (healthDiseaseEmphysemaCount.value / totalAllRegions * 100);
          healthDiseaseCancerPercent.value = (healthDiseaseCancerCount.value / totalAllRegions * 100);
          healthE_cigarettePercent.value = (healthE_cigaretteCount.value / totalAllRegions * 100);
        }

        // เก็บข้อมูลแยกตามภูมิภาคไว้ใช้งาน (ถ้าต้องการ)
        healthRegionDiseaseData.value = healthRegionDiseaseMap;

        // เก็บข้อมูลแยกตามเขตสุขภาพไว้สำหรับแสดงในตาราง
        healthRegionDiseaseTableData.value = healthRegionDiseaseTableMap;

        //debugPrint('✅ Region and CD Summary Data Loaded');
      } else {
        //debugPrint('❌ Failed to fetch region and cd summary: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      //debugPrint('🚫 Error fetching region and cd summary: $e');
    }
  }

// ฟังก์ชันสำหรับดึงข้อมูลโรคของเขตสุขภาพ
  int getDiseaseCountByHealthRegion(int regionId, String diseaseKey) {
    return healthRegionDiseaseTableData.value[regionId]?[diseaseKey] ?? 0;
  }

// ฟังก์ชันสำหรับสร้างข้อมูลตารางเขตสุขภาพ
  List<Map<String, dynamic>> getHealthRegionTableData() {
    List<Map<String, dynamic>> tableData = [];

    // สร้างข้อมูลสำหรับแต่ละเขตสุขภาพ
    // for (int regionId in healthRegionDiseaseTableData.value.keys) {
    //   tableData.add({
    //     'region_name': 'เขตสุขภาพที่ $regionId',
    //     'region_id': regionId,
    //     'diabetes': getDiseaseCountByHealthRegion(regionId, 'diabetes'),
    //     'hypertension': getDiseaseCountByHealthRegion(regionId, 'hypertension'),
    //     'cholesterol': getDiseaseCountByHealthRegion(regionId, 'cholesterol'),
    //     'copd': getDiseaseCountByHealthRegion(regionId, 'copd'),
    //     'obesity': getDiseaseCountByHealthRegion(regionId, 'obesity'),
    //     'cancer': getDiseaseCountByHealthRegion(regionId, 'cancer'),
    //     'e_cigarette': getDiseaseCountByHealthRegion(regionId, 'e_cigarette'),
    //     'heart': getDiseaseCountByHealthRegion(regionId, 'heart'),
    //     'stroke': getDiseaseCountByHealthRegion(regionId, 'stroke'),
    //     'kidney': getDiseaseCountByHealthRegion(regionId, 'kidney'),
    //   });
    // }

    for (int regionId = 1; regionId <= 13; regionId++) {
      tableData.add({
        'region_name': 'เขตสุขภาพที่ $regionId',
        'region_id': regionId,
        'diabetes': getDiseaseCountByHealthRegion(regionId, 'diabetes'),
        'hypertension': getDiseaseCountByHealthRegion(regionId, 'hypertension'),
        'kidney': getDiseaseCountByHealthRegion(regionId, 'kidney'),
        'heart': getDiseaseCountByHealthRegion(regionId, 'heart'),
        'stroke': getDiseaseCountByHealthRegion(regionId, 'stroke'),
        'copd': getDiseaseCountByHealthRegion(regionId, 'copd'),
        'cholesterol': getDiseaseCountByHealthRegion(regionId, 'cholesterol'),
        'obesity': getDiseaseCountByHealthRegion(regionId, 'obesity'),
        'e_cigarette': getDiseaseCountByHealthRegion(regionId, 'e_cigarette'),
      });
    }
    // เรียงลำดับตาม region_id
    tableData.sort((a, b) => a['region_id'].compareTo(b['region_id']));

    return tableData;
  }

  //--------
  // ตัวแปรสำหรับเก็บข้อมูล group-by-organization-and-cd
  final RxList<Map<String, dynamic>> healthOrgCdSummaryList = <Map<String, dynamic>>[].obs;
  final RxMap<String, Map<String, int>> healthOrgDiseaseData = <String, Map<String, int>>{}.obs;
  final RxMap<String, Map<String, int>> healthOrgDiseaseTableData = <String, Map<String, int>>{}.obs;

// ฟังก์ชันสำหรับ reset ค่าทั้งหมด (ถ้าต้องการเก็บรวมยอด)
  void resetHealthOrgDiseaseSummaryValues() {
    healthOrgDiseaseData.clear();
    healthOrgDiseaseTableData.clear();
  }

// ฟังก์ชันสำหรับดึงข้อมูล group-by-organization-and-cd
  Future<void> fetchGroupByOrganizationAndCd({required int fiscalYear, int? regionid, orgProvinceCode}) async {
    // เตรียม body
    // final Map<String, dynamic> body = {
    //   'fiscal_year': fiscalYear,
    //   // ถ้าต้องการกรองตาม access level หรือ hospitalCode ให้เพิ่มเงื่อนไขที่นี่
    //   'organization_code': [ hospitalCode ],
    //   'org_province_code': query,
    // };

    final isAllHospital = hospitalCode == null || hospitalCode == '25039' || hospitalCode == '99999' || hospitalCode == '00000';

    // สร้าง body สำหรับ API
    Map<String, dynamic> body = {
      'fiscal_year': fiscalYear,
      'region_id': regionid ?? 0,
      'org_province_code': queryprovince
    };

    // if (check_access_level == '5') {
    //   // ไม่มีอะไรเพิ่ม
    // } else if (check_access_level == '4') {
    //   body.addAll({
    //     'org_province_code': querylv4
    //   });
    // } else if (check_access_level == '3') {
    //   body.addAll({
    //     'org_province_code': query
    //   });
    // } else {
    //   body.addAll({
    //     'organization_code': [
    //       hospitalCode
    //     ]
    //   });
    // }

    // // เงื่อนไขเฉพาะกรณีที่ไม่ได้อยู่ใน level 3 หรือ 4
    // if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
    //   body.addAll({
    //     'organization_code': [
    //       hospitalCode
    //     ]
    //   });
    // }

    final url = Uri.parse('$baseurl/api/summary/group-by-organization-and-cd');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      final resp = await client.post(url, headers: headers, body: jsonEncode(body));

      if (resp.statusCode == 401) {
        await callAuthAPI();
        return fetchGroupByOrganizationAndCd(fiscalYear: fiscalYear);
      }

      if (resp.statusCode != 200) {
        // handle error...
        return;
      }

      final decoded = utf8.decode(resp.bodyBytes);
      final data = jsonDecode(decoded);
      final List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(data['data']);

      // เก็บ raw data
      healthOrgCdSummaryList
        ..clear()
        ..addAll(dataList);

      // reset maps
      resetHealthOrgDiseaseSummaryValues();

      // สร้าง temp maps
      final Map<String, Map<String, int>> orgDiseaseMap = {};
      final Map<String, Map<String, int>> orgDiseaseTableMap = {};

      for (var org in dataList) {
        final String orgCode = org['organization_code'] ?? '';
        final String orgName = org['organization_name'] ?? '';
        final int total = org['total'] ?? 0;
        final List<dynamic> cds = org['cd_display'] ?? [];

        orgDiseaseMap[orgCode] = {};
        orgDiseaseTableMap[orgCode] = {};

        for (var item in cds) {
          final cdName = item['cd_display'] as String? ?? '';
          final count = item['count'] as int? ?? 0;

          // เก็บข้อมูลแยกตาม organization
          orgDiseaseMap[orgCode]![cdName] = count;

          // แปลงเป็น key ตามมาตรฐานเดียวกับ region function
          String key = '';
          switch (cdName) {
            case 'โรคความดันโลหิตสูง':
              key = 'hypertension';
              break;
            case 'โรคเบาหวาน':
              key = 'diabetes';
              break;
            case 'โรคอ้วนลงพุง':
              key = 'obesity';
              break;
            case 'โรคไตวายเรื้อรัง':
              key = 'kidney';
              break;
            case 'โรคหัวใจ':
              key = 'heart';
              break;
            case 'โรคหลอดเลือดสมอง':
              key = 'stroke';
              break;
            case 'โรคไขมันในเลือดสูง':
              key = 'cholesterol';
              break;
            case 'โรคถุงลมโป่งพอง':
              key = 'copd';
              break;
            case 'โรคมะเร็ง':
              key = 'cancer';
              break;
            case 'ผู้ใช้บุหรี่ไฟฟ้า':
              key = 'e_cigarette';
              break;
            default:
              continue;
          }

          orgDiseaseTableMap[orgCode]![key] = count;
        }
      }

      // อัพเดต RxMaps
      healthOrgDiseaseData.value = orgDiseaseMap;
      healthOrgDiseaseTableData.value = orgDiseaseTableMap;

      // ถ้าต้องการคำนวณ % หรือสรุปอื่นๆ ก็ทำต่อจากนี้
    } catch (e) {
      // handle exception...
      print('Error fetchGroupByOrganizationAndCd: $e');
    }
  }

// ฟังก์ชันช่วยดึง count ในตาราง
  int getDiseaseCountByOrganization(String orgCode, String diseaseKey) {
    return healthOrgDiseaseTableData.value[orgCode]?[diseaseKey] ?? 0;
  }

// สร้างข้อมูลสำหรับแสดงตาราง
  List<Map<String, dynamic>> getOrganizationTableData() {
    final List<Map<String, dynamic>> table = [];
    for (var org in healthOrgCdSummaryList) {
      final code = org['organization_code'] as String;
      final provincecode = org['province_code'] as String? ?? '';
      final provincename = getProvinceName(provincecode);
      final registerdatetime = org['register_datetime'] ?? '';
      final stattus = org['status'] as String? ?? '';
      print('จังหวัดที่เลือก: $provincecode → $provincename');
      table.add({
        'organization_code': code,
        'organization_name': org['organization_name'],
        'province_name': provincename,
        'hypertension': getDiseaseCountByOrganization(code, 'hypertension'),
        'diabetes': getDiseaseCountByOrganization(code, 'diabetes'),
        'kidney': getDiseaseCountByOrganization(code, 'kidney'),
        'heart': getDiseaseCountByOrganization(code, 'heart'),
        'stroke': getDiseaseCountByOrganization(code, 'stroke'),
        'copd': getDiseaseCountByOrganization(code, 'copd'),
        'cholesterol': getDiseaseCountByOrganization(code, 'cholesterol'),
        'obesity': getDiseaseCountByOrganization(code, 'obesity'),
        'e_cigarette': getDiseaseCountByOrganization(code, 'e_cigarette'),
        'cancer': getDiseaseCountByOrganization(code, 'cancer'),
        'register_datetime': registerdatetime,
        'status': stattus,
        'total': org['total'],
      });
    }
    return table;
  }
  // List<Map<String, dynamic>> getOrganizationTableData() {
  //   // 1. สร้าง map รหัส→ชื่อ (เอาครั้งแรกที่เจอ)
  //   final Map<String, String> codeToName = {};
  //   for (var org in healthOrgCdSummaryList) {
  //     final code = org['organization_code'] as String;
  //     codeToName.putIfAbsent(code, () => org['organization_name'] as String);
  //   }

  //   // 2. เอารหัสทั้งหมดมาเรียง numeric ascending
  //   final codes = codeToName.keys.toList()
  //     ..sort((a, b) {
  //       final ai = int.tryParse(a) ?? 0;
  //       final bi = int.tryParse(b) ?? 0;
  //       return ai.compareTo(bi);
  //     });

  //   // 3. สร้างลิสต์แถวตามรหัส
  //   final table = <Map<String, dynamic>>[];
  //   for (var code in codes) {
  //     final diseaseMap = healthOrgDiseaseTableData.value[code] ?? {};
  //     table.add({
  //       'organization_code': code,
  //       'organization_name': codeToName[code],
  //       'hypertension': diseaseMap['hypertension'] ?? 0,
  //       'diabetes': diseaseMap['diabetes'] ?? 0,
  //       'kidney': diseaseMap['kidney'] ?? 0,
  //       'heart': diseaseMap['heart'] ?? 0,
  //       'stroke': diseaseMap['stroke'] ?? 0,
  //       'copd': diseaseMap['copd'] ?? 0,
  //       'cholesterol': diseaseMap['cholesterol'] ?? 0,
  //       'obesity': diseaseMap['obesity'] ?? 0,
  //       'e_cigarette': diseaseMap['e_cigarette'] ?? 0,
  //       'total': // ถ้าอยากมี total ก็ตั้งค่าอัพเดตตอน fetchGroupByOrganizationAndCd
  //           (diseaseMap.values.fold<int>(0, (s, v) => s + v)),
  //     });
  //   }

  //   return table;
  // }

  Map<String, String> provinceNames = {
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

// 2. ฟังก์ชันช่วยดึงชื่อจังหวัด
  String getProvinceName(String code) {
    return provinceNames[code] ?? 'ไม่ทราบจังหวัด';
  }

  List<Map<String, dynamic>> get organizationTableData {
    return getOrganizationTableData();
    //final table = _ctrl.organizationTableData;
  }

  //--------

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
    // final usedStart = startDate ?? lastStartDate;
    // final usedEnd = endDate ?? lastEndDate;
    final usedStart = startDate ?? null;
    final usedEnd = endDate ?? null;

    if (apiToken.value.isEmpty) {
      await callAuthAPI();
    }
    final url = Uri.parse('$baseurl/api/n_ncd_list');

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
      "organization_code":
          // '24683', // ใช้รหัสโรงพยาบาลที่ต้องการดึงข้อมูล
          hospitalCode,
      if (usedStart != null && usedEnd != null)
        'register_datetime': {
          'start': usedStart.toUtc().toIso8601String(),
          'end': usedEnd.toUtc().toIso8601String(),
        },
    };

    try {
      isNCDLoading.value = true;
      final response = await _makeAuthenticatedRequest(
        request: () => client.post(url, headers: headers, body: jsonEncode(body)),
      );
      // client.post(
      //   url,
      //   headers: headers,
      //   body: jsonEncode(body),
      // );

      // if (response.statusCode == 401) {
      //   await callAuthAPI();
      //   return fetchNCDList(
      //     name: name,
      //     cid: cid,
      //     cdCode: cdCode,
      //     page: page,
      //   );
      // }

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

// หรือถ้า API รองรับการดึงข้อมูลทั้งหมด
  Future<void> fetchAllNCDListAlternative() async {
    try {
      isNCDLoading(true);

      List<dynamic> allData = [];
      int currentPage = 1;
      int totalPages = 1;

      // Loop เพื่อดึงข้อมูลทุกหน้า
      while (currentPage <= totalPages) {
        final response = await http.get(
          Uri.parse('${baseurl}/api/ncd/list?page=$currentPage&size=100'),
          headers: {
            'Authorization': 'Bearer ${apiToken.value}',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          // เพิ่มข้อมูลในหน้านี้
          if (data['data'] != null) {
            allData.addAll(List<dynamic>.from(data['data']));
          }

          // อัพเดต totalPages จากข้อมูลที่ได้
          if (data['totalPages'] != null) {
            totalPages = data['totalPages'];
          } else if (data['pagination'] != null && data['pagination']['totalPages'] != null) {
            totalPages = data['pagination']['totalPages'];
          }

          currentPage++;
        } else {
          throw Exception('Failed to load NCD data: ${response.statusCode}');
        }
      }

      ncdList.value = List<Map<String, dynamic>>.from(allData);
      print('Fetched total ${allData.length} NCD records from $totalPages pages');
    } catch (e) {
      print('Error fetching all NCD data: $e');
    } finally {
      isNCDLoading(false);
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

    final url = Uri.parse('$baseurl/api/summary/group-by-gender');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      // final response = await client.get(url, headers: headers);
      final response = await _makeAuthenticatedRequest(
        request: () => client.post(url, headers: headers, body: jsonEncode(body)),
      );
      // client.post(url, headers: headers, body: jsonEncode(body));
      // if (response.statusCode == 401) {
      //   //debugPrint('🔐 Token หมดอายุ กำลัง refresh...');
      //   await callAuthAPI(); // รีเฟรช token
      //   return await fetchGroupByGender(fiscalYear: fiscalYear); // 🔁 เรียกซ้ำ
      // }
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
    // if (apiToken.value.isEmpty) {
    //   await callAuthAPI();
    // }

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
    // if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
    //   body.addAll({
    //     'organization_code': [
    //       hospitalCode
    //     ]
    //   });
    // }

    final url = Uri.parse('$baseurl/api/summary/group-by-region');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      // final response = await client.get(url, headers: headers);
      final response = await _makeAuthenticatedRequest(
        request: () => client.post(url, headers: headers, body: jsonEncode(body)),
      );
      // client.post(url, headers: headers, body: jsonEncode(body));

      // if (response.statusCode == 401) {
      //   await callAuthAPI();
      //   // return fetchGroupByRegion(fiscalYear: fiscalYear);
      // }

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
    // if (apiToken.value.isEmpty) {
    //   await callAuthAPI();
    // }

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
    // if (isAllHospital && !(check_access_level == '3' || check_access_level == '4')) {
    //   body.addAll({
    //     'organization_code': [
    //       hospitalCode
    //     ]
    //   });
    // }

    final url = Uri.parse('$baseurl/api/summary/group-by-region');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      // final response = await client.get(url, headers: headers);
      final response = await _makeAuthenticatedRequest(
        request: () => client.post(url, headers: headers, body: jsonEncode(body)),
      );
      //  client.post(url, headers: headers, body: jsonEncode(body));

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

  //------
  // เพิ่มตัวแปรสำหรับเก็บข้อมูลโรงพยาบาล
  RxList<Map<String, dynamic>> hospitalList = <Map<String, dynamic>>[].obs;
  RxBool isLoadingHospitals = false.obs;

  // ฟังก์ชันดึงข้อมูลโรงพยาบาลทั้งหมด
  Future<List<Map<String, dynamic>>> fetchAllHospitals() async {
    if (apiToken.value.isEmpty) {
      await callAuthAPI();
    }

    List<Map<String, dynamic>> allHospitals = [];
    int currentPage = 1;
    int totalPages = 1;

    try {
      isLoadingHospitals.value = true;

      do {
        final url = Uri.parse('$baseurl/api/hospital');
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${apiToken.value}',
        };

        final body = jsonEncode({
          'page': currentPage,
          'page_size': 1000,
        });

        final response = await _makeAuthenticatedRequest(
          request: () => client.post(url, headers: headers, body: body),
        );
        // client.post(url, headers: headers, body: body);

        // if (response.statusCode == 401) {
        //   await callAuthAPI();
        //   continue; // ลองใหม่หลัง refresh token
        // }

        if (response.statusCode == 200) {
          final decoded = utf8.decode(response.bodyBytes);
          final data = jsonDecode(decoded);

          totalPages = data['total_pages'] ?? 1;
          final pageData = List<Map<String, dynamic>>.from(data['data'] ?? []);
          allHospitals.addAll(pageData);

          print('✅ Loaded page $currentPage/$totalPages, hospitals: ${pageData.length}');
          currentPage++;
        } else {
          print('❌ Failed to fetch hospitals page $currentPage: ${response.statusCode}');
          break;
        }
      } while (currentPage <= totalPages);

      hospitalList.assignAll(allHospitals);
      print('✅ Total hospitals loaded: ${allHospitals.length}');
    } catch (e) {
      print('🚫 Error fetching hospitals: $e');
    } finally {
      isLoadingHospitals.value = false;
    }

    return allHospitals;
  }

  // ฟังก์ชันกรองโรงพยาบาลตามจังหวัด
  List<Map<String, dynamic>> getHospitalsByProvince(String provinceCode) {
    return hospitalList.where((hospital) {
      return hospital['province_code'] == provinceCode;
    }).toList();
  }

  // ฟังก์ชันดึงประเภทโรงพยาบาลที่ไม่ซ้ำกันในจังหวัด
  List<String> getUniqueHospitalTypesInProvince(String provinceCode) {
    final hospitalsInProvince = getHospitalsByProvince(provinceCode);
    final typeSet = <String>{};

    for (var hospital in hospitalsInProvince) {
      final typeName = hospital['hospital_type_name']?.toString();
      if (typeName != null && typeName.isNotEmpty) {
        typeSet.add(typeName);
      }
    }

    final sortedTypes = typeSet.toList()..sort();
    return [
      'ทั้งหมด',
      ...sortedTypes
    ];
  }

  // ฟังก์ชันเรียกทั้ง 2 API พร้อมกัน
  Future<void> fetchAllSubmissionData({
    int? fiscalYear,
    List<String>? organizationCode,
    List<String>? orgProvinceCode,
    int? regionId,
  }) async {
    print('Fetching all submission data...');

    // Reset ค่าทั้งหมดก่อน
    resetSubmissionSummaryValues();

    // เรียกทั้ง 2 API พร้อมกัน
    await Future.wait([
      fetchSubmissionStatus(
        fiscalYear: fiscalYear,
        organizationCode: organizationCode,
        orgProvinceCode: orgProvinceCode,
        regionId: regionId,
      ),
      fetchSubmissionOverview(
        fiscalYear: fiscalYear,
        organizationCode: organizationCode,
        orgProvinceCode: orgProvinceCode,
        regionId: regionId,
      ),
    ]);

    print('✅ All submission data loaded successfully');
  }

// ตัวแปรสำหรับเก็บข้อมูล submission-status (กราฟที่ 1)
  RxString submissionStatusTitle = ''.obs;
  RxInt submissionStatusTotal = 0.obs;
  RxInt submissionStatusTotalHospitals = 0.obs;
  RxInt submissionStatusHospitalsSubmitted = 0.obs;
  RxInt submissionStatusHospitalsNotSubmitted = 0.obs;
  RxList<Map<String, dynamic>> submissionStatusData = <Map<String, dynamic>>[].obs;

// ตัวแปรสำหรับเก็บข้อมูล submission-overview (กราฟที่ 2)
  RxString submissionOverviewTitle = ''.obs;
  RxInt submissionOverviewTotal = 0.obs;
  RxInt submissionOverviewTotalHospitals = 0.obs;
  RxInt submissionOverviewHospitalsWithNcd = 0.obs;
  RxInt submissionOverviewHospitalsNeverSubmitted = 0.obs;
  RxList<Map<String, dynamic>> submissionOverviewData = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> submissionOverviewBreakdown = <String, dynamic>{}.obs;

// ตัวแปรสำหรับสถานะการส่งข้อมูลแต่ละประเภท
// กราฟที่ 1: ส่งข้อมูลแล้ว vs ยังไม่ส่งข้อมูล
  RxString statusSubmittedDisplay = ''.obs;
  RxInt statusSubmittedCount = 0.obs;
  RxDouble statusSubmittedPercent = 0.0.obs;

  RxString statusNotSubmittedDisplay = ''.obs;
  RxInt statusNotSubmittedCount = 0.obs;
  RxDouble statusNotSubmittedPercent = 0.0.obs;

// กราฟที่ 2: ส่งครบงวด, รอส่ง, ส่งช้า
  RxString statusExcellentDisplay = ''.obs;
  RxInt statusExcellentCount = 0.obs;
  RxDouble statusExcellentPercent = 0.0.obs;

  RxString statusPendingDisplay = ''.obs;
  RxInt statusPendingCount = 0.obs;
  RxDouble statusPendingPercent = 0.0.obs;

  RxString statusLateDisplay = ''.obs;
  RxInt statusLateCount = 0.obs;
  RxDouble statusLatePercent = 0.0.obs;

// ตัวแปรสำหรับ loading state
  RxBool isLoadingSubmissionStatus = false.obs;
  RxBool isLoadingSubmissionOverview = false.obs;

// ฟังก์ชันสำหรับ reset ค่าทั้งหมด
  void resetSubmissionSummaryValues() {
    // Reset submission status
    statusSubmittedCount.value = 0;
    statusSubmittedPercent.value = 0.0;
    statusNotSubmittedCount.value = 0;
    statusNotSubmittedPercent.value = 0.0;

    // Reset submission overview
    statusExcellentCount.value = 0;
    statusExcellentPercent.value = 0.0;
    statusPendingCount.value = 0;
    statusPendingPercent.value = 0.0;
    statusLateCount.value = 0;
    statusLatePercent.value = 0.0;

    // Clear data lists
    submissionStatusData.clear();
    submissionOverviewData.clear();
    submissionOverviewBreakdown.clear();
  }

// ฟังก์ชันเรียก API submission-status
  Future<void> fetchSubmissionStatus({
    int? fiscalYear,
    List<String>? organizationCode,
    List<String>? orgProvinceCode,
    int? regionId,
  }) async {
    print('Fetching submission status...');

    isLoadingSubmissionStatus.value = true;

    // สร้าง body สำหรับ API
    Map<String, dynamic> body = {};

    if (fiscalYear != null) {
      body['fiscal_year'] = fiscalYear;
    }

    // if (organizationCode != null && organizationCode.isNotEmpty) {
    //   body['organization_code'] = organizationCode;
    // }

    // if (orgProvinceCode != null && orgProvinceCode.isNotEmpty) {
    //   body['org_province_code'] = orgProvinceCode;
    // }

    // if (regionId != null) {
    //   body['region_id'] = regionId;
    // }

    final url = Uri.parse('$baseurl/api/summary/submission-status');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      final response = await _makeAuthenticatedRequest(
        request: () => client.post(url, headers: headers, body: jsonEncode(body)),
      );
      // client.post(url, headers: headers, body: jsonEncode(body));

      // if (response.statusCode == 401) {
      //   await callAuthAPI(); // รับ token ใหม่
      //   // return await fetchSubmissionStatus(
      //   //   fiscalYear: fiscalYear,
      //   //   organizationCode: organizationCode,
      //   //   orgProvinceCode: orgProvinceCode,
      //   //   regionId: regionId,
      //   // ); // เรียกใหม่
      // }

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);

        // เก็บข้อมูลหลัก
        submissionStatusTitle.value = data['title'] ?? '';
        submissionStatusTotal.value = data['total'] ?? 0;
        submissionStatusTotalHospitals.value = data['total_hospitals_in_system'] ?? 0;
        submissionStatusHospitalsSubmitted.value = data['hospitals_submitted'] ?? 0;
        submissionStatusHospitalsNotSubmitted.value = data['hospitals_not_submitted'] ?? 0;

        // เก็บข้อมูล chart data
        final dataList = List<Map<String, dynamic>>.from(data['data'] ?? []);
        submissionStatusData.clear();
        submissionStatusData.assignAll(dataList);

        // ประมวลผลข้อมูลแต่ละประเภท
        for (var item in dataList) {
          final String name = item['name'] ?? '';
          final int value = item['value'] ?? 0;
          final double percentage = (item['percentage'] ?? 0).toDouble();

          switch (name) {
            case 'ส่งข้อมูลแล้ว':
              statusSubmittedDisplay.value = name;
              statusSubmittedCount.value = value;
              statusSubmittedPercent.value = percentage;
              break;
            case 'ยังไม่ส่งข้อมูล':
              statusNotSubmittedDisplay.value = name;
              statusNotSubmittedCount.value = value;
              statusNotSubmittedPercent.value = percentage;
              break;
            default:
              print('⚠️ ไม่รู้จักสถานะ: $name');
          }
        }

        print('✅ Submission Status Data Loaded');
        print('Total: ${submissionStatusTotal.value}');
        print('Submitted: ${statusSubmittedCount.value} (${statusSubmittedPercent.value}%)');
        print('Not Submitted: ${statusNotSubmittedCount.value} (${statusNotSubmittedPercent.value}%)');
      } else {
        print('❌ Failed to fetch submission status: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('🚫 Error fetching submission status: $e');
    } finally {
      isLoadingSubmissionStatus.value = false;
    }
  }

// ฟังก์ชันเรียก API submission-overview
  Future<void> fetchSubmissionOverview({
    int? fiscalYear,
    List<String>? organizationCode,
    List<String>? orgProvinceCode,
    int? regionId,
  }) async {
    print('Fetching submission overview...');

    isLoadingSubmissionOverview.value = true;

    // สร้าง body สำหรับ API
    Map<String, dynamic> body = {};

    if (fiscalYear != null) {
      body['fiscal_year'] = fiscalYear;
    }

    // if (organizationCode != null && organizationCode.isNotEmpty) {
    //   body['organization_code'] = organizationCode;
    // }

    // if (orgProvinceCode != null && orgProvinceCode.isNotEmpty) {
    //   body['org_province_code'] = orgProvinceCode;
    // }

    // if (regionId != null) {
    //   body['region_id'] = regionId;
    // }

    final url = Uri.parse('$baseurl/api/summary/submission-overview');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken.value}',
    };

    try {
      final response = await _makeAuthenticatedRequest(
        request: () => client.post(url, headers: headers, body: jsonEncode(body)),
      );
      // client.post(url, headers: headers, body: jsonEncode(body));

      // if (response.statusCode == 401) {
      //   await callAuthAPI(); // รับ token ใหม่
      //   return await fetchSubmissionOverview(
      //     fiscalYear: fiscalYear,
      //     organizationCode: organizationCode,
      //     orgProvinceCode: orgProvinceCode,
      //     regionId: regionId,
      //   ); // เรียกใหม่
      // }

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);

        // เก็บข้อมูลหลัก
        submissionOverviewTitle.value = data['title'] ?? '';
        submissionOverviewTotal.value = data['total'] ?? 0;
        submissionOverviewTotalHospitals.value = data['total_hospitals_in_system'] ?? 0;
        submissionOverviewHospitalsWithNcd.value = data['hospitals_with_ncd_data'] ?? 0;
        submissionOverviewHospitalsNeverSubmitted.value = data['hospitals_never_submitted'] ?? 0;

        // เก็บข้อมูล breakdown
        if (data['breakdown'] != null) {
          submissionOverviewBreakdown.value = Map<String, dynamic>.from(data['breakdown']);
        }

        // เก็บข้อมูล chart data
        final dataList = List<Map<String, dynamic>>.from(data['data'] ?? []);
        submissionOverviewData.clear();
        submissionOverviewData.assignAll(dataList);

        // ประมวลผลข้อมูลแต่ละประเภท
        for (var item in dataList) {
          final String name = item['name'] ?? '';
          final int value = item['value'] ?? 0;
          final double percentage = (item['percentage'] ?? 0).toDouble();

          switch (name) {
            case 'ส่งตรงเวลา':
              statusExcellentDisplay.value = name;
              statusExcellentCount.value = value;
              statusExcellentPercent.value = percentage;
              break;
            case 'ส่งล่าช้า':
              statusPendingDisplay.value = name;
              statusPendingCount.value = value;
              statusPendingPercent.value = percentage;
              break;
            case 'ยังไม่ส่ง':
              statusLateDisplay.value = name;
              statusLateCount.value = value;
              statusLatePercent.value = percentage;
              break;
            default:
              print('⚠️ ไม่รู้จักสถานะ: $name');
          }
        }

        print('✅ Submission Overview Data Loaded');
        print('Total: ${submissionOverviewTotal.value}');
        print('Excellent: ${statusExcellentCount.value} (${statusExcellentPercent.value}%)');
        print('Pending: ${statusPendingCount.value} (${statusPendingPercent.value}%)');
        print('Late: ${statusLateCount.value} (${statusLatePercent.value}%)');
      } else {
        print('❌ Failed to fetch submission overview: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('🚫 Error fetching submission overview: $e');
    } finally {
      isLoadingSubmissionOverview.value = false;
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
