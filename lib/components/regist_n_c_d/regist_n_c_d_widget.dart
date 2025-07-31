import 'dart:convert';

import 'package:get/get.dart';
import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/delete_data/delete_data_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'regist_n_c_d_model.dart';
export 'regist_n_c_d_model.dart';
import 'package:http/http.dart' as http;

class RegistNCDWidget extends StatefulWidget {
  const RegistNCDWidget({super.key, this.NCDscid, this.NCDscdcode});

  final String? NCDscid;
  final String? NCDscdcode;

  @override
  State<RegistNCDWidget> createState() => _RegistNCDWidgetState();
}

class _RegistNCDWidgetState extends State<RegistNCDWidget> {
  late RegistNCDModel _model;

  final getX = Get.find<NCDsgetX>();

  String cid = '';
  String cdcode = '';

  // final baseurl = 'http://192.168.30.73:8000';
  // final baseurl = 'http://127.0.0.1:18001';
  final client = http.Client();
  final baseurl = EnvService.apiUrl;
  final username = EnvService.username;
  String apiToken = '';
  RxList<Map<String, dynamic>> ncdList = <Map<String, dynamic>>[].obs;
  // Int currentPage = 1;
  // Int totalPages = 1;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegistNCDModel());

    cid = widget.NCDscid ?? '';
    cdcode = widget.NCDscdcode ?? '';
    print(' cid : $cid');
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getX.fetchNCDList();
    // });
    loadTokenFromStorage();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('apiToken');
    if (storedToken != null && storedToken.isNotEmpty) {
      apiToken = storedToken;
      await fetchNCDList();
      //debugPrint('📦 Token loaded from SharedPreferences');
      setState(() {});
    } else {
      //debugPrint('⚠️ No token found');
    }
  }

  Future<void> fetchNCDList({
    int page = 1,
    int pageSize = 20,
  }) async {
    if (page < 1) return;

    final url = Uri.parse('$baseurl/api/n_ncd_list');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiToken}',
    };
    final body = {
      'patient_name_text': '',
      'cid': cid,
      'cd_code': cdcode,
      'page': 1,
      'page_size': 1,
    };

    try {
      final response = await client.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decoded);
        ncdList.assignAll(List<Map<String, dynamic>>.from(data['data']));
        // currentPage.value = data['page'];
        // totalPages.value = data['total_pages'];
        print('  fetching NCD list');
      } else {
        ncdList.clear();
      }
    } catch (e) {
      print('🚫 Error fetching NCD list: $e');
    } finally {}
  }

  String mapToDiseaseCategory(String conditionText, String cdDisplay) {
    final rawCode = conditionText.split(':').first;
    final code = rawCode.length >= 3 ? rawCode.substring(0, 3) : rawCode;
    if ([
      'I20',
      'I21',
      'I22',
      'I23',
      'I24',
      'I25'
    ].contains(code)) {
      return 'โรคหัวใจ';
    }
    if ([
      'I60',
      'I61',
      'I62',
      'I63',
      'I64',
      'I65',
      'I66',
      'I67',
      'I68',
      'I69'
    ].contains(code)) {
      return 'โรคหลอดเลือดสมอง';
    }
    // ถ้าไม่ตรงกลุ่มข้างบน ให้ fallback ไปใช้ cdDisplay
    return cdDisplay;
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  String formatBuddhistDate(DateTime? date) {
    // ถ้า date เป็น null ให้คืน '-'
    if (date == null) return '-';

    // เช็ค sentinel วันที่ 1/1/1970 CE (== 1/1/2513 BE) ก็คืน '-'
    if ((date.year == 1900 || date.year == 1970) && date.month == 1 && date.day == 1) {
      return '-';
    }

    final buddhistYear = date.year + 543;
    return DateFormat('dd/MM/yyyy').format(
      DateTime(buddhistYear, date.month, date.day),
    );
  }

  String formatTimeOnly(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final NCDPatient? item = ncdList.isNotEmpty ? NCDPatient.fromJson(ncdList.first) : null;

    // 1) ถ้า item ยังเป็น null ให้รีเทิร์น loading เลย
    if (item == null) {
      return Center(child: CircularProgressIndicator());
    }

    // 2) ณ จุดนี้ item ไม่ null แล้ว จึงเรียกใช้ได้อย่างปลอดภัย
    final category = mapToDiseaseCategory(
      item.conditionText,
      item.cdDisplay,
    );

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 750.0,
        decoration: BoxDecoration(
          color: Color(0xFFF2F5F7),
          boxShadow: [
            BoxShadow(
              blurRadius: 24.0,
              color: Color(0x1E666666),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
              child: Row(
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
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Icon(
                          Icons.contact_page,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 16.0,
                        ),
                      ),
                      Text(
                        'ข้อมูลผู้ที่ถูกขึ้นทะเบียน NCD',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                            ),
                      ),
                    ].divide(SizedBox(width: 8.0)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'เลข 13 หลัก',
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          font: GoogleFonts.sarabun(
                                            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                      ),
                                ),
                                Text(
                                  // '1330456373369',
                                  '${item.cid}',
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'ชื่อผู้รับบริการ',
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          font: GoogleFonts.sarabun(
                                            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                      ),
                                ),
                                Text(
                                  // 'ชายดม ละศรีจันทร์',
                                  '${item.name}',
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'วันเกิด',
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          font: GoogleFonts.sarabun(
                                            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                      ),
                                ),
                                Text(
                                  // '12/03/2544',
                                  formatBuddhistDate(item.birthDate),
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'หมู่เลือด',
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          font: GoogleFonts.sarabun(
                                            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                      ),
                                ),
                                Text(
                                  '-',
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'วันที่เริ่มเป็น',
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          font: GoogleFonts.sarabun(
                                            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                      ),
                                ),
                                Text(
                                  // '12/03/2568',
                                  formatBuddhistDate(item.beginDatetime),
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'วันที่ขึ้นทะเบียนกลาง',
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          font: GoogleFonts.sarabun(
                                            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                      ),
                                ),
                                Text(
                                  // '15:00',
                                  // '${item.registerDatetime}',
                                  formatBuddhistDate(item.registerDatetime),
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100.0,
                                      decoration: BoxDecoration(),
                                      child: Text(
                                        'Condition',
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              font: GoogleFonts.sarabun(
                                                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: FlutterFlowTheme.of(context).labelMedium.override(
                                            font: GoogleFonts.sarabun(
                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        height: 88.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                          borderRadius: BorderRadius.circular(14.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            // 'E119:24.คลินิกเบาหวาน:24.คลินิกเบาหวา\n',
                                            '${item.conditionText}',
                                            maxLines: 3,
                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                  font: GoogleFonts.sarabun(
                                                    fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                  lineHeight: 1.5,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                              ].divide(SizedBox(height: 6.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100.0,
                                      decoration: BoxDecoration(),
                                      child: Text(
                                        'Description',
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              font: GoogleFonts.sarabun(
                                                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: FlutterFlowTheme.of(context).labelMedium.override(
                                            font: GoogleFonts.sarabun(
                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        height: 88.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                          borderRadius: BorderRadius.circular(14.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            // 'E119:24.คลินิกเบาหวาน:24.คลินิกเบาหวา\n\n\n',
                                            // '${item.cdDisplay}',
                                            category.isNotEmpty ? category : item.cdDisplay,
                                            maxLines: 3,
                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                  font: GoogleFonts.sarabun(
                                                    fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                  lineHeight: 1.5,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                              ].divide(SizedBox(height: 6.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    'ผู้ขึ้นทะเบียน',
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          font: GoogleFonts.sarabun(
                                            fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                      ),
                                ),
                                Text(
                                  // 'นพฤทธิ์ ผ่องใสทองศรี',
                                  '${item.providerName}',
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ].divide(SizedBox(height: 24.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      text: 'ปิด',
                      options: FFButtonOptions(
                        height: 52.0,
                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.sarabun(
                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                            ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          enableDrag: false,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: DeleteDataWidget(
                                NCDID: item.id,
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));
                      },
                      text: 'ลบข้อมูล',
                      options: FFButtonOptions(
                        height: 52.0,
                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).accent3,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.sarabun(
                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                              ),
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                            ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
            ),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }
}

class NCDPatient {
  final String id;
  final String registrationCode;
  final String cid;
  final String name;
  final String gender;
  final String bloodGroup;
  final DateTime birthDate;
  final String cdCode;
  final String cdDisplay;
  final String statusDisplay;
  final String conditionText;
  final DateTime registerDatetime;
  final DateTime beginDatetime;
  final String orgName;
  final String providerName;

  NCDPatient({
    required this.id,
    required this.registrationCode,
    required this.cid,
    required this.name,
    required this.gender,
    required this.bloodGroup,
    required this.birthDate,
    required this.cdCode,
    required this.cdDisplay,
    required this.statusDisplay,
    required this.conditionText,
    required this.registerDatetime,
    required this.beginDatetime,
    required this.orgName,
    required this.providerName,
  });

  factory NCDPatient.fromJson(Map<String, dynamic> json) {
    return NCDPatient(
      id: json['patient_chronic_registry_id'] ?? '',
      registrationCode: json['registration_code'] ?? '',
      cid: json['cid'] ?? '',
      name: json['patient_name_text'] ?? '',
      gender: json['gender'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      birthDate: DateTime.tryParse(json['birth_date'] ?? '') ?? DateTime(1900),
      cdCode: json['cd_code'] ?? '',
      cdDisplay: json['cd_display'] ?? '',
      statusDisplay: json['status_display'] ?? '',
      conditionText: json['condition_text'] ?? '',
      registerDatetime: DateTime.tryParse(json['register_datetime'] ?? '') ?? DateTime(1900),
      beginDatetime: DateTime.tryParse(json['begin_datetime'] ?? '') ?? DateTime(1900),
      orgName: json['organization_name'] ?? '',
      providerName: json['provider_name'] ?? '',
    );
  }
}
