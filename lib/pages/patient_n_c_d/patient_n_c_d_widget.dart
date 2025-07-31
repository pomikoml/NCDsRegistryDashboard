import 'package:get/get.dart';
import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';
import 'package:n_c_ds_registry_dashboard/flutter_flow/flutter_flow_drop_down.dart';
import 'package:n_c_ds_registry_dashboard/flutter_flow/form_field_controller.dart';

import '/components/regist_n_c_d/regist_n_c_d_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'patient_n_c_d_model.dart';
export 'patient_n_c_d_model.dart';

class PatientNCDWidget extends StatefulWidget {
  const PatientNCDWidget({super.key});

  static String routeName = 'Patient_NCD';
  static String routePath = '/patientNCD';

  @override
  State<PatientNCDWidget> createState() => _PatientNCDWidgetState();
}

class _PatientNCDWidgetState extends State<PatientNCDWidget> with TickerProviderStateMixin {
  late PatientNCDModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  final ScrollController _scrollController = ScrollController();

  final getX = Get.find<NCDsgetX>();
  final _dateFormatter = DateFormat('yyyy-MM-dd');

  final headerTitles = [
    'ลำดับ',
    'เลขบัตรประชาชน',
    'ชื่อ - นามสกุล',
    'เลขทะเบียน',
    'วันที่เริ่มเป็น',

    // 'รหัสโรคเรื้อรัง',
    'ชื่อโรคเรื้อรัง',
    'การวินิจฉัย',
    'สถานะ',
    'ผู้ขึ้นทะเบียน',
    'วันที่ขึ้นทะเบียนกลาง'
  ];

  final columnFlexes = [
    1,
    3,
    4,
    4,
    2,
    // 2,
    4,
    2,
    2,
    3,
    3
  ];

  final Map<String, String> diseaseCodeMap = {
    'โรคเบาหวาน': '001',
    'โรคความดันโลหิตสูง': '002',
    'โรคหัวใจ': '0051', //0051
    'โรคหลอดเลือดสมอง': '0052', //0052
    'โรคไตวายเรื้อรัง': '009',
    'โรคถุงลมโป่งพอง': '008',
    'โรคไขมันในเลือดสูง': '014',
    'โรคอ้วน': '027', // แม็ปชื่อ “โรคอ้วน” ไปเป็น code 027
    'บุหรี่ไฟฟ้า': '026', // แม็ปชื่อ “บุหรี่ไฟฟ้า” ไปเป็น code 026
  };

  DateTimeRange? _pickedDateRange;
  final TextEditingController _dateRangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PatientNCDModel());
    // getX.callAuthAPI();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getX.fetchNCDList();
    });
    _model.diseaseController = TextEditingController();
    _model.filterstatusController = TextEditingController();
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _model.textControllercid ??= TextEditingController();
    _model.textFieldcidFocusNode ??= FocusNode();

    // ช่องเลือกช่วงวันที่
    _model.dateRangeController ??= TextEditingController();
    // ค่าเริ่มต้นให้ null ก็พอ
    _model.pickedDateRange ??= null;

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

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  String maskCID(String? cid) {
    if (cid == null || cid.length != 13) return cid ?? '';
    return 'X XXX${cid[4]} ${cid.substring(5, 9)}X XX X';
  }

  // String formatThaiDate(String? isoDate) {
  //   if (isoDate == null) return '-';
  //   try {
  //     final date = DateTime.parse(isoDate);
  //     final buddhistYear = date.year + 543;
  //     return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/$buddhistYear ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  //   } catch (e) {
  //     return '-';
  //   }
  // }
  String formatThaiDate(String? isoDate) {
    if (isoDate == null) return '-';
    try {
      final date = DateTime.parse(isoDate);
      final buddhistYear = date.year + 543;
      // ถ้าเป็น 1/1/2513 BE (== 1/1/1970 CE) ให้คืน '-'
      if (buddhistYear == 2513 && date.month == 1 && date.day == 1) {
        return '-';
      }
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '$buddhistYear';
    } catch (e) {
      return '-';
    }
  }

  // ฟังก์ชันช่วยแม็ป status → ไอคอน
  IconData _iconForStatus(String status) {
    switch (status) {
      case 'ยังรักษาอยู่':
      case 'ติดตามการรักษา(ยังรักษาอยู่)':
        return Icons.check_circle;
      case 'หาย':
        return Icons.thumb_up;
      case 'ติดตามการรักษา':
        return Icons.autorenew;
      case 'ส่งต่อสถานพยาบาลอื่น':
        return Icons.local_hospital;
      case 'ไม่ทราบ(ไม่มีข้อมูล)':
        return Icons.help_outline;
      default:
        return Icons.info_outline;
    }
  }

