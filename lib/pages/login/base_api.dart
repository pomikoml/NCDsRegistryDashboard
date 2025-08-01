import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';
import 'package:n_c_ds_registry_dashboard/flutter_flow/flutter_flow_util.dart';
import 'package:n_c_ds_registry_dashboard/pages/login/select_hospital_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CallApiController {
  static String? jwt = '';
  // moph.id.th
  String url_HealthID = 'https://moph.id.th';
  String clientid_HealthID = '9c42a882-3f47-4609-92c5-e4e00a8ea676'; //'9adaeaec-f199-44b2-8219-53346114fc7a';
  String secretkey_HealthID = '0sk5z6Inwu4T52MiK4yfgYYXlBfCNiUofbTcPsb0'; //'KFjr0kc2fdw7p3MTIvHAjmfHqwm0tXmEouvnTGL5';
  // String clientid_HealthID = '9adaeaec-f199-44b2-8219-53346114fc7a';
  // String secretkey_HealthID = 'KFjr0kc2fdw7p3MTIvHAjmfHqwm0tXmEouvnTGL5';

  //  provider.id.th
  String url_ProviderID = 'https://provider.id.th';
  String clientid_ProviderID = '0c3e36fc-b911-43ce-9f92-b8edfae665de'; //'4f85415d-b356-4eb4-aacd-5695a6b9d2bc';
  String secretkey_ProviderID = 'ErnZGAe18VRfbLHOJi9tIXo2zngKE6Rs';
  // String clientid_ProviderID = '4f85415d-b356-4eb4-aacd-5695a6b9d2bc';
  // String secretkey_ProviderID = 'jDWetPKKH4aPmCRFhb91GKTyBUDuRwES';

  static String mophAccessTokenProvider = "";
  static String ProviderAccessToken = "";

  String apiToken = '';
  dynamic responseData;
  dynamic response_hcodeData;
  final client = http.Client();
  final baseurl = EnvService.apiUrl;
  final username = EnvService.username;
  final password = EnvService.password;

  // ฟังก์ชันเพื่อบันทึกค่า userlogin
  _setLoginData(String userLogin, String hospitalCode, String hospitalName, String scopeList, List<String> codes, List<String> hcodelist, String checkAccess) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // เก็บค่าแต่ละฟิลด์
    await prefs.setString('user_login', userLogin);
    await prefs.setString('hospital_code', hospitalCode);
    await prefs.setString('hospital_name', hospitalName);
    await prefs.setString('scope_list', scopeList);
    await prefs.setStringList('org_province_codes', codes);
    await prefs.setStringList('hcodelist', hcodelist);
    await prefs.setString('check_access_level', checkAccess);
  }

  _setmoph_access_token_idp(String moph_access_token_idp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // เก็บค่าแต่ละฟิลด์
    await prefs.setString('moph_access_token_idp', moph_access_token_idp);
  }

  _setCid(String cidonlynumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // เก็บค่าแต่ละฟิลด์
    await prefs.setString('cid', cidonlynumber);
  }

  // เพิ่มตัวแปรเก็บข้อมูลโรงพยาบาลที่ค้นหาได้
  String? foundProvinceCode;
  String? foundProvinceName;
  String? foundHospitalName;
  Map<String, dynamic>? foundHospitalData;

