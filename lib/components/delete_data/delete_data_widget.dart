import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'delete_data_model.dart';
export 'delete_data_model.dart';
import 'package:http/http.dart' as http;

class DeleteDataWidget extends StatefulWidget {
  const DeleteDataWidget({super.key, this.NCDID});

  final String? NCDID;
  @override
  State<DeleteDataWidget> createState() => _DeleteDataWidgetState();
}

class _DeleteDataWidgetState extends State<DeleteDataWidget> {
  late DeleteDataModel _model;
  // final baseurl = 'http://192.168.30.73:8000';
  // final baseurl = 'http://127.0.0.1:18001';
  // final client = http.Client();

  final baseUrl = EnvService.apiUrl;
  final username = EnvService.username;
  String apiToken = '';
  String id = '';

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeleteDataModel());

    id = widget.NCDID ?? '';
    print(' id : $id');
    // loadTokenFromStorage();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  // Future<void> loadTokenFromStorage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final storedToken = prefs.getString('apiToken');
  //   if (storedToken != null && storedToken.isNotEmpty) {
  //     apiToken = storedToken;
  //     // await fetchNCDList();
  //     //debugPrint('📦 Token loaded from SharedPreferences');
  //     setState(() {});
  //   } else {
  //     //debugPrint('⚠️ No token found');
  //   }
  // }

  Future<void> deleteNCDData(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('apiToken');

    if (token == null || token.isEmpty) {
      //debugPrint('⚠️ Token not found');
      return;
    }

    final url = Uri.parse('$baseUrl/api/ncd_list/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        //debugPrint('🗑️ ลบข้อมูลสำเร็จ: $id');
        // รีเฟรชหน้าจอหรือ fetch ใหม่
        // await fetchNCDList(); // ถ้าฟังก์ชันนี้อยู่ในคลาสเดียวกัน
      } else {
        //debugPrint('❌ ลบไม่สำเร็จ ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      //debugPrint('🚫 Delete error: $e');
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 300.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
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
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/Delete.png',
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'ยืนยันที่จะลบข้อมูลหรือไม่ ?',
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      text: 'ยกเลิก',
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
                        await deleteNCDData(id);
                        // Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      text: 'ยืนยัน',
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
            ].divide(SizedBox(height: 16.0)),
          ),
        ),
      ),
    );
  }
}