// ฟังก์ชันช่วยแม็ป status → สีไอคอน
  Color _colorForStatus(String status) {
    switch (status) {
      case 'ยังรักษาอยู่':
      case 'ติดตามการรักษา(ยังรักษาอยู่)':
        return Colors.green;
      case 'หาย':
        return Colors.blue;
      case 'ติดตามการรักษา':
        return Colors.orange;
      case 'ส่งต่อสถานพยาบาลอื่น':
        return Colors.purple;
      case 'ไม่ทราบ(ไม่มีข้อมูล)':
        return Colors.grey;
      default:
        return Colors.black54;
    }
  }

  @override
  void dispose() {
    _model.dispose();

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Column(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xCDFFFFFF),
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
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(24.0),
                                    topRight: Radius.circular(24.0),
                                  ),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xCDFFFFFF),
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
                                              borderRadius: BorderRadius.circular(100.0),
                                              border: Border.all(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  FFButtonWidget(
                                                    onPressed: () async {
                                                      context.pushNamed(
                                                        DashboardOverviewWidget.routeName,
                                                        extra: <String, dynamic>{
                                                          kTransitionInfoKey: TransitionInfo(
                                                            hasTransition: true,
                                                            transitionType: PageTransitionType.fade,
                                                            duration: Duration(milliseconds: 300),
                                                          ),
                                                        },
                                                      );
                                                    },
                                                    text: 'แดชบอร์ด',
                                                    icon: Icon(
                                                      Icons.dashboard_rounded,
                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                      size: 16.0,
                                                    ),
                                                    options: FFButtonOptions(
                                                      height: 36.0,
                                                      padding: EdgeInsets.all(8.0),
                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            font: GoogleFonts.sarabun(
                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                          ),
                                                      elevation: 0.0,
                                                      borderRadius: BorderRadius.circular(24.0),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.keyboard_arrow_right_rounded,
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    size: 24.0,
                                                  ),
                                                  Container(
                                                    height: 36.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).primary,
                                                      borderRadius: BorderRadius.circular(100.0),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Icon(
                                                            Icons.list_alt_rounded,
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                            size: 20.0,
                                                          ),
                                                          Text(
                                                            'ทะเบียนผู้ป่วย NCD',
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  font: GoogleFonts.sarabun(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                  letterSpacing: 0.0,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                ),
                                                          ),
                                                        ].divide(SizedBox(width: 8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 300.0, 0.0),
                                              child: GradientText(
                                                'ทะเบียนผู้ที่ถูกขึ้นทะเบียนโรคเรื้อรัง',
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: FlutterFlowTheme.of(context).titleLarge.override(
                                                      font: GoogleFonts.sarabun(
                                                        fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                        fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                      ),
                                                      color: FlutterFlowTheme.of(context).primary,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                      fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                      lineHeight: 2.0,
                                                    ),
                                                colors: [
                                                  FlutterFlowTheme.of(context).primary,
                                                  FlutterFlowTheme.of(context).secondary
                                                ],
                                                gradientDirection: GradientDirection.ltr,
                                                gradientType: GradientType.linear,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color(0xCDFFFFFF),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight: Radius.circular(0.0),
                                              topLeft: Radius.circular(24.0),
                                              topRight: Radius.circular(24.0),
                                            ),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsetsDirectional.only(bottom: 4),
                                                        child: Scrollbar(
                                                          thumbVisibility: true,
                                                          controller: _scrollController,
                                                          child: SingleChildScrollView(
                                                            controller: _scrollController,
                                                            scrollDirection: Axis.horizontal,
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                // ช่องค้นหาหลัก (ชื่อ, cid, cdCode)
                                                                // Container(
                                                                //   width: 200.0,
                                                                //   child: TextFormField(
                                                                //     controller: _model.textController,
                                                                //     focusNode: _model.textFieldFocusNode,
                                                                //     onChanged: (val) {
                                                                //       EasyDebounce.debounce(
                                                                //         '_search',
                                                                //         Duration(milliseconds: 500),
                                                                //         () => getX.fetchNCDList(name: val, cid: val),
                                                                //       );
                                                                //     },
                                                                //     autofocus: false,
                                                                //     obscureText: false,
                                                                //     decoration: InputDecoration(
                                                                //       isDense: true,
                                                                //       labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                //             font: GoogleFonts.sarabun(
                                                                //               fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                //               fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                //             ),
                                                                //             letterSpacing: 0.0,
                                                                //           ),
                                                                //       hintText: 'ค้นหาชื่อ',
                                                                //       hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                //             font: GoogleFonts.sarabun(
                                                                //               fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                //               fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                //             ),
                                                                //             letterSpacing: 0.0,
                                                                //           ),
                                                                //       enabledBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: Color(0x00000000),
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       focusedBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: Color(0xFF00855B),
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       errorBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: FlutterFlowTheme.of(context).error,
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       focusedErrorBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: FlutterFlowTheme.of(context).error,
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       filled: true,
                                                                //       fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                                                //       prefixIcon: Icon(
                                                                //         Icons.search_rounded,
                                                                //         color: Color(0xFF00855B),
                                                                //         size: 20.0,
                                                                //       ),
                                                                //       suffixIcon: _model.textController!.text.isNotEmpty
                                                                //           ? InkWell(
                                                                //               onTap: () {
                                                                //                 _model.textController?.clear();
                                                                //                 getX.fetchNCDList(page: 1, name: '');
                                                                //               },
                                                                //               child: Icon(Icons.clear),
                                                                //             )
                                                                //           : null,
                                                                //     ),
                                                                //     style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                //           font: GoogleFonts.sarabun(
                                                                //             fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                //             fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                //           ),
                                                                //           letterSpacing: 0.0,
                                                                //         ),
                                                                //     cursorColor: Color(0xFFED6428),
                                                                //     validator: _model.textControllerValidator.asValidator(context),
                                                                //   ),
                                                                // ),
                                                                Container(
                                                                  width: 200.0,
                                                                  child: TextFormField(
                                                                    controller: _model.textController,
                                                                    focusNode: _model.textFieldFocusNode,
                                                                    onChanged: (val) {
                                                                      EasyDebounce.debounce(
                                                                        '_search_name',
                                                                        Duration(milliseconds: 500),
                                                                        () => getX.fetchNCDList(
                                                                          name: val,
                                                                          cdCode: diseaseCodeMap[_model.diseaseController?.text] ?? '',
                                                                          status: _model.filterstatusController?.text ?? '',
                                                                          cid: _model.textControllercid?.text ?? '',
                                                                          startDate: _model.pickedDateRange?.start,
                                                                          endDate: _model.pickedDateRange?.end,
                                                                        ),
                                                                      );
                                                                    },
                                                                    // ... existing decoration
                                                                    decoration: InputDecoration(
                                                                      isDense: true,
                                                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                            font: GoogleFonts.sarabun(
                                                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                            ),
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                      hintText: 'ค้นหาชื่อ',
                                                                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                            font: GoogleFonts.sarabun(
                                                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                            ),
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0x00000000),
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0xFF00855B),
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      errorBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: FlutterFlowTheme.of(context).error,
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: FlutterFlowTheme.of(context).error,
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                                                      prefixIcon: Icon(
                                                                        Icons.search_rounded,
                                                                        color: Color(0xFF00855B),
                                                                        size: 20.0,
                                                                      ),

                                                                      // ... existing decoration properties
                                                                      suffixIcon: _model.textController!.text.isNotEmpty
                                                                          ? InkWell(
                                                                              onTap: () {
                                                                                _model.textController?.clear();
                                                                                getX.fetchNCDList(
                                                                                  name: '',
                                                                                  cdCode: diseaseCodeMap[_model.diseaseController?.text] ?? '',
                                                                                  status: _model.filterstatusController?.text ?? '',
                                                                                  cid: _model.textControllercid?.text ?? '',
                                                                                  startDate: _model.pickedDateRange?.start,
                                                                                  endDate: _model.pickedDateRange?.end,
                                                                                  page: 1,
                                                                                );
                                                                              },
                                                                              child: Icon(Icons.clear),
                                                                            )
                                                                          : null,
                                                                    ),
                                                                    // ... existing style and validator
                                                                  ),
                                                                ),
                                                                SizedBox(width: 12),
                                                                //cid
                                                                // Container(
                                                                //   width: 180.0,
                                                                //   child: TextFormField(
                                                                //     controller: _model.textControllercid,
                                                                //     focusNode: _model.textFieldcidFocusNode,
                                                                //     onChanged: (val) {
                                                                //       EasyDebounce.debounce(
                                                                //         '_search',
                                                                //         Duration(milliseconds: 500),
                                                                //         () => getX.fetchNCDList(cid: val),
                                                                //       );
                                                                //     },
                                                                //     autofocus: false,
                                                                //     obscureText: false,
                                                                //     decoration: InputDecoration(
                                                                //       isDense: true,
                                                                //       labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                //             font: GoogleFonts.sarabun(
                                                                //               fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                //               fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                //             ),
                                                                //             letterSpacing: 0.0,
                                                                //           ),
                                                                //       hintText: 'ค้นหา CID',
                                                                //       hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                //             font: GoogleFonts.sarabun(
                                                                //               fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                //               fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                //             ),
                                                                //             letterSpacing: 0.0,
                                                                //           ),
                                                                //       enabledBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: Color(0x00000000),
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       focusedBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: Color(0xFF00855B),
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       errorBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: FlutterFlowTheme.of(context).error,
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       focusedErrorBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: FlutterFlowTheme.of(context).error,
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       filled: true,
                                                                //       fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                                                //       prefixIcon: Icon(
                                                                //         Icons.search_rounded,
                                                                //         color: Color(0xFF00855B),
                                                                //         size: 20.0,
                                                                //       ),
                                                                //       suffixIcon: _model.textControllercid!.text.isNotEmpty
                                                                //           ? InkWell(
                                                                //               onTap: () {
                                                                //                 _model.textControllercid?.clear();
                                                                //                 getX.fetchNCDList(page: 1, cid: '');
                                                                //               },
                                                                //               child: Icon(Icons.clear),
                                                                //             )
                                                                //           : null,
                                                                //     ),
                                                                //     style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                //           font: GoogleFonts.sarabun(
                                                                //             fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                //             fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                //           ),
                                                                //           letterSpacing: 0.0,
                                                                //         ),
                                                                //     cursorColor: Color(0xFFED6428),
                                                                //     validator: _model.textControllercidValidator.asValidator(context),
                                                                //   ),
                                                                // ),
                                                                Container(
                                                                  width: 180.0,
                                                                  child: TextFormField(
                                                                    controller: _model.textControllercid,
                                                                    focusNode: _model.textFieldcidFocusNode,
                                                                    onChanged: (val) {
                                                                      EasyDebounce.debounce(
                                                                        '_search_cid',
                                                                        Duration(milliseconds: 500),
                                                                        () => getX.fetchNCDList(
                                                                          cid: val,
                                                                          name: _model.textController?.text ?? '',
                                                                          cdCode: diseaseCodeMap[_model.diseaseController?.text] ?? '',
                                                                          status: _model.filterstatusController?.text ?? '',
                                                                          startDate: _model.pickedDateRange?.start,
                                                                          endDate: _model.pickedDateRange?.end,
                                                                        ),
                                                                      );
                                                                    },
                                                                    // ... existing decoration
                                                                    decoration: InputDecoration(
                                                                      isDense: true,
                                                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                            font: GoogleFonts.sarabun(
                                                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                            ),
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                      hintText: 'ค้นหา CID',
                                                                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                            font: GoogleFonts.sarabun(
                                                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                            ),
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0x00000000),
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0xFF00855B),
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      errorBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: FlutterFlowTheme.of(context).error,
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: FlutterFlowTheme.of(context).error,
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                                                      prefixIcon: Icon(
                                                                        Icons.search_rounded,
                                                                        color: Color(0xFF00855B),
                                                                        size: 20.0,
                                                                      ),
                                                                      //       suffixIcon: _model.textControllercid!.text.isNotEmpty
                                                                      //           ? InkWell(
                                                                      //               onTap: () {
                                                                      //                 _model.textControllercid?.clear();
                                                                      //                 getX.fetchNCDList(page: 1, cid: '');
                                                                      //               },
                                                                      //               child: Icon(Icons.clear),
                                                                      //             )
                                                                      //           : null,
                                                                      //     ),
                                                                      //     style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      //           font: GoogleFonts.sarabun(
                                                                      //             fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                      //             fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                      //           ),
                                                                      //           letterSpacing: 0.0,
                                                                      //         ),
                                                                      //     cursorColor: Color(0xFFED6428),
                                                                      // ... existing decoration properties
                                                                      suffixIcon: _model.textControllercid!.text.isNotEmpty
                                                                          ? InkWell(
                                                                              onTap: () {
                                                                                _model.textControllercid?.clear();
                                                                                getX.fetchNCDList(
                                                                                  cid: '',
                                                                                  name: _model.textController?.text ?? '',
                                                                                  cdCode: diseaseCodeMap[_model.diseaseController?.text] ?? '',
                                                                                  status: _model.filterstatusController?.text ?? '',
                                                                                  startDate: _model.pickedDateRange?.start,
                                                                                  endDate: _model.pickedDateRange?.end,
                                                                                  page: 1,
                                                                                );
                                                                              },
                                                                              child: Icon(Icons.clear),
                                                                            )
                                                                          : null,
                                                                    ),
                                                                    // ... existing style and validator
                                                                  ),
                                                                ),

                                                                SizedBox(width: 12),
                                                                // ช่องค้นหาชื่อโรค (lookup)
                                                                // Container(
                                                                //   width: 150,
                                                                //   child: DropdownButtonFormField<String>(
                                                                //     value: _model.diseaseController?.text.isNotEmpty == true ? _model.diseaseController!.text : null,
                                                                //     isExpanded: true,
                                                                //     decoration: InputDecoration(
                                                                //       isDense: true,
                                                                //       labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                                                //       hintText: 'เลือกโรค...',
                                                                //       hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                                                //       enabledBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: Color(0x00000000),
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       focusedBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: Color(0xFF00855B),
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       filled: true,
                                                                //       fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                                                //       prefixIcon: Icon(
                                                                //         Icons.filter_list,
                                                                //         color: Color(0xFF00855B),
                                                                //         size: 20.0,
                                                                //       ),
                                                                //       suffixIcon: (_model.diseaseController?.text.isNotEmpty ?? false)
                                                                //           ? InkWell(
                                                                //               onTap: () {
                                                                //                 _model.diseaseController?.clear();
                                                                //                 setState(() {});
                                                                //                 getX.fetchNCDList(cdCode: '');
                                                                //               },
                                                                //               child: Icon(Icons.clear),
                                                                //             )
                                                                //           : null,
                                                                //     ),
                                                                //     items: [
                                                                //       'ทั้งหมด',
                                                                //       'โรคเบาหวาน',
                                                                //       'โรคความดันโลหิตสูง',
                                                                //       'โรคหัวใจ',
                                                                //       'โรคไตวายเรื้อรัง',
                                                                //       'โรคหลอดเลือดสมอง',
                                                                //       'โรคถุงลมโป่งพอง',
                                                                //       'โรคไขมันในเลือดสูง',
                                                                //       'โรคอ้วน',
                                                                //       'บุหรี่ไฟฟ้า',
                                                                //       // เพิ่มชื่อโรคอื่นๆ ตามต้องการ
                                                                //     ].map((disease) {
                                                                //       return DropdownMenuItem<String>(
                                                                //         value: disease,
                                                                //         child: Text(disease),
                                                                //       );
                                                                //     }).toList(),
                                                                //     onChanged: (val) {
                                                                //       if (val == null) return;
                                                                //       if (val == 'ทั้งหมด') {
                                                                //         // เคลียร์การเลือกเหมือนล้าง filter
                                                                //         _model.diseaseController?.clear();
                                                                //         setState(() {});
                                                                //         getX.fetchNCDList(cdCode: '');
                                                                //       } else {
                                                                //         // เก็บชื่อไว้แสดง
                                                                //         _model.diseaseController?.text = val;
                                                                //         // หา code จาก map แล้วเรียก API
                                                                //         final code = diseaseCodeMap[val] ?? '';
                                                                //         getX.fetchNCDList(cdCode: code);
                                                                //       }
                                                                //     },
                                                                //     // dropdownHeight: 300,
                                                                //     // maxHeight: 300,
                                                                //   ),
                                                                // ),
                                                                Container(
                                                                  width: 150,
                                                                  child: DropdownButtonFormField<String>(
                                                                    value: _model.diseaseController?.text.isNotEmpty == true ? _model.diseaseController!.text : null,
                                                                    isExpanded: true,
                                                                    decoration: InputDecoration(
                                                                      isDense: true,
                                                                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                                                      hintText: 'เลือกโรค...',
                                                                      hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0x00000000),
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0xFF00855B),
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                                                      prefixIcon: Icon(
                                                                        Icons.filter_list,
                                                                        color: Color(0xFF00855B),
                                                                        size: 20.0,
                                                                      ),
                                                                      suffixIcon: (_model.diseaseController?.text.isNotEmpty ?? false)
                                                                          ? InkWell(
                                                                              onTap: () {
                                                                                _model.diseaseController?.clear();
                                                                                setState(() {});
                                                                                // เรียก API โดยส่ง filter อื่นๆ ที่ยังคงอยู่
                                                                                getX.fetchNCDList(
                                                                                  cdCode: '',
                                                                                  status: _model.filterstatusController?.text ?? '',
                                                                                  cid: _model.textControllercid?.text ?? '',
                                                                                  name: _model.textController?.text ?? '',
                                                                                  startDate: _model.pickedDateRange?.start,
                                                                                  endDate: _model.pickedDateRange?.end,
                                                                                );
                                                                              },
                                                                              child: Icon(Icons.clear),
                                                                            )
                                                                          : null,
                                                                    ),
                                                                    items: [
                                                                      'ทั้งหมด',
                                                                      'โรคเบาหวาน',
                                                                      'โรคความดันโลหิตสูง',
                                                                      'โรคหัวใจ',
                                                                      'โรคไตวายเรื้อรัง',
                                                                      'โรคหลอดเลือดสมอง',
                                                                      'โรคถุงลมโป่งพอง',
                                                                      'โรคไขมันในเลือดสูง',
                                                                      'โรคอ้วน',
                                                                      'บุหรี่ไฟฟ้า',
                                                                    ].map((disease) {
                                                                      return DropdownMenuItem<String>(
                                                                        value: disease,
                                                                        child: Text(disease),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged: (val) {
                                                                      if (val == null) return;

                                                                      String cdCode = '';
                                                                      if (val == 'ทั้งหมด') {
                                                                        _model.diseaseController?.clear();
                                                                      } else {
                                                                        _model.diseaseController?.text = val;
                                                                        cdCode = diseaseCodeMap[val] ?? '';
                                                                      }

                                                                      setState(() {});

                                                                      // เรียก API โดยรวม filter ทั้งหมดที่มีอยู่
                                                                      getX.fetchNCDList(
                                                                        cdCode: cdCode,
                                                                        status: _model.filterstatusController?.text ?? '',
                                                                        cid: _model.textControllercid?.text ?? '',
                                                                        name: _model.textController?.text ?? '',
                                                                        startDate: _model.pickedDateRange?.start,
                                                                        endDate: _model.pickedDateRange?.end,
                                                                        page: 1,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),

                                                                SizedBox(width: 12),
                                                                // Dropdown เขตสุขภาพ
                                                                // Container(
                                                                //   width: 170,
                                                                //   child: DropdownButtonFormField<String>(
                                                                //     value: _model.filterstatusController?.text.isNotEmpty == true ? _model.filterstatusController!.text : null,
                                                                //     isExpanded: true,
                                                                //     decoration: InputDecoration(
                                                                //       isDense: true,
                                                                //       labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                                                //       hintText: 'เลือกสถานะ...',
                                                                //       hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                                                //       enabledBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: Color(0x00000000),
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       focusedBorder: OutlineInputBorder(
                                                                //         borderSide: BorderSide(
                                                                //           color: Color(0xFF00855B),
                                                                //           width: 1.0,
                                                                //         ),
                                                                //         borderRadius: BorderRadius.circular(100.0),
                                                                //       ),
                                                                //       filled: true,
                                                                //       fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                                                //       // prefixIcon: Icon(
                                                                //       //   Icons.medical_services,
                                                                //       //   color: Color(0xFF00855B),
                                                                //       //   size: 20.0,
                                                                //       // ),
                                                                //       prefixIcon: Icon(Icons.filter_list, color: Color(0xFF00855B), size: 20),
                                                                //       suffixIcon: (_model.filterstatusController?.text.isNotEmpty ?? false)
                                                                //           ? InkWell(
                                                                //               onTap: () {
                                                                //                 _model.filterstatusController?.clear();
                                                                //                 setState(() {});
                                                                //                 getX.fetchNCDList(status: '');
                                                                //               },
                                                                //               child: Icon(Icons.clear),
                                                                //             )
                                                                //           : null,
                                                                //     ),
                                                                //     items: [
                                                                //       'ทั้งหมด',
                                                                //       'ยังรักษาอยู่',
                                                                //       'หาย',
                                                                //       'ติดตามการรักษา',
                                                                //       'ส่งต่อสถานพยาบาลอื่น',
                                                                //       'ไม่ทราบ(ไม่มีข้อมูล)',
                                                                //       'ติดตามการรักษา(ยังรักษาอยู่)',
                                                                //       // เพิ่มชื่อสถานะอื่นๆ ตามต้องการ
                                                                //     ].map((fstatus) {
                                                                //       return DropdownMenuItem<String>(
                                                                //         value: fstatus,
                                                                //         child: Text(fstatus),
                                                                //       );
                                                                //     }).toList(),
                                                                //     onChanged: (val) {
                                                                //       if (val == null) return;
                                                                //       if (val == 'ทั้งหมด') {
                                                                //         // เคลียร์การเลือกเหมือนล้าง filter
                                                                //         _model.filterstatusController?.clear();
                                                                //         setState(() {});
                                                                //         getX.fetchNCDList(status: '');
                                                                //       } else {
                                                                //         // เก็บชื่อไว้แสดง
                                                                //         _model.filterstatusController?.text = val;
                                                                //         // หา code จาก map แล้วเรียก API
                                                                //         // final code = diseaseCodeMap[val] ?? '';
                                                                //         getX.fetchNCDList(status: val);
                                                                //       }
                                                                //     },
                                                                //     // dropdownHeight: 300,
                                                                //     // maxHeight: 300,
                                                                //   ),
                                                                // ),
                                                                Container(
                                                                  width: 170,
                                                                  child: DropdownButtonFormField<String>(
                                                                    value: _model.filterstatusController?.text.isNotEmpty == true ? _model.filterstatusController!.text : null,
                                                                    isExpanded: true,
                                                                    decoration: InputDecoration(
                                                                      isDense: true,
                                                                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                                                      hintText: 'เลือกสถานะ...',
                                                                      hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0x00000000),
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Color(0xFF00855B),
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100.0),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                                                      prefixIcon: Icon(Icons.filter_list, color: Color(0xFF00855B), size: 20),
                                                                      suffixIcon: (_model.filterstatusController?.text.isNotEmpty ?? false)
                                                                          ? InkWell(
                                                                              onTap: () {
                                                                                _model.filterstatusController?.clear();
                                                                                setState(() {});
                                                                                // เรียก API โดยส่ง filter อื่นๆ ที่ยังคงอยู่
                                                                                getX.fetchNCDList(
                                                                                  status: '',
                                                                                  cdCode: diseaseCodeMap[_model.diseaseController?.text] ?? '',
                                                                                  cid: _model.textControllercid?.text ?? '',
                                                                                  name: _model.textController?.text ?? '',
                                                                                  startDate: _model.pickedDateRange?.start,
                                                                                  endDate: _model.pickedDateRange?.end,
                                                                                );
                                                                              },
                                                                              child: Icon(Icons.clear),
                                                                            )
                                                                          : null,
                                                                    ),
                                                                    items: [
                                                                      'ทั้งหมด',
                                                                      'ยังรักษาอยู่',
                                                                      'หาย',
                                                                      'ติดตามการรักษา',
                                                                      'ส่งต่อสถานพยาบาลอื่น',
                                                                      'ไม่ทราบ(ไม่มีข้อมูล)',
                                                                      'ติดตามการรักษา(ยังรักษาอยู่)',
                                                                    ].map((fstatus) {
                                                                      return DropdownMenuItem<String>(
                                                                        value: fstatus,
                                                                        child: Text(fstatus),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged: (val) {
                                                                      if (val == null) return;

                                                                      String status = '';
                                                                      if (val == 'ทั้งหมด') {
                                                                        _model.filterstatusController?.clear();
                                                                      } else {
                                                                        _model.filterstatusController?.text = val;
                                                                        // print('เลือกสถานะ filterstatusController : ${_model.filterstatusController?.text}');

                                                                        status = val;
                                                                        // print('เลือกสถานะ status : ${status}');
                                                                      }

                                                                      setState(() {});

                                                                      // เรียก API โดยรวม filter ทั้งหมดที่มีอยู่
                                                                      getX.fetchNCDList(
                                                                        status: _model.filterstatusController?.text ?? '',
                                                                        cdCode: diseaseCodeMap[_model.diseaseController?.text] ?? '',
                                                                        cid: _model.textControllercid?.text ?? '',
                                                                        name: _model.textController?.text ?? '',
                                                                        startDate: _model.pickedDateRange?.start,
                                                                        endDate: _model.pickedDateRange?.end,
                                                                        page: 1,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),

                                                                SizedBox(width: 12),

                                                                // ======= Date Range Picker ========
                                                                // Container(
                                                                //   width: 240,
                                                                //   child: TextFormField(
                                                                //     controller: _model.dateRangeController,
                                                                //     readOnly: true,
                                                                //     decoration: InputDecoration(
                                                                //       isDense: true,
                                                                //       hintText: 'เลือกช่วงวันที่',
                                                                //       prefixIcon: Icon(Icons.date_range),
                                                                //       border: OutlineInputBorder(
                                                                //         borderRadius: BorderRadius.circular(100),
                                                                //       ),
                                                                //       filled: true,
                                                                //       fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                                                //       suffixIcon: _model.dateRangeController!.text.isNotEmpty
                                                                //           ? InkWell(
                                                                //               onTap: () {
                                                                //                 _model.dateRangeController?.clear();
                                                                //                 // เรียก API แบบไม่กรองวันที่
                                                                //                 getX.fetchNCDList(page: 1, startDate: null, endDate: null);
                                                                //               },
                                                                //               child: Icon(Icons.clear),
                                                                //             )
                                                                //           : null,
                                                                //     ),
                                                                //     // onTap: () async {
                                                                //     //   final picked = await showDateRangePicker(
                                                                //     //     context: context,
                                                                //     //     firstDate: DateTime(2020),
                                                                //     //     lastDate: DateTime.now().add(Duration(days: 7)),
                                                                //     //     initialDateRange: _model.pickedDateRange,
                                                                //     //   );
                                                                //     //   if (picked != null) {
                                                                //     //     // เก็บไว้ใน model ของคุณ (เช่นใน State หรือใน _model)
                                                                //     //     setState(() {
                                                                //     //       _model.pickedDateRange = picked;
                                                                //     //       _model.dateRangeController?.text = '${_dateFormatter.format(picked.start)} – ${_dateFormatter.format(picked.end)}';
                                                                //     //     });

                                                                //     //     // เรียก API พร้อมช่วงวันที่
                                                                //     //     getX.fetchNCDList(
                                                                //     //       startDate: picked.start,
                                                                //     //       endDate: picked.end,
                                                                //     //       page: 1,
                                                                //     //     );
                                                                //     //   }
                                                                //     // },
                                                                //     onTap: () async {
                                                                //       final picked = await showDateRangePicker(
                                                                //         context: context,
                                                                //         firstDate: DateTime(2020),
                                                                //         lastDate: DateTime.now().add(Duration(days: 7)),
                                                                //         initialDateRange: _model.pickedDateRange,
                                                                //         builder: (context, child) {
                                                                //           return Center(
                                                                //             child: ConstrainedBox(
                                                                //               constraints: BoxConstraints(maxWidth: 400, maxHeight: 520),
                                                                //               child: ClipRRect(
                                                                //                 borderRadius: BorderRadius.circular(24.0),
                                                                //                 child: Theme(
                                                                //                   data: Theme.of(context).copyWith(
                                                                //                     colorScheme: Theme.of(context).colorScheme.copyWith(
                                                                //                           primary: Colors.lightBlue.shade100, // ฟ้าจาง ๆ
                                                                //                           onPrimary: FlutterFlowTheme.of(context).primary, // สีข้อความบน header
                                                                //                           surface: Colors.white, // พื้นหลังส่วน calendar
                                                                //                           onSurface: Colors.black, // สีข้อความใน calendar
                                                                //                         ),
                                                                //                     textButtonTheme: TextButtonThemeData(
                                                                //                       style: TextButton.styleFrom(
                                                                //                         iconColor: FlutterFlowTheme.of(context).primary, // สีปุ่ม SAVE / CANCEL
                                                                //                       ),
                                                                //                     ),
                                                                //                     dialogTheme: DialogTheme(
                                                                //                       shape: RoundedRectangleBorder(
                                                                //                         borderRadius: BorderRadius.circular(24),
                                                                //                       ),
                                                                //                     ),
                                                                //                   ),
                                                                //                   child: child!,
                                                                //                 ),
                                                                //               ),
                                                                //             ),
                                                                //           );
                                                                //         },
                                                                //       );
                                                                //       if (picked != null) {
                                                                //         setState(() {
                                                                //           _model.pickedDateRange = picked;
                                                                //           _model.dateRangeController?.text = '${_dateFormatter.format(picked.start)} – '
                                                                //               '${_dateFormatter.format(picked.end)}';
                                                                //         });
                                                                //         getX.fetchNCDList(
                                                                //           startDate: picked.start,
                                                                //           endDate: picked.end,
                                                                //           page: 1,
                                                                //         );
                                                                //       }
                                                                //     },
                                                                //   ),
                                                                // ),
                                                                Container(
                                                                  width: 240,
                                                                  child: TextFormField(
                                                                    controller: _model.dateRangeController,
                                                                    readOnly: true,
                                                                    decoration: InputDecoration(
                                                                      isDense: true,
                                                                      hintText: 'เลือกช่วงวันที่',
                                                                      prefixIcon: Icon(Icons.date_range),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(100),
                                                                      ),
                                                                      filled: true,
                                                                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                                                      suffixIcon: _model.dateRangeController!.text.isNotEmpty
                                                                          ? InkWell(
                                                                              onTap: () {
                                                                                _model.dateRangeController?.clear();
                                                                                _model.pickedDateRange = null;
                                                                                // เรียก API โดยส่ง filter อื่นๆ ที่ยังคงอยู่
                                                                                getX.fetchNCDList(
                                                                                  startDate: null,
                                                                                  endDate: null,
                                                                                  name: _model.textController?.text ?? '',
                                                                                  cid: _model.textControllercid?.text ?? '',
                                                                                  cdCode: diseaseCodeMap[_model.diseaseController?.text] ?? '',
                                                                                  status: _model.filterstatusController?.text ?? '',
                                                                                  page: 1,
                                                                                );
                                                                              },
                                                                              child: Icon(Icons.clear),
                                                                            )
                                                                          : null,
                                                                    ),
                                                                    onTap: () async {
                                                                      final picked = await showDateRangePicker(
                                                                        context: context,
                                                                        firstDate: DateTime(2020),
                                                                        lastDate: DateTime.now().add(Duration(days: 7)),
                                                                        initialDateRange: _model.pickedDateRange,
                                                                        builder: (context, child) {
                                                                          return Center(
                                                                            child: ConstrainedBox(
                                                                              constraints: BoxConstraints(maxWidth: 400, maxHeight: 520),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(24.0),
                                                                                child: Theme(
                                                                                  data: Theme.of(context).copyWith(
                                                                                    colorScheme: Theme.of(context).colorScheme.copyWith(
                                                                                          primary: Colors.lightBlue.shade100,
                                                                                          onPrimary: FlutterFlowTheme.of(context).primary,
                                                                                          surface: Colors.white,
                                                                                          onSurface: Colors.black,
                                                                                        ),
                                                                                    textButtonTheme: TextButtonThemeData(
                                                                                      style: TextButton.styleFrom(
                                                                                        iconColor: FlutterFlowTheme.of(context).primary,
                                                                                      ),
                                                                                    ),
                                                                                    dialogTheme: DialogTheme(
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(24),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  child: child!,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                      if (picked != null) {
                                                                        setState(() {
                                                                          _model.pickedDateRange = picked;
                                                                          _model.dateRangeController?.text = '${_dateFormatter.format(picked.start)} – '
                                                                              '${_dateFormatter.format(picked.end)}';
                                                                        });

                                                                        // เรียก API โดยรวม filter ทั้งหมดที่มีอยู่
                                                                        getX.fetchNCDList(
                                                                          startDate: picked.start,
                                                                          endDate: picked.end,
                                                                          name: _model.textController?.text ?? '',
                                                                          cid: _model.textControllercid?.text ?? '',
                                                                          cdCode: diseaseCodeMap[_model.diseaseController?.text] ?? '',
                                                                          status: _model.filterstatusController?.text ?? '',
                                                                          page: 1,
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    // Pagination
                                                    Obx(() {
                                                      if (getX.apiToken.value.isEmpty) {
                                                        return SizedBox(
                                                          height: 36,
                                                          width: 36,
                                                          child: CircularProgressIndicator(strokeWidth: 3),
                                                        );
                                                      } else {
                                                        return Expanded(flex: 0, child: buildPagination(getX, _model, diseaseCodeMap));
                                                      }
                                                    }),
                                                  ].divide(SizedBox(width: 12.0)),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xCDFFFFFF),
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
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(0.0),
                                                        bottomRight: Radius.circular(0.0),
                                                        topLeft: Radius.circular(24.0),
                                                        topRight: Radius.circular(24.0),
                                                      ),
                                                      border: Border.all(
                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: 64.0,
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFEAF7FF),
                                                            borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(0.0),
                                                              bottomRight: Radius.circular(0.0),
                                                              topLeft: Radius.circular(24.0),
                                                              topRight: Radius.circular(24.0),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: List.generate(headerTitles.length, (i) {
                                                              return Expanded(
                                                                flex: columnFlexes[i],
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                                                                  child: Text(
                                                                    headerTitles[i],
                                                                    textAlign: (i == 2 || i == 8 || i == 5) ? TextAlign.start : TextAlign.center,
                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                        ),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                        ),

                                                        //รายชื่อผู้ป่วย
//                                                         Expanded(
//                                                           child: Obx(() {
//                                                             if (getX.isNCDLoading.value) {
//                                                               return Center(child: CircularProgressIndicator());
//                                                             }
//                                                             final items = getX.ncdList;
//                                                             if (items.isEmpty) {
//                                                               return Center(child: Text('ไม่พบข้อมูลผู้ป่วย'));
//                                                             }
//                                                             final textStyle = FlutterFlowTheme.of(context).bodyMedium.override(
//                                                                   font: GoogleFonts.sarabun(
//                                                                     fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
//                                                                     fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
//                                                                   ),
//                                                                   letterSpacing: 0.0,
//                                                                 );
//                                                             // ...existing code...
//                                                             return ListView.builder(
//                                                               padding: EdgeInsets.zero,
//                                                               itemCount: items.length,
//                                                               itemBuilder: (context, index) {
//                                                                 final item = items[index];

//                                                                 // เพิ่มบรรทัดนี้เพื่อให้ลำดับต่อเนื่องข้ามหน้า
//                                                                 final displayIndex = (getX.currentPage.value - 1) * getX.pageSize + index + 1;

//                                                                 // final code = item['condition_text']?.split(':').first ?? '';
//                                                                 final code = (() {
//                                                                   final s = item['condition_text']?.split(':').first ?? '';
//                                                                   return s.length >= 3 ? s.substring(0, 3) : s;
//                                                                 })();
//                                                                 String displayDisease;
//                                                                 if ([
//                                                                   'I20',
//                                                                   'I21',
//                                                                   'I22',
//                                                                   'I23',
//                                                                   'I24',
//                                                                   'I25'
//                                                                 ].contains(code)) {
//                                                                   displayDisease = 'โรคหัวใจ';
//                                                                 } else if ([
//                                                                   'I60',
//                                                                   'I61',
//                                                                   'I62',
//                                                                   'I63',
//                                                                   'I64',
//                                                                   'I65',
//                                                                   'I66',
//                                                                   'I67',
//                                                                   'I68',
//                                                                   'I69'
//                                                                 ].contains(code)) {
//                                                                   displayDisease = 'โรคหลอดเลือดสมอง';
//                                                                 } else {
//                                                                   displayDisease = item['cd_display'] ?? '-';
//                                                                 }
//                                                                 return InkWell(
//                                                                   onTap: () async {
//                                                                     await showModalBottomSheet(
//                                                                       isScrollControlled: true,
//                                                                       backgroundColor: Colors.transparent,
//                                                                       enableDrag: false,
//                                                                       context: context,
//                                                                       builder: (context) {
//                                                                         return GestureDetector(
//                                                                           onTap: () => FocusScope.of(context).unfocus(),
//                                                                           child: Padding(
//                                                                             padding: MediaQuery.viewInsetsOf(context),
//                                                                             child: RegistNCDWidget(
//                                                                               NCDscid: item['cid'],
//                                                                             ),
//                                                                           ),
//                                                                         );
//                                                                       },
//                                                                     ).then((_) => safeSetState(() {
//                                                                           getX.fetchNCDList();
//                                                                           setState(() {});
//                                                                         }));
//                                                                   },
//                                                                   child: Padding(
//                                                                     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                                                                     child: Row(
//                                                                       children: [
//                                                                         // เปลี่ยนจาก '${index + 1}' เป็น displayIndex
//                                                                         '$displayIndex',
//                                                                         maskCID(item['cid']),
//                                                                         item['patient_name_text'],
//                                                                         item['registration_code'],
//                                                                         formatThaiDate(item['begin_datetime']),
//                                                                         // item['cd_code'],

//                                                                         displayDisease,
//                                                                         // item['cd_display'],
//                                                                         item['condition_text']?.split(':').first,
//                                                                         // item['status_display'],
//                                                                         // <-- ตรงนี้ปรับเงื่อนไข
//                                                                         item['status_display'] == 'ติดตามการรักษา(ยังรักษาอยู่)'
//                                                                             ? 'ยังรักษาอยู่'
//                                                                             : item['status_display'] == 'ไม่ทราบ(ไม่มีข้อมูล)'
//                                                                                 ? 'ไม่มีข้อมูล'
//                                                                                 : item['status_display'],
//                                                                         item['provider_name'],
//                                                                         formatThaiDate(item['register_datetime']),
//                                                                       ].asMap().entries.map((entry) {
//                                                                         final i = entry.key;
//                                                                         final value = entry.value ?? '-';
//                                                                         return Expanded(
//                                                                           flex: columnFlexes[i],
//                                                                           child: Padding(
//                                                                             padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
//                                                                             child: Text(
//                                                                               value,
//                                                                               textAlign: (i == 2 || i == 5 || i == 8) ? TextAlign.left : TextAlign.center,
//                                                                               style: FlutterFlowTheme.of(context).bodyMedium,
//                                                                             ),
//                                                                           ),
//                                                                         );
//                                                                       }).toList(),
//                                                                     ),
//                                                                   ),
//                                                                 );
//                                                               },
//                                                             );
// // ...existing code...
//                                                           }),
//                                                         ),

                                                        // รายชื่อผู้ป่วย
                                                        Expanded(
                                                          child: Obx(() {
                                                            if (getX.isNCDLoading.value) {
                                                              return Center(child: CircularProgressIndicator());
                                                            }
                                                            final allItems = getX.ncdList;
                                                            if (allItems.isEmpty) {
                                                              return Center(child: Text('ไม่พบข้อมูลผู้ป่วย'));
                                                            }

                                                            // 1. อ่านค่าฟิลเตอร์โรคจาก dropdown
                                                            // final diseaseFilter = _model.diseaseController?.text ?? '';

                                                            // 2. กรองรายการตามโรคหัวใจ / หลอดเลือดสมอง
                                                            // List<Map<String, dynamic>> items = allItems;
                                                            // if (diseaseFilter == 'โรคหัวใจ') {
                                                            //   items = allItems.where((item) {
                                                            //     final code = item['condition_text']?.split(':').first.substring(0, 3);
                                                            //     return [
                                                            //       'I20',
                                                            //       'I21',
                                                            //       'I22',
                                                            //       'I23',
                                                            //       'I24',
                                                            //       'I25'
                                                            //     ].contains(code);
                                                            //   }).toList();
                                                            // } else if (diseaseFilter == 'โรคหลอดเลือดสมอง') {
                                                            //   items = allItems.where((item) {
                                                            //     final code = item['condition_text']?.split(':').first.substring(0, 3);
                                                            //     return [
                                                            //       'I60',
                                                            //       'I61',
                                                            //       'I62',
                                                            //       'I63',
                                                            //       'I64',
                                                            //       'I65',
                                                            //       'I66',
                                                            //       'I67',
                                                            //       'I68',
                                                            //       'I69'
                                                            //     ].contains(code);
                                                            //   }).toList();
                                                            // }
                                                            // ถ้าเลือก 'ทั้งหมด' ก็ไม่กรองอะไรต่อ

                                                            // if (items.isEmpty) {
                                                            //   return Center(child: Text('ไม่พบข้อมูลผู้ป่วยตามเงื่อนไข'));
                                                            // }

                                                            // 3. สร้าง ListView จากรายการที่กรองแล้ว
                                                            return ListView.builder(
                                                              padding: EdgeInsets.zero,
                                                              itemCount: allItems.length,
                                                              itemBuilder: (context, index) {
                                                                final item = allItems[index];
                                                                final displayIndex = (getX.currentPage.value - 1) * getX.pageSize + index + 1;
                                                                // ขั้นตอนเดิม: ดึง code & ชื่อโรค
                                                                final rawCode = item['condition_text']?.split(':').first ?? '';
                                                                final code = rawCode.length >= 3 ? rawCode.substring(0, 3) : rawCode;
                                                                String displayDisease;
                                                                // if ([
                                                                //   'I20',
                                                                //   'I21',
                                                                //   'I22',
                                                                //   'I23',
                                                                //   'I24',
                                                                //   'I25'
                                                                // ].contains(code)) {
                                                                //   displayDisease = 'โรคหัวใจ';
                                                                // } else if ([
                                                                //   'I60',
                                                                //   'I61',
                                                                //   'I62',
                                                                //   'I63',
                                                                //   'I64',
                                                                //   'I65',
                                                                //   'I66',
                                                                //   'I67',
                                                                //   'I68',
                                                                //   'I69'
                                                                // ].contains(code)) {
                                                                //   displayDisease = 'โรคหลอดเลือดสมอง';
                                                                // } else {
                                                                displayDisease = item['cd_display'] ?? '-';
                                                                // }

                                                                return InkWell(
                                                                  onTap: () async {
                                                                    // เปิด bottom sheet
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled: true,
                                                                      backgroundColor: Colors.transparent,
                                                                      enableDrag: false,
                                                                      context: context,
                                                                      builder: (context) {
                                                                        return GestureDetector(
                                                                          onTap: () => FocusScope.of(context).unfocus(),
                                                                          child: Padding(
                                                                            padding: MediaQuery.viewInsetsOf(context),
                                                                            child: RegistNCDWidget(
                                                                              NCDscid: item['cid'],
                                                                              NCDscdcode: item['cd_code'], // ส่งรหัสโรคไปด้วย
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );

                                                                    // พอปิดแล้ว เรียก fetchNCDList อีกครั้ง แต่ส่ง filter ปัจจุบันทั้งหมดกลับไป
                                                                    await getX.fetchNCDList(
                                                                      name: _model.textController?.text ?? '',
                                                                      cid: _model.textControllercid?.text ?? '',
                                                                      cdCode: diseaseCodeMap[_model.diseaseController?.text] ?? '',
                                                                      status: _model.filterstatusController?.text ?? '',
                                                                      startDate: _model.pickedDateRange?.start,
                                                                      endDate: _model.pickedDateRange?.end,
                                                                      page: getX.currentPage.value, // ถ้าต้องการค้างหน้าเดิม
                                                                    );

                                                                    // อัปเดต UI
                                                                    setState(() {});
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                    child: Row(
                                                                      children: [
                                                                        '$displayIndex',
                                                                        maskCID(item['cid']),
                                                                        item['patient_name_text'],
                                                                        item['registration_code'],
                                                                        formatThaiDate(item['begin_datetime']),
                                                                        displayDisease,
                                                                        code,
                                                                        item['status_display'] == 'ติดตามการรักษา(ยังรักษาอยู่)'
                                                                            ? 'ยังรักษาอยู่'
                                                                            : item['status_display'] == 'ไม่ทราบ(ไม่มีข้อมูล)'
                                                                                ? 'ไม่มีข้อมูล'
                                                                                : item['status_display'],
                                                                        item['provider_name'],
                                                                        formatThaiDate(item['register_datetime']),
                                                                      ].asMap().entries.map((entry) {
                                                                        final i = entry.key;
                                                                        final value = entry.value ?? '-';
                                                                        return Expanded(
                                                                          flex: columnFlexes[i],
                                                                          child: Padding(
                                                                            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                                                                            child: Text(
                                                                              value,
                                                                              textAlign: (i == 2 || i == 5 || i == 8) ? TextAlign.left : TextAlign.center,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 8.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 12.0)),
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
                      ),
                    ].divide(SizedBox(height: 12.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ใน patient_row_widget.dart หรือท้าย patient_n_c_d_widget.dart ก็ได้
class PatientRowWidget extends StatelessWidget {
  final int index;
  final String cid;
  final String patientName;
  final String registrationCode;
  final String registerDate;
  final String cdCode;
  final String cdDisplay;
  final String status;
  final String condition;
  final String provider;

  const PatientRowWidget({
    super.key,
    required this.index,
    required this.cid,
    required this.patientName,
    required this.registrationCode,
    required this.registerDate,
    required this.cdCode,
    required this.cdDisplay,
    required this.status,
    required this.condition,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Center(child: Text('$index'))),
        Expanded(flex: 2, child: Center(child: Text(cid))),
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: Text(patientName))),
        Expanded(flex: 3, child: Center(child: Text(registrationCode))),
        Expanded(flex: 3, child: Center(child: Text(registerDate))),
        Expanded(flex: 2, child: Center(child: Text(cdCode))),
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: Text(cdDisplay))),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: Text(status))),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: Text(condition))),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: Text(provider))),
      ].map((w) => Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: w)).toList(),
    );
  }
}

Widget buildPagination(NCDsgetX getX, PatientNCDModel model, Map<String, String> diseaseCodeMap) {
  return Obx(() {
    final loading = getX.isNCDLoading.value;
    final totalPages = getX.totalPages.value;
    final currentPage = getX.currentPage.value;

    if (loading) {
      return SizedBox();
    }

    if (totalPages == 0) {
      return Text('ไม่พบข้อมูล');
    }

    int maxButtons = 5;
    int startPage = (currentPage - 2).clamp(1, (totalPages - maxButtons + 1).clamp(1, totalPages));
    int endPage = (startPage + maxButtons - 1).clamp(1, totalPages);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ปุ่มไปหน้าแรก
        IconButton(
          icon: Icon(Icons.first_page),
          onPressed: currentPage > 1
              ? () => getX.fetchNCDList(
                    page: 1,
                    name: model.textController?.text ?? '',
                    cid: model.textControllercid?.text ?? '',
                    cdCode: diseaseCodeMap[model.diseaseController?.text] ?? '',
                    status: model.filterstatusController?.text ?? '',
                    startDate: model.pickedDateRange?.start,
                    endDate: model.pickedDateRange?.end,
                  )
              : null,
        ),
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: currentPage > 1
              ? () => getX.fetchNCDList(
                    page: currentPage - 1,
                    name: model.textController?.text ?? '',
                    cid: model.textControllercid?.text ?? '',
                    cdCode: diseaseCodeMap[model.diseaseController?.text] ?? '',
                    status: model.filterstatusController?.text ?? '',
                    startDate: model.pickedDateRange?.start,
                    endDate: model.pickedDateRange?.end,
                  )
              : null,
        ),
        for (int i = startPage; i <= endPage; i++)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: ElevatedButton(
              onPressed: () => getX.fetchNCDList(
                page: i,
                name: model.textController?.text ?? '',
                cid: model.textControllercid?.text ?? '',
                cdCode: diseaseCodeMap[model.diseaseController?.text] ?? '',
                status: model.filterstatusController?.text ?? '',
                startDate: model.pickedDateRange?.start,
                endDate: model.pickedDateRange?.end,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: i == currentPage ? Color(0xFF00855B) : Colors.white,
                foregroundColor: i == currentPage ? Colors.white : Colors.black,
                minimumSize: Size(36, 36),
                padding: EdgeInsets.zero,
              ),
              child: Text('$i'),
            ),
          ),
        if (endPage < totalPages)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text('...'),
          ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages
              ? () => getX.fetchNCDList(
                    page: currentPage + 1,
                    name: model.textController?.text ?? '',
                    cid: model.textControllercid?.text ?? '',
                    cdCode: diseaseCodeMap[model.diseaseController?.text] ?? '',
                    status: model.filterstatusController?.text ?? '',
                    startDate: model.pickedDateRange?.start,
                    endDate: model.pickedDateRange?.end,
                  )
              : null,
        ),
        // ปุ่มไปหน้าสุดท้าย
        IconButton(
          icon: Icon(Icons.last_page),
          onPressed: currentPage < totalPages
              ? () => getX.fetchNCDList(
                    page: totalPages,
                    name: model.textController?.text ?? '',
                    cid: model.textControllercid?.text ?? '',
                    cdCode: diseaseCodeMap[model.diseaseController?.text] ?? '',
                    status: model.filterstatusController?.text ?? '',
                    startDate: model.pickedDateRange?.start,
                    endDate: model.pickedDateRange?.end,
                  )
              : null,
        ),
      ],
    );
  });
}


// Widget buildPagination(NCDsgetX getX) {
//   return Obx(() {
//     final loading = getX.isNCDLoading.value;
//     final totalPages = getX.totalPages.value;
//     final currentPage = getX.currentPage.value;

//     if (loading) {
//       return SizedBox(); // หรือ CircularProgressIndicator() ถ้าจะให้หมุน
//     }

//     if (totalPages == 0) {
//       return Text('ไม่พบข้อมูล');
//     }

//     int maxButtons = 5;

//     int startPage = (currentPage - 2).clamp(1, (totalPages - maxButtons + 1).clamp(1, totalPages));
//     int endPage = (startPage + maxButtons - 1).clamp(1, totalPages);
//     // อ่านเฉพาะรหัสโรคจาก controller
//     final cdCode = getX.lastCdCode.value;
//     final status = getX.laststatus.value;
//     final cid = getX.lastCid.value;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // ปุ่มไปหน้าแรก
//         IconButton(
//           icon: Icon(Icons.first_page),
//           onPressed: currentPage > 1 ? () => getX.fetchNCDList(cdCode: cdCode, status: status, cid: cid, page: 1) : null,
//         ),
//         IconButton(
//           icon: Icon(Icons.chevron_left),
//           onPressed: currentPage > 1 ? () => getX.fetchNCDList(cdCode: cdCode, status: status, cid: cid, page: currentPage - 1) : null,
//         ),
//         for (int i = startPage; i <= endPage; i++)
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 2.0),
//             child: ElevatedButton(
//               onPressed: () => getX.fetchNCDList(cdCode: cdCode, status: status, cid: cid, page: i),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: i == currentPage ? Color(0xFF00855B) : Colors.white,
//                 foregroundColor: i == currentPage ? Colors.white : Colors.black,
//                 minimumSize: Size(36, 36),
//                 padding: EdgeInsets.zero,
//               ),
//               child: Text('$i'),
//             ),
//           ),
//         if (endPage < totalPages)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Text('...'),
//           ),
//         IconButton(
//           icon: Icon(Icons.chevron_right),
//           onPressed: currentPage < totalPages ? () => getX.fetchNCDList(cdCode: cdCode, status: status, cid: cid, page: currentPage + 1) : null,
//         ),
//         // ปุ่มไปหน้าสุดท้าย
//         IconButton(
//           icon: Icon(Icons.last_page),
//           onPressed: currentPage < totalPages ? () => getX.fetchNCDList(cdCode: cdCode, status: status, cid: cid, page: totalPages) : null,
//         ),
//       ],
//     );
//   });
// }