// ฟังก์ชันบันทึกข้อมูลโรงพยาบาลที่ค้นหาได้
  Future<void> saveFoundHospitalData(Map<String, dynamic> hospitalData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('found_hospital_code', hospitalData['hospital_code'] ?? '');
    await prefs.setString('found_hospital_name', hospitalData['hospital_name'] ?? '');
    await prefs.setString('found_province_code', hospitalData['province_code'] ?? '');
    await prefs.setString('found_province_name', hospitalData['province_name'] ?? '');
    await prefs.setString('found_district_code', hospitalData['district_code'] ?? '');
    await prefs.setString('found_district_name', hospitalData['district_name'] ?? '');
    await prefs.setString('found_region_id', hospitalData['region_id']?.toString() ?? '');
    await prefs.setString('found_region_name', hospitalData['region_name'] ?? '');
    await prefs.setString('found_hospital_type_name', hospitalData['hospital_type_name'] ?? '');

    debugPrint('✅ Hospital data saved to SharedPreferences');
  }

  // ปรับปรุงฟังก์ชันค้นหาและเก็บข้อมูล
  Future<void> searchAndStoreHospitalDataAllPages(String rawHcode) async {
    debugPrint('🔍 Starting comprehensive search for hospital: $rawHcode');

    // ค้นหาจากทุกหน้า
    Map<String, dynamic>? hospitalData = await findHospitalByCodeAllPages(rawHcode);

    if (hospitalData != null) {
      // เก็บข้อมูลที่ค้นหาได้
      foundHospitalData = hospitalData;
      foundProvinceCode = hospitalData['province_code'];
      foundProvinceName = hospitalData['province_name'];
      foundHospitalName = hospitalData['hospital_name'];

      debugPrint('✅ Hospital found in multi-page search:');
      debugPrint('   - Code: ${hospitalData['hospital_code']}');
      debugPrint('   - Name: ${hospitalData['hospital_name']}');
      debugPrint('   - Province Code: ${foundProvinceCode}');
      debugPrint('   - Province Name: ${foundProvinceName}');
      debugPrint('   - Region: ${hospitalData['region_name']}');

      // บันทึกลง SharedPreferences
      await saveFoundHospitalData(hospitalData);
    } else {
      debugPrint('❌ Hospital with code $rawHcode not found in any page');
      // ล้างข้อมูลเดิม
      foundHospitalData = null;
      foundProvinceCode = null;
      foundProvinceName = null;
      foundHospitalName = null;
    }
  }

  // ฟังก์ชันค้นหาโรงพยาบาลจากทุกหน้า
  Future<Map<String, dynamic>?> findHospitalByCodeAllPages(String targetHospitalCode) async {
    debugPrint('🔍 Searching for hospital code: $targetHospitalCode');

    if (apiToken.isEmpty) {
      debugPrint('🔄 No API token, calling auth first...');
      bool authSuccess = await callAuthToken();
      if (!authSuccess) {
        debugPrint('❌ Authentication failed, cannot proceed');
        return null;
      }
    }

    int currentPage = 1;
    int pageSize = 100;

    while (true) {
      debugPrint('🔍 Searching page $currentPage...');

      final url_hcode = Uri.parse('$baseurl/api/hospital');
      final headers_hcode = {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $apiToken',
        'Accept': 'application/json',
        'Accept-Charset': 'utf-8',
      };
      final body_hcode = jsonEncode({
        "page": currentPage,
        "page_size": pageSize,
      });

      try {
        final response_hcode = await client.post(
          url_hcode,
          headers: headers_hcode,
          body: body_hcode,
        );

        if (response_hcode.statusCode == 200) {
          // ถอดรหัส UTF-8
          String responseBody;
          try {
            responseBody = utf8.decode(response_hcode.bodyBytes);
          } catch (e) {
            responseBody = response_hcode.body;
          }

          Map<String, dynamic> rawData = jsonDecode(responseBody);
          Map<String, dynamic> pageData = fixEncodingInJson(rawData);

          List<dynamic> hospitals = pageData['data'] ?? [];
          int totalPages = pageData['total_pages'] ?? 1;

          debugPrint('📋 Page $currentPage/$totalPages - ${hospitals.length} hospitals');

          // ค้นหาในหน้าปัจจุบัน
          for (var hospital in hospitals) {
            if (hospital['hospital_code'] == targetHospitalCode) {
              debugPrint('✅ Found hospital: ${hospital['hospital_name']} (Page $currentPage)');
              return hospital;
            }
          }

          // ถ้าหาไม่เจอและยังมีหน้าถัดไป
          if (currentPage < totalPages) {
            currentPage++;
            // เพิ่ม delay เล็กน้อยเพื่อไม่ให้ spam server
            await Future.delayed(Duration(milliseconds: 100));
          } else {
            // หาครบทุกหน้าแล้ว
            break;
          }
        } else {
          debugPrint('❌ Hospital API Failed: ${response_hcode.statusCode}');
          break;
        }
      } catch (e) {
        debugPrint('🚫 Error calling Hospital API: $e');
        break;
      }
    }

    debugPrint('❌ Hospital with code $targetHospitalCode not found in all pages');
    return null;
  }

// ปรับปรุง callAuthToken() ให้ return boolean เพื่อให้ทราบสถานะ
  Future<bool> callAuthToken() async {
    debugPrint('🔄 Calling Auth Token API...');

    final url = Uri.parse('$baseurl/api/auth');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "username": username,
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
        apiToken = responseData['access_token'] ?? '';

        if (apiToken.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('apiToken', apiToken);
          debugPrint('✅ Auth Success - Token saved');
          return true;
        } else {
          debugPrint('❌ Auth Success but no token received');
          return false;
        }
      } else {
        debugPrint('❌ Auth Failed: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('🚫 Error calling Auth API: $e');
      return false;
    }
  }

  String decodeUtf8(String input) {
    try {
      // ลองถอดรหัส UTF-8 หลายแบบ
      List<int> bytes = latin1.encode(input);
      return utf8.decode(bytes);
    } catch (e) {
      // ถ้าไม่สำเร็จ return ค่าเดิม
      return input;
    }
  }

  // ฟังก์ชันแก้ไขข้อมูล JSON ที่มีปัญหา encoding
  Map<String, dynamic> fixEncodingInJson(Map<String, dynamic> data) {
    Map<String, dynamic> fixedData = {};

    data.forEach((key, value) {
      if (value is String) {
        fixedData[key] = decodeUtf8(value);
      } else if (value is Map<String, dynamic>) {
        fixedData[key] = fixEncodingInJson(value);
      } else if (value is List) {
        fixedData[key] = value.map((item) {
          if (item is Map<String, dynamic>) {
            return fixEncodingInJson(item);
          } else if (item is String) {
            return decodeUtf8(item);
          }
          return item;
        }).toList();
      } else {
        fixedData[key] = value;
      }
    });

    return fixedData;
  }

// หรือถ้าต้องการให้ callHospitalCode() ตรวจสอบก่อนเรียก
  Future<void> callHospitalCodeSafe() async {
    // ตรวจสอบว่ามี apiToken หรือไม่
    if (apiToken.isEmpty) {
      debugPrint('🔄 No API token, calling auth first...');
      bool authSuccess = await callAuthToken();
      if (!authSuccess) {
        debugPrint('❌ Authentication failed, cannot proceed');
        return;
      }
    }

    // ตรวจสอบอีกครั้งหลังจาก auth
    if (apiToken.isEmpty) {
      debugPrint('❌ Still no API token after authentication');
      return;
    }

    debugPrint('✅ Using API Token: ${apiToken.substring(0, 20)}...');

    final url_hcode = Uri.parse('$baseurl/api/hospital');
    final headers_hcode = {
      'Content-Type': 'application/json; charset=utf-8', // เพิ่ม charset
      'Authorization': 'Bearer $apiToken',
      'Accept': 'application/json', // เพิ่ม Accept header
      'Accept-Charset': 'utf-8', // เพิ่ม Accept-Charset
    };
    final body_hcode = jsonEncode({
      "page_size": 100,
    });

    try {
      final response_hcode = await client.post(
        url_hcode,
        headers: headers_hcode,
        body: body_hcode,
      );

      if (response_hcode.statusCode == 200) {
        // ตรวจสอบ Content-Type ของ response
        String? contentType = response_hcode.headers['content-type'];
        debugPrint('📋 Response Content-Type: $contentType');

        // ถอดรหัส response body ด้วย UTF-8
        String responseBody;
        try {
          responseBody = utf8.decode(response_hcode.bodyBytes);
        } catch (e) {
          debugPrint('⚠️ UTF-8 decode failed, using response.body');
          responseBody = response_hcode.body;
        }

        // Parse JSON
        Map<String, dynamic> rawData = jsonDecode(responseBody);

        // แก้ไข encoding ใน JSON
        response_hcodeData = fixEncodingInJson(rawData);

        debugPrint('✅ Hospital Success: Total ${response_hcodeData['total']} items');

        // แสดงตัวอย่างข้อมูลที่แก้ไขแล้ว
        if (response_hcodeData['data'] != null && response_hcodeData['data'].isNotEmpty) {
          var firstHospital = response_hcodeData['data'][0];
          debugPrint('📋 Sample hospital data:');
          debugPrint('   - Code: ${firstHospital['hospital_code']}');
          debugPrint('   - Name: ${firstHospital['hospital_name']}');
          debugPrint('   - Province: ${firstHospital['province_name']}');
        }
      } else {
        debugPrint('❌ Hospital API Failed: ${response_hcode.statusCode} ${response_hcode.body}');
      }
    } catch (e) {
      debugPrint('🚫 Error calling Hospital API: $e');
    }
  }

  Future<bool> GetMophTokenProvider(String code, redirectUrl) async {
    print('GetMophTokenProvider');
    // Path1
    String apiUrl = "https://moph.id.th/api/v1/token";

    final payload = {
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": '$redirectUrl',
      "client_id": clientid_HealthID,
      "client_secret": secretkey_HealthID
    };

    //debugPrint('Body $payload');

    final headers = {
      "Content-Type": "application/json",
    };

    try {
      final url = Uri.parse(apiUrl);
      final response = await http.Client().post(url, body: jsonEncode(payload), headers: headers);
      //debugPrint("Provider : ${response.body}");
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      debugPrint("decodedData : ${decodedData['data']}");
      if (decodedData['status_code'] == 200) {
        mophAccessTokenProvider = decodedData['data']['access_token'].toString();
        // _setAccesstoken(mophAccessTokenProvider);

        return true;
      } else {
        return false;
      }
    } catch (error) {
      //debugPrint('error: $error');
      return false;
    }
  }

  Future<bool> GetMophAccount() async {
    log('=======================================================');
    // Path2
    String apiUrl = "https://moph.id.th/api/v1/accounts";
    final url = Uri.parse('${apiUrl}');

    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $mophAccessTokenProvider',
    };

    try {
      final response = await http.Client().get(url, headers: headers);
      Map<String, dynamic> decodedData = await jsonDecode(response.body);

      debugPrint('res.body Path2 : ${decodedData}');
      //debugPrint('CID ${Jwt.parseJwt(decodedData['data']['id_card_encrypt'])}');

      if (decodedData['status_code'] == 200) {
        // Map<String, dynamic> cidData = Jwt.parseJwt(decodedData['data']['id_card_encrypt']);

        // EHPMobile.loginName = cidData['cid'] ?? '';

        // log('EHPMobile.loginName : ${decodedData['data']['id_card_encrypt']}');
        Map<String, dynamic> decodedToken = JwtDecoder.decode(decodedData['data']['id_card_encrypt']);
        // print("Decoded Token: $decodedToken");

        // ดึงค่า 'cid' และกรองเฉพาะตัวเลข
        String cid = decodedToken['cid'] ?? '';
        String onlyNumbers = cid.replaceAll(RegExp(r'[^0-9]'), '');

        _setCid(onlyNumbers);

        // print("เฉพาะตัวเลข: $onlyNumbers");

        return true;
      } else {
        return false;
      }
    } catch (error) {
      log("Error: $error");
      return false;
    }
  }

  Future<bool> GetProviderToken() async {
    log('=======================================================');
    // Path3
    String apiUrl = "https://provider.id.th/api/v1/services/token";
    final payload = {
      "client_id": clientid_ProviderID,
      "secret_key": secretkey_ProviderID,
      "token_by": "Health ID",
      "token": mophAccessTokenProvider,
    };
    final headers = {
      "Content-Type": "application/json",
    };

    try {
      final url = Uri.parse('${apiUrl}');
      final response = await http.Client().post(url, body: jsonEncode(payload), headers: headers);
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      log('res.body Path 3 : ${decodedData}');
      // print("Provider GetProviderToken=" + decodedData.toString());
      if (decodedData['status'] == 200) {
        // print("MessageCode 200");

        log("ProviderID GetProviderToken Success");
        ProviderAccessToken = decodedData['data']['access_token'].toString();
        return true;
      } else {
        ProviderAccessToken = "";
        // message_th
        return false;
      }
    } catch (error) {
      log("Error: $error");
      return false;
    }
  }

  Map<String, dynamic> decodeJWT(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid JWT');
    final payload = base64Url.normalize(parts[1]);
    return jsonDecode(utf8.decode(base64Url.decode(payload)));
  }

  List<String> extractProvinceCodes(String accessCodeLevel3) {
    final cleaned = accessCodeLevel3.replaceAll('"', '').replaceAll("'", '').split(',').map((e) => e.trim()).where((e) => e.length >= 2).map((e) => e.substring(0, 2)).toSet().toList();
    return cleaned;
  }

  Future<void> saveProvinceCodes(List<String> codes) async {}

  Future<bool> GetProviderProfileStaff(BuildContext context) async {
    log('=======================================================');
    String //jwt = '',
        StaffName = '',
        StaffPosition = '',
        hospital_code = '',
        hospital_name = '';
    // Path4
    String apiUrl = "https://provider.id.th/api/v1/services/moph-idp/profile-staff";
    //String apiUrl = "https://provider.id.th/api/v1/services/profile?moph_center_token=1";
    final payload = {
      "client_id": clientid_ProviderID,
      "secret_key": secretkey_ProviderID,
    };

    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $ProviderAccessToken',
    };

    try {
      final url = Uri.parse(apiUrl);
      final response = await http.Client().post(url, body: jsonEncode(payload), headers: headers);
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      log('res.body Path4 $decodedData');
      log('res.body Path4  moph_access_token_idp ${decodedData['data']['organization'][0]['moph_access_token_idp'].toString()}');
      await _setmoph_access_token_idp(decodedData['data']['organization'][0]['moph_access_token_idp'].toString());
      // print("Provider GetProviderProfileStaff " + decodedData.toString());
      // print("Provider GetProviderProfileStaff " + decodedData.toString());
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('moph_access_token_idp');
      final savedhospitaltoken;
      log('Saved token in SharedPreferences: $savedToken');

      await prefs.setString('ProviderAccessToken', ProviderAccessToken);

      if (decodedData['status'] == 200) {
        //debugPrint("ProviderID GetProviderProfileStaff Success");
        //debugPrint('---------------------------------------------');
        List<dynamic> organizationList = decodedData['data']['organization'];

        if (organizationList.isNotEmpty) {
          log('Organization List : $organizationList');
          List<String> hcodeList
              // hcodeList = [
              //   '10857'
              // ];
              = organizationList.map((org) => org['hcode']?.toString()).whereType<String>().where((hcode) => hcode.isNotEmpty).toList();

          //debugPrint('----------------------------------1-----------');
          dynamic itemHospital;

          // itemHospital = await Get.to(() => SelectHospitalWidget(hList: organizationList));

          if (organizationList.length != 1) {
            // itemHospital = await Get.to(() => SelectHospitalWidget(hList: organizationList));
            // itemHospital = await
            // Navigator.push(context,
            // MaterialPageRoute(builder: (context) => SelectHospitalWidget(hList: organizationList)));
            // final itemHospital = await context.push<List<dynamic>>(
            //   '/selectHospital',
            //   extra: organizationList,
            // );

            // itemHospital = organizationList[1];

            final castedList = organizationList.cast<Map<String, dynamic>>();

            final controller = Get.find<HospitalController>();
            controller.organizationList.value = castedList;

            controller.logCurrentState();

            itemHospital = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectHospitalWidget()));
            // savedhospitaltoken = itemHospital['data']['moph_access_token_idp'];

            print('[Debug] itemHospital = ${itemHospital['moph_access_token_idp']}');
            if (itemHospital == null) {
              return false;
            }
          } else {
            // itemHospital = await

            itemHospital = organizationList[0];
          }
          if (itemHospital != null && itemHospital['position'] != null) {
            log('StaffName : ${decodedData['data']['name_th'].toString()}');
            log('StaffPosition : ${itemHospital['position'].toString()}');
            log('hospital_code : ${itemHospital['hcode'].toString()}');
            log('hospital_name : ${itemHospital['hname_th'].toString()}');
            log('mophAccessTokenProvider : ${mophAccessTokenProvider}');

            print('Saved token in SharedPreferences: $itemHospital');
            final decoded = decodeJWT(itemHospital['moph_access_token_idp']!);
            final accessCode = decoded['client']?['access_code_level3'] ?? '';
            final checkaccess4 = decoded['client']?['access_code_level4'] ?? '';
            final provinceCodes = extractProvinceCodes(accessCode);
            // ดึงค่า access_code_level3 มาตรวจสอบ
            final accessCodeLevel3 = decoded['client']?['access_code_level3'] ?? '';
            final accessCodeLevel5 = decoded['client']?['access_code_level5'] ?? '';

            final client = decoded['client'] ?? {};
            String checkAccess = '1'; // ค่าเริ่มต้น

            // ใช้ hospital code จริงจาก itemHospital
            final String hospitalCode = '24683';
            // itemHospital['hcode'] as String;

            log('🔍 Checking Access Level for Hospital Code: $hospitalCode');

            // ตรวจสอบลำดับความสำคัญ: Level 5 → 4 → 3 → 1

            // Priority 1: Access Level 5 (Specific Hospital Codes)
            if (isAccessLevel5Hospital(hospitalCode) || !isEmptyOrQuotes(accessCodeLevel5)) {
              checkAccess = '5';
              log('🔄 Access Level upgraded to 5 (Specific Hospital Codes)');

              await callHospitalCodeSafe();
              await searchAndStoreHospitalDataAllPages(hospitalCode);

              if (foundProvinceCode != null) {
                log('✅ Found Province Code: $foundProvinceCode');

                if (!provinceCodes.contains(foundProvinceCode)) {
                  provinceCodes.add(foundProvinceCode!);
                  log('✅ Added province code $foundProvinceCode to provinceCodes');
                } else {
                  log('ℹ️ Province code $foundProvinceCode already exists, skipping');
                }
              }
            }
            // Priority 2: Access Level 4 (Has access_code_level4)
            else if (!isEmptyOrQuotes(checkaccess4)) {
              checkAccess = '4';
              log('🔄 Access Level upgraded to 4 (Has access_code_level4: $checkaccess4)');

              await callHospitalCodeSafe();
              await searchAndStoreHospitalDataAllPages(hospitalCode);

              if (foundProvinceCode != null) {
                log('✅ Found Province Code: $foundProvinceCode');

                if (!provinceCodes.contains(foundProvinceCode)) {
                  provinceCodes.add(foundProvinceCode!);
                  log('✅ Added province code $foundProvinceCode to provinceCodes');
                } else {
                  log('ℹ️ Province code $foundProvinceCode already exists, skipping');
                }
              }
            }
            // Priority 3: Access Level 3 (Hospital Range 00001-00075)
            else if ((hospitalCode.compareTo('00001') >= 0 && hospitalCode.compareTo('00075') <= 0) || hospitalCode == '24683' || !isEmptyOrQuotes(accessCodeLevel3)) {
              checkAccess = '3';
              log('🔄 Access Level upgraded to 3 (Hospital Range: 00001-00075)    24683 บึงกาฬจังหวัดใหม่');

              await callHospitalCodeSafe();
              await searchAndStoreHospitalDataAllPages(hospitalCode);

              if (foundProvinceCode != null) {
                log('✅ Found Province Code: $foundProvinceCode');

                if (!provinceCodes.contains(foundProvinceCode)) {
                  provinceCodes.add(foundProvinceCode!);
                  log('✅ Added province code $foundProvinceCode to provinceCodes');
                } else {
                  log('ℹ️ Province code $foundProvinceCode already exists, skipping');
                }
              }
            }
            // Priority 4: Access Level 1 (Default - ไม่เข้าเงื่อนไขไหนเลย)
            else {
              checkAccess = '1';
              log('ℹ️ Access Level remains 1 (Default - No special conditions met)');
              log('Hospital Code: $hospitalCode does not meet any upgrade criteria');
            }

            await handleAccessLevel4(decoded);

            print('[DEBUG] provinceCodes: $provinceCodes');
            print('[DEBUG] hcodeList: $hcodeList');
            print('[DEBUG] Access Level Highest: $checkAccess');
            // itemHospital['hcode']
            _setLoginData(decodedData['data']['name_th'], itemHospital['hcode'], itemHospital['hname_th'], itemHospital['position'], provinceCodes, hcodeList, checkAccess);

            jwt = itemHospital['moph_access_token_idp'].toString();
            // Endpoints.apiIDPJWT = itemHospital['moph_access_token_idp'].toString();
            // EHPMobile.userName = decodedData['data']['name_th'].toString();
            // EHPMobile.hospitalCode = itemHospital['hcode'].toString();
            // EHPMobile.hospitalName = itemHospital['hname_th'].toString();
            // log('res.body Path4  moph_access_token_idp ${jwt}');
          }
        } else {
          log('Error: itemHospital or position is null');
        }

        // //debugPrint('Setting EHPMobile.hospitalCode = ${EHPMobile.hospitalCode}...');
        // //debugPrint('Setting Old getBaseURLDio = ${serviceLocator<EHPApi>().dioClient.getBaseURLDio()}...');
        // serviceLocator<EHPApi>().dioClient.changeBaseURL('https://wg3.bmscloud.in.th/${EHPMobile.hospitalCode}/phapi');

        //serviceLocator<EHPApi>().dioClient.changeBaseURL('http://192.168.21.164:27778/hosapi');
        // //debugPrint('Setting New getBaseURLDio = ${serviceLocator<EHPApi>().dioClient.getBaseURLDio()}...');

        // Endpoints.baseUrl = serviceLocator<EHPApi>().dioClient.getBaseURLDio();
        // try {
        //   //debugPrint('Action=USER...');
        //   DioClient dioClient = DioClient(Dio());
        //   final DioResponse response = await dioClient.post(
        //     '${Endpoints.tokenPath}?Action=USER',
        //     data: {
        //       'moph_jwt': jwt,
        //     },
        //     authHeader: Endpoints.apiSessionToken,
        //   );
        //   if (EHPApi.checkResponseIsValid(response)) {
        //     //debugPrint('moph_jwt : $jwt');
        //     //debugPrint('needOTP With Provider : $response');
        //     log('getUserJWTFromMOPHIDP...');
        //     //debugPrint('result_jwt:${response.data['result']}');
        //     //debugPrint('idp_jwt:${response.data['idp_jwt']}');

        //     // if (response.data['idp_jwt'] == '') {
        //     Endpoints.apiUserJWT = response.data['result'].toString();

        //     //debugPrint('Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');

        //     if (Endpoints.apiUserJWT.isNotEmpty) {
        //       Endpoints.apiUserJWTPayload = Jwt.parseJwt(Endpoints.apiUserJWT);
        //       // //debugPrint('Endpoints.apiUserJWTPayload = ${Endpoints.apiUserJWTPayload}');

        //       //debugPrint('client.profile = ${Endpoints.apiUserJWTPayload['client']['profile']}');

        //       EHPMobile.loginName = Endpoints.apiUserJWTPayload['client']['profile']['cid'] ?? '';
        //       EHPMobile.userName = Endpoints.apiUserJWTPayload['client']['profile']['full_name'] ?? '';

        //       EHPMobile.hospitalAddressCode = Endpoints.apiUserJWTPayload['client']['profile']['hospital_address_code'] ?? '';
        //       EHPMobile.hospitalProvinceName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_province_name'] ?? '';
        //       EHPMobile.hospitalDistrictName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_district_name'] ?? '';
        //       EHPMobile.hospitalTambolName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_tambol_name'] ?? '';
        //     }

        //     // } else {
        //     //   DioResponse responses = await serviceLocator<EHPApi>().getUserJWTFromMOPHIDP(response.data['result'] ?? '');
        //     //   await EHPMobile.prefs.write('app:user:idp_jwt', EHPApi.encryptWithAES("This 32 char key have 256 bits..", response.data['idp_jwt'] ?? '').base64);
        //     //   //debugPrint('receive responses $responses');
        //     // }

        //     log('[HospitalCode]:${EHPMobile.hospitalCode}');
        //     log('[ApiToken]:${Endpoints.apiJWT}');
        //     log('[ApiUserToken]:${Endpoints.apiUserJWT}');
        //   } else {
        //     await EHPApi.showAPIErrorDialog(response);
        //   }
        // } catch (e) {
        //   //debugPrint('getUserJWT ERROR:$e');
        //   await EHPApi.showErrorDialog(e.toString());

        //   //return DioResponse(data: {}, requestOptions: RequestOptions(), statusCode: 500, statusMessage: 'Request Failed');
        // }

        return true;
        // print("Provider moph_access_token_idp " + decodedData['data']['organization'][0]['moph_access_token_idp']);
      } else {
        // JWT = "";
        // await prefs.setString('ProviderAccessToken', "");
        return false;
      }
    } catch (error) {
      log("Error: $error");
      // JWT = "";
      return false;
    }
  }

  bool isEmptyOrQuotes(String value) {
    if (value.isEmpty) return true;

    String trimmed = value.trim();
    if (trimmed.isEmpty) return true;

    // จับกรณี "''" หรือ"''" หรือ "null" หรือ "undefined"
    if (trimmed == "''" || trimmed == '""' || trimmed == 'null' || trimmed == 'undefined' || trimmed == '0') {
      return true;
    }

    return false;
  }

  // ฟังก์ชันตรวจสอบ Access Level 5
  bool isAccessLevel5Hospital(String hospitalCode) {
    // รายการโรงพยาบาลที่ได้ Access Level 5
    const List<String> level5Hospitals = [
      '41300',
      '14165',
      '25039',
    ];

    bool isLevel5 = level5Hospitals.contains(hospitalCode);

    if (isLevel5) {
      log('✅ Hospital $hospitalCode is in Access Level 5 list');
    } else {
      log('ℹ️ Hospital $hospitalCode is not in Access Level 5 list');
    }

    return isLevel5;
  }

  Future<void> handleAccessLevel4(Map<String, dynamic> decoded) async {
    final checkaccess4 = decoded['client']?['access_code_level4'] ?? '';

    // ใช้ helper function เดียวกัน
    if (isEmptyOrQuotes(checkaccess4)) {
      print('❌ Access Level 4: ไม่มีข้อมูล (value: "$checkaccess4")');
      return;
    }

    print('✅ Access Level 4: มีข้อมูล = "$checkaccess4"');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // รหัสจังหวัดของเขตนั้นๆ ที่ตรงกับ checkaccess4
    final matchingProvinces = provinceToRegionMap.entries.where((entry) => entry.value == checkaccess4).map((entry) => entry.key).toList();

    // Debug
    print('Access Level 4: เขต $checkaccess4');
    print('จังหวัดในเขตนี้: $matchingProvinces');

    // Save to SharedPreferences
    await prefs.setStringList('access_level4_province_codes', matchingProvinces);
  }

  final Map<String, String> provinceToRegionMap = {
    '50': '1',
    '51': '1',
    '52': '1',
    '53': '1',
    '54': '1',
    '55': '1',
    '56': '1',
    '57': '1',
    '58': '1',
    '60': '2',
    '61': '2',
    '62': '2',
    '63': '2',
    '64': '2',
    '65': '2',
    '66': '2',
    '67': '2',
    '70': '3',
    '71': '3',
    '72': '3',
    '73': '3',
    '74': '3',
    '75': '3',
    '76': '3',
    '77': '3',
    '13': '4',
    '14': '4',
    '15': '4',
    '16': '4',
    '17': '4',
    '18': '4',
    '19': '4',
    '12': '4',
    '40': '5',
    '44': '5',
    '45': '5',
    '46': '5',
    '47': '5',
    '48': '5',
    '20': '6',
    '21': '6',
    '22': '6',
    '23': '6',
    '24': '6',
    '25': '6',
    '26': '6',
    '27': '6',
    '11': '6',
    '30': '7',
    '31': '7',
    '32': '7',
    '33': '7',
    '39': '8',
    '41': '8',
    '42': '8',
    '43': '8',
    '34': '9',
    '35': '9',
    '36': '9',
    '37': '9',
    '38': '9',
    '80': '10',
    '81': '10',
    '82': '10',
    '83': '10',
    '84': '10',
    '85': '10',
    '86': '10',
    '90': '11',
    '91': '11',
    '92': '11',
    '93': '11',
    '94': '12',
    '95': '12',
    '96': '12',
    '10': '13',
  };
}
