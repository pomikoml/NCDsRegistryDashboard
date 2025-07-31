// ignore_for_file: unnecessary_string_interpolations

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';
import 'package:n_c_ds_registry_dashboard/components/health_region_widget.dart';
import 'package:n_c_ds_registry_dashboard/components/pie_by_report/pie_by_report_widget.dart';
import 'package:n_c_ds_registry_dashboard/components/pie_by_submit_status/pie_by_submit_status_widget.dart';
import 'package:n_c_ds_registry_dashboard/custom_code/widgets/syncfusion_combine_charts.dart';
import 'package:n_c_ds_registry_dashboard/pages/high_blood_pressure/chronickidneydisease_widget.dart';
import 'package:n_c_ds_registry_dashboard/pages/high_blood_pressure/copd_widget.dart';
import 'package:n_c_ds_registry_dashboard/pages/high_blood_pressure/diabets_widget.dart';
import 'package:n_c_ds_registry_dashboard/pages/high_blood_pressure/e_cigaretteuse_widget.dart';
import 'package:n_c_ds_registry_dashboard/pages/high_blood_pressure/heartdisease_widget.dart';
import 'package:n_c_ds_registry_dashboard/pages/high_blood_pressure/hyperlipidemia_widget.dart';
import 'package:n_c_ds_registry_dashboard/pages/high_blood_pressure/obesity_widget.dart';
import 'package:n_c_ds_registry_dashboard/pages/high_blood_pressure/stroke_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/header/header_widget.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dashboard_overview_model.dart';
export 'dashboard_overview_model.dart';

class DashboardOverviewWidget extends StatefulWidget {
  const DashboardOverviewWidget({super.key});

  static String routeName = 'Dashboard_Overview';
  static String routePath = '/dashboardOverview';
  @override
  State<DashboardOverviewWidget> createState() => _DashboardOverviewWidgetState();
}

class _DashboardOverviewWidgetState extends State<DashboardOverviewWidget> with TickerProviderStateMixin {
  late DashboardOverviewModel _model;
  final ScrollController _scrollController = ScrollController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  String? userLogin;
  String? hospitalCode;
  String? hospitalName;
  String? scopeList;
  String? cid = '';

  final numberFormat = NumberFormat('#,###');

  // final getX = Get.put(NCDsgetX());
  final getX = Get.find<NCDsgetX>();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardOverviewModel());
    _loadLoginData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getX.callAuthAPI();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _scrollController.dispose();
    super.dispose();
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

  void _loadLoginData() async {
    userLogin = await _getUserLogin();
    hospitalCode = await _getHospitalCode();
    hospitalName = await _getHospitalName();
    scopeList = await _getScopeList();
    cid = await _getcid();

    // print('User Login: $userLogin');
    // print('Hospital Code: $hospitalCode');
    // print('Hospital Name: $hospitalName');
    // print('Scope List: $scopeList');

    // คุณสามารถใช้ค่าที่ดึงมาเพื่อทำสิ่งต่างๆ ตามที่คุณต้องการ
  }

  List<String> getThaiYears({int count = 5}) {
    final now = DateTime.now();
    final currentThaiYear = now.year + 543;

    return [
      'ทั้งหมด',
      ...List.generate(count, (i) => 'พ.ศ. ${currentThaiYear - i}')
    ];
  }

  int fiscalYear = 0;
  void _fetchWithSelectedYear() {
    final selected = _model.dropDownValue1;

    int newYear = 0;
    if (selected != null && selected.isNotEmpty && selected != 'ทั้งหมด') {
      newYear = int.tryParse(selected.replaceAll('พ.ศ. ', '')) ?? 0;
    }

    setState(() {
      fiscalYear = newYear; // ✅ trigger UI rebuild
    });

    getX.fetchGroupByCdCode(fiscalYear: fiscalYear);
    getX.fetchGroupByGender(fiscalYear: fiscalYear);
    getX.fetchRegionRatePer1000(fiscalYear: fiscalYear);
    getX.fetchGroupByRegion(fiscalYear: fiscalYear);
    // ✅ เพิ่มการเรียกใช้ fetchGroupByRegionAndCd
    getX.fetchGroupByRegionAndCd(fiscalYear: fiscalYear);
    getX.fetchGroupByOrganizationAndCd(fiscalYear: fiscalYear);
    getX.fetchAllSubmissionData(fiscalYear: fiscalYear);
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
                          height: 140.0,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            alignment: AlignmentDirectional(-1.0, -1.0),
                                            image: Image.asset(
                                              'assets/images/banner-bg.png',
                                            ).image,
                                          ),
                                          borderRadius: BorderRadius.circular(24.0),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'แดชบอร์ดข้อมูลผู้ป่วย',
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Sarabun',
                                                            letterSpacing: 0.0,
                                                          ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      'โรคไม่ติดต่อเรื้อรัง',
                                                      style: FlutterFlowTheme.of(context).headlineLarge.override(
                                                            fontFamily: 'Sarabun',
                                                            color: FlutterFlowTheme.of(context).primary,
                                                            letterSpacing: 0.0,
                                                          ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      'Non-Communicable Diseases : NCDs',
                                                      style: FlutterFlowTheme.of(context).labelLarge.override(
                                                            fontFamily: 'Sarabun',
                                                            color: FlutterFlowTheme.of(context).primary,
                                                            letterSpacing: 0.0,
                                                          ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ].divide(SizedBox(height: 8.0)),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Align(
                                                alignment: AlignmentDirectional(1.0, 1.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 40.0, 0.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(0.0),
                                                    child: Image.asset(
                                                      'assets/images/obesity.png',
                                                      width: 172.0,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                  // .animateOnPageLoad(animationsMap['stackOnPageLoadAnimation']!),
                                  ),
                              Expanded(
                                  flex: 2,
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
                                      borderRadius: BorderRadius.circular(24.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                    child: FaIcon(
                                                      FontAwesomeIcons.database,
                                                      color: FlutterFlowTheme.of(context).primary,
                                                      size: 16.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'เลือกปี',
                                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(width: 8.0)),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  safeSetState(() {
                                                    _model.dropDownValueController1?.reset();
                                                    _fetchWithSelectedYear();
                                                  });
                                                },
                                                text: 'รีเซ็ต',
                                                icon: Icon(
                                                  Icons.restore_rounded,
                                                  size: 16.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 26.0,
                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  textStyle: FlutterFlowTheme.of(context).labelSmall.override(
                                                        fontFamily: 'Sarabun',
                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                        letterSpacing: 0.0,
                                                      ),
                                                  elevation: 0.0,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: AlignmentDirectional(-1.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
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
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                          child: Container(
                                                            width: 40.0,
                                                            height: 40.0,
                                                            decoration: BoxDecoration(
                                                              color: Color(0xFF00855B),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.calendar_today_rounded,
                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                              size: 20.0,
                                                            ),
                                                          ),
                                                        ),
                                                        // Expanded(
                                                        //   child: Container(
                                                        //     decoration: BoxDecoration(color: Color(255)),
                                                        //   ),
                                                        // ),
                                                        Expanded(
                                                          child: Stack(
                                                            alignment: AlignmentDirectional(1.0, 0.0),
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  Column(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            '',
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
                                                                      Container(
                                                                        child:
                                                                            // FlutterFlowDropDown<String>(
                                                                            //   multiSelectController: _model.dropDownValueController ??= FormListFieldController<String>(_model.dropDownValue ??= List<String>.from(
                                                                            //     FFAppConstants.years.take(1).toList() ?? [],
                                                                            //   )),
                                                                            //   options: getThaiYears(count: 10),
                                                                            //   // [
                                                                            //   //   'ทั้งหมด',
                                                                            //   //   'พ.ศ. 2567',
                                                                            //   //   'พ.ศ. 2566',
                                                                            //   //   '...'
                                                                            //   // ],

                                                                            //   searchHintTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                            //         fontFamily: 'Sarabun',
                                                                            //         letterSpacing: 0.0,
                                                                            //       ),
                                                                            //   searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                            //         fontFamily: 'Sarabun',
                                                                            //         letterSpacing: 0.0,
                                                                            //       ),
                                                                            //   textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                            //         fontFamily: 'Sarabun',
                                                                            //         letterSpacing: 0.0,
                                                                            //         fontWeight: FontWeight.normal,
                                                                            //       ),
                                                                            //   hintText: 'ทั้งหมด',
                                                                            //   searchHintText: 'ค้นหาปี',
                                                                            //   icon: Icon(
                                                                            //     Icons.arrow_drop_down_rounded,
                                                                            //     color: FlutterFlowTheme.of(context).primaryText,
                                                                            //     size: 0.0,
                                                                            //   ),
                                                                            //   elevation: 2.0,
                                                                            //   borderColor: Colors.transparent,
                                                                            //   borderWidth: 0.0,
                                                                            //   borderRadius: 8.0,
                                                                            //   margin: EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 0.0, 0.0),
                                                                            //   hidesUnderline: true,
                                                                            //   isOverButton: false,
                                                                            //   isSearchable: true,
                                                                            //   isMultiSelect: true,
                                                                            //   onMultiSelectChanged: (val) {
                                                                            //     safeSetState(() => _model.dropDownValue = val);
                                                                            //     _fetchWithSelectedYear(); // ✅ เรียก API พร้อม fiscal_year
                                                                            //   },
                                                                            // ),
                                                                            FlutterFlowDropDown<String>(
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

                                                                          onChanged: (val) {
                                                                            safeSetState(() => _model.dropDownValue1 = val);
                                                                            _fetchWithSelectedYear(); // ✅ เรียกเมื่อเลือกปี
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
                                                                          isMultiSelect: false, dropdownHeight: 300, maxHeight: 300,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 0.0, 0.0),
                                                                    child: Text(
                                                                      'ปีงบประมาณ',
                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                            fontFamily: 'Sarabun',
                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Padding(
                                                              //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                              //   child: Icon(
                                                              //     Icons.arrow_drop_down_rounded,
                                                              //     color: FlutterFlowTheme.of(context).primaryText,
                                                              //     size: 24.0,
                                                              //   ),
                                                              // ),
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
                                        ),
                                      ],
                                    ),
                                  )
                                  // .animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
                                  ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                        Row(
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
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
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
                                            child: FaIcon(
                                              FontAwesomeIcons.database,
                                              color: FlutterFlowTheme.of(context).primary,
                                              size: 16.0,
                                            ),
                                          ),
                                          Text(
                                            'กลุ่มโรคไม่ติดต่อเรื้อรัง',
                                            style: FlutterFlowTheme.of(context).titleSmall.override(
                                                  fontFamily: 'Sarabun',
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                      RawScrollbar(
                                        controller: _scrollController,
                                        // thumbVisibility: true, // ให้เห็น thumb ตลอด
                                        trackVisibility: true, // ถ้าต้องการให้ track ปรากฏด้วย
                                        thickness: 7, radius: Radius.circular(4), thumbColor: Colors.grey.withOpacity(0.3),
                                        child: SingleChildScrollView(
                                          controller: _scrollController,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: 12),
                                            child: Row(
                                              // mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Visibility(
                                                  visible: true,
                                                  child: MouseRegion(
                                                    opaque: false,
                                                    cursor: MouseCursor.defer ?? MouseCursor.defer,
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //       builder: (context) => HighBloodPressureWidget(),
                                                        //     ));
                                                        // context.pushNamed(
                                                        //   HighBloodPressureWidget.routeName,
                                                        // );
                                                        context.goNamed(DiabetesWidget.routeName);
                                                      },
                                                      child: Container(
                                                        width: 150,
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
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: 54.0,
                                                                height: 54.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFFEAF7FF),
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child: Image.asset(
                                                                    'assets/images/diabete.png',
                                                                    width: 36.0,
                                                                    height: 36.0,
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment(0.0, 0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              Obx(() => Text(
                                                                    // '$diseaseDiabetesCount',
                                                                    // '${getX.diseaseDiabetesCount.value}',
                                                                    numberFormat.format(getX.diseaseDiabetesCount.value),
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Sarabun',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing: 0.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  )),
                                                              Text(
                                                                // '$diseaseDiabetesDisplay',
                                                                // '${getX.diseaseDiabetesDisplay.value}',
                                                                'โรคเบาหวาน',
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              Text(
                                                                '(E10-E14)',
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(height: 4.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //   onEnter: ((event) async {
                                                    //     safeSetState(() => _model.diabetesHovered = true);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation1'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation1']!.controller.forward(from: 0.0);
                                                    //     }
                                                    //   }),
                                                    //   onExit: ((event) async {
                                                    //     safeSetState(() => _model.diabetesHovered = false);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation1'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation1']!.controller.reverse();
                                                    //     }
                                                    //   }),
                                                    // ).animateOnActionTrigger(
                                                    //   animationsMap['mouseRegionOnActionTriggerAnimation1']!,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: MouseRegion(
                                                    opaque: false,
                                                    cursor: MouseCursor.defer ?? MouseCursor.defer,
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //       builder: (context) => HighBloodPressureWidget(),
                                                        //     ));
                                                        // context.pushNamed(
                                                        //   HighBloodPressureWidget.routeName,
                                                        // );
                                                        context.goNamed(HighBloodPressureWidget.routeName);
                                                      },
                                                      child: Container(
                                                        width: 150,
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
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: 54.0,
                                                                height: 54.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFFE9E9E9),
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child: Image.asset(
                                                                    'assets/images/blood-pressure.png',
                                                                    width: 36.0,
                                                                    height: 36.0,
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment(0.0, 0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              Obx(() => Text(
                                                                    // '$diseaseHypertensionCount',
                                                                    // '${getX.diseaseHypertensionCount.value}',
                                                                    numberFormat.format(getX.diseaseHypertensionCount.value),
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Sarabun',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing: 0.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  )),
                                                              Text(
                                                                // '${getX.diseaseHypertensionDisplay.value}',
                                                                // '$diseaseHypertensionDisplay',
                                                                'โรคความดันโลหิตสูง',
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              Text(
                                                                '(I10-I14)',
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(height: 4.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //   onEnter: ((event) async {
                                                    //     safeSetState(() => _model.highBloodHovered = true);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation2'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation2']!.controller.forward(from: 0.0);
                                                    //     }
                                                    //   }),
                                                    //   onExit: ((event) async {
                                                    //     safeSetState(() => _model.highBloodHovered = false);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation2'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation2']!.controller.reverse();
                                                    //     }
                                                    //   }),
                                                    // ).animateOnActionTrigger(
                                                    //   animationsMap['mouseRegionOnActionTriggerAnimation2']!,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: MouseRegion(
                                                    opaque: false,
                                                    cursor: MouseCursor.defer ?? MouseCursor.defer,
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //       builder: (context) => HighBloodPressureWidget(),
                                                        //     ));
                                                        // context.pushNamed(
                                                        //   HighBloodPressureWidget.routeName,
                                                        // );
                                                        context.goNamed(ChronicKidneyDiseaseWidget.routeName);
                                                      },
                                                      child: Container(
                                                        width: 150,
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
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: 54.0,
                                                                height: 54.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFFFFF7DB),
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child: Image.asset(
                                                                    'assets/images/kidney.png',
                                                                    width: 36.0,
                                                                    height: 36.0,
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment(0.0, 0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              Obx(() => Text(
                                                                    // '$diseaseKidneyCount',
                                                                    // '${getX.diseaseKidneyCount.value}',
                                                                    numberFormat.format(getX.diseaseKidneyCount.value),
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Sarabun',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing: 0.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  )),
                                                              Text(
                                                                // '$diseaseKidneyDisplay',
                                                                // '${getX.diseaseKidneyDisplay.value}',
                                                                'โรคไตวายเรื้อรัง',
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              Text(
                                                                '(N18.3-N18.9)',
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(height: 4.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //   onEnter: ((event) async {
                                                    //     safeSetState(() => _model.kidneyHovered = true);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation3'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation3']!.controller.forward(from: 0.0);
                                                    //     }
                                                    //   }),
                                                    //   onExit: ((event) async {
                                                    //     safeSetState(() => _model.kidneyHovered = false);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation3'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation3']!.controller.reverse();
                                                    //     }
                                                    //   }),
                                                    // ).animateOnActionTrigger(
                                                    //   animationsMap['mouseRegionOnActionTriggerAnimation3']!,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: MouseRegion(
                                                    opaque: false,
                                                    cursor: MouseCursor.defer ?? MouseCursor.defer,
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //       builder: (context) => HighBloodPressureWidget(),
                                                        //     ));
                                                        // context.pushNamed(
                                                        //   HighBloodPressureWidget.routeName,
                                                        // );
                                                        context.goNamed(HeartDiseaseWidget.routeName);
                                                      },
                                                      child: Container(
                                                        width: 150,
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
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: 54.0,
                                                                height: 54.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFFFFF8E6),
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child: Image.asset(
                                                                    'assets/images/heart.png',
                                                                    width: 36.0,
                                                                    height: 36.0,
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment(0.0, 0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              Obx(() => Text(
                                                                    // '${getX.diseaseHeartCount.value}',
                                                                    numberFormat.format(getX.diseaseHeartCount.value),
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Sarabun',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing: 0.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  )),
                                                              Text(
                                                                'โรคหัวใจ',
                                                                // '${getX.diseaseHeartDisplay.value ?? 'โรคหัวใจ'}',
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              Text(
                                                                '(I20-I25)',
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(height: 4.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //   onEnter: ((event) async {
                                                    //     safeSetState(() => _model.arteryHovered = true);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation4'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation4']!.controller.forward(from: 0.0);
                                                    //     }
                                                    //   }),
                                                    //   onExit: ((event) async {
                                                    //     safeSetState(() => _model.arteryHovered = false);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation4'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation4']!.controller.reverse();
                                                    //     }
                                                    //   }),
                                                    // ).animateOnActionTrigger(
                                                    //   animationsMap['mouseRegionOnActionTriggerAnimation4']!,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: MouseRegion(
                                                    opaque: false,
                                                    cursor: MouseCursor.defer ?? MouseCursor.defer,
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //       builder: (context) => HighBloodPressureWidget(),
                                                        //     ));
                                                        // context.pushNamed(
                                                        //   HighBloodPressureWidget.routeName,
                                                        // );
                                                        context.goNamed(StrokeWidget.routeName);
                                                      },
                                                      child: Container(
                                                        width: 150,
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
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: 54.0,
                                                                height: 54.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFFFFECEE),
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child: Image.asset(
                                                                    'assets/images/brain.png',
                                                                    width: 36.0,
                                                                    height: 36.0,
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment(0.0, 0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              Obx(() => Text(
                                                                    // '$diseaseHeartStrokeCount',
                                                                    // '${getX.diseaseStrokeCount.value}',
                                                                    numberFormat.format(getX.diseaseStrokeCount.value),
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Sarabun',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing: 0.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  )),
                                                              Text(
                                                                // '$diseaseHeartStrokeDisplay',
                                                                'โรคหลอดเลือดสมอง',
                                                                // '${getX.diseaseStrokeDisplay.value}',
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              Text(
                                                                '(I60-I69)',
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(height: 4.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //   onEnter: ((event) async {
                                                    //     safeSetState(() => _model.brainHovered = true);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation5'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation5']!.controller.forward(from: 0.0);
                                                    //     }
                                                    //   }),
                                                    //   onExit: ((event) async {
                                                    //     safeSetState(() => _model.brainHovered = false);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation5'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation5']!.controller.reverse();
                                                    //     }
                                                    //   }),
                                                    // ).animateOnActionTrigger(
                                                    //   animationsMap['mouseRegionOnActionTriggerAnimation5']!,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: MouseRegion(
                                                    opaque: false,
                                                    cursor: MouseCursor.defer ?? MouseCursor.defer,
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //       builder: (context) => HighBloodPressureWidget(),
                                                        //     ));
                                                        // context.pushNamed(
                                                        //   HighBloodPressureWidget.routeName,
                                                        // );
                                                        context.goNamed(COPDWidget.routeName);
                                                      },
                                                      child: Container(
                                                        width: 150,
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
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: 54.0,
                                                                height: 54.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFFFFE8E8),
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child: Image.asset(
                                                                    'assets/images/copd.png',
                                                                    width: 36.0,
                                                                    height: 36.0,
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment(0.0, 0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              Obx(() => Text(
                                                                    // '$diseaseEmphysemaCount',
                                                                    // '${getX.diseaseEmphysemaCount.value}',
                                                                    numberFormat.format(getX.diseaseEmphysemaCount.value),
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Sarabun',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing: 0.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  )),
                                                              Text(
                                                                // '$diseaseEmphysemaDisplay',
                                                                // '${getX.diseaseEmphysemaDisplay.value}',
                                                                // 'COPD',
                                                                'โรคถุงลมโป่งพอง',
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              Text(
                                                                '(J44)',
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(height: 4.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //   onEnter: ((event) async {
                                                    //     safeSetState(() => _model.copdHovered = true);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation6'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation6']!.controller.forward(from: 0.0);
                                                    //     }
                                                    //   }),
                                                    //   onExit: ((event) async {
                                                    //     safeSetState(() => _model.copdHovered = false);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation6'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation6']!.controller.reverse();
                                                    //     }
                                                    //   }),
                                                    // ).animateOnActionTrigger(
                                                    //   animationsMap['mouseRegionOnActionTriggerAnimation6']!,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: MouseRegion(
                                                    opaque: false,
                                                    cursor: MouseCursor.defer ?? MouseCursor.defer,
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //       builder: (context) => HighBloodPressureWidget(),
                                                        //     ));
                                                        // context.pushNamed(
                                                        //   HighBloodPressureWidget.routeName,
                                                        // );
                                                        context.goNamed(HyperlipidemiaWidget.routeName);
                                                      },
                                                      child: Container(
                                                        width: 150,
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
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: 54.0,
                                                                height: 54.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFFFFEDE2),
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child: Image.asset(
                                                                    'assets/images/highFat.png',
                                                                    width: 36.0,
                                                                    height: 36.0,
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment(0.0, 0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              Obx(() => Text(
                                                                    // '$diseaseCholesterolCount',
                                                                    // '${getX.diseaseCholesterolCount.value}',
                                                                    numberFormat.format(getX.diseaseCholesterolCount.value),
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Sarabun',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing: 0.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  )),
                                                              Text(
                                                                // '$diseaseCholesterolDisplay',
                                                                // '${getX.diseaseCholesterolDisplay.value}',
                                                                'โรคไขมันในเลือดสูง',
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              Text(
                                                                '(E78)',
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(height: 4.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //   onEnter: ((event) async {
                                                    //     safeSetState(() => _model.bloodFatHovered = true);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation7'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation7']!.controller.forward(from: 0.0);
                                                    //     }
                                                    //   }),
                                                    //   onExit: ((event) async {
                                                    //     safeSetState(() => _model.bloodFatHovered = false);
                                                    //     if (animationsMap['mouseRegionOnActionTriggerAnimation7'] != null) {
                                                    //       animationsMap['mouseRegionOnActionTriggerAnimation7']!.controller.reverse();
                                                    //     }
                                                    //   }),
                                                    // ).animateOnActionTrigger(
                                                    //   animationsMap['mouseRegionOnActionTriggerAnimation7']!,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: MouseRegion(
                                                    opaque: false,
                                                    cursor: MouseCursor.defer ?? MouseCursor.defer,
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //       builder: (context) => HighBloodPressureWidget(),
                                                        //     ));
                                                        // context.pushNamed(
                                                        //   HighBloodPressureWidget.routeName,
                                                        // );
                                                        context.goNamed(ObesityWidget.routeName);
                                                      },
                                                      child: Container(
                                                        width: 150,
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
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: 54.0,
                                                                height: 54.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFFEAF7FF),
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child: Image.asset(
                                                                    'assets/images/obesity_menu.png',
                                                                    width: 36.0,
                                                                    height: 36.0,
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment(0.0, 0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              Obx(() => Text(
                                                                    // '$diseaseObesityCount',
                                                                    // '${getX.diseaseObesityCount.value}',
                                                                    numberFormat.format(getX.diseaseObesityCount.value),
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Sarabun',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing: 0.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  )),
                                                              Text(
                                                                // '$diseaseObesityDisplay',
                                                                // '${getX.diseaseObesityDisplay.value}',
                                                                'โรคอ้วน',
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              Text(
                                                                '(E66)',
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(height: 4.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // onEnter: ((event) async {
                                                    //   safeSetState(() => _model.obesityHovered = true);
                                                    //   if (animationsMap['mouseRegionOnActionTriggerAnimation8'] != null) {
                                                    //     animationsMap['mouseRegionOnActionTriggerAnimation8']!.controller.forward(from: 0.0);
                                                    //   }
                                                    // }),
                                                    // onExit: ((event) async {
                                                    //   safeSetState(() => _model.obesityHovered = false);
                                                    //   if (animationsMap['mouseRegionOnActionTriggerAnimation8'] != null) {
                                                    //     animationsMap['mouseRegionOnActionTriggerAnimation8']!.controller.reverse();
                                                    //   }
                                                    // }),
                                                  ),
                                                  // .animateOnActionTrigger(
                                                  //   animationsMap['mouseRegionOnActionTriggerAnimation8']!,
                                                  // ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: MouseRegion(
                                                    opaque: false,
                                                    cursor: MouseCursor.defer ?? MouseCursor.defer,
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        context.goNamed(E_CigaretteUseWidget.routeName);
                                                      },
                                                      child: Container(
                                                        width: 150,
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
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Container(
                                                                width: 54.0,
                                                                height: 54.0,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFFFFECEE),
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child:
                                                                      // Icon(
                                                                      //   Icons.plus_one_sharp,
                                                                      //   color: FlutterFlowTheme.of(context).primary,
                                                                      //   size: 16.0,
                                                                      // ),
                                                                      Image.asset(
                                                                    'assets/images/e-cig.png',
                                                                    width: 36.0,
                                                                    height: 36.0,
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment(0.0, 0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              Obx(() => Text(
                                                                    // '0',
                                                                    // '${getX.e_cigaretteCount.value}',
                                                                    numberFormat.format(getX.e_cigaretteCount.value),
                                                                    // '$diseaseCancerCount',
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Sarabun',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing: 0.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  )),
                                                              Text(
                                                                // '$diseaseCancerDisplay',
                                                                'บุหรี่ไฟฟ้า',

                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              Text(
                                                                '(F17)',
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Sarabun',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(height: 4.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // onEnter: ((event) async {
                                                    //   safeSetState(() => _model.vapeHovered = true);
                                                    //   if (animationsMap['mouseRegionOnActionTriggerAnimation9'] != null) {
                                                    //     animationsMap['mouseRegionOnActionTriggerAnimation9']!.controller.forward(from: 0.0);
                                                    //   }
                                                    // }),
                                                    // onExit: ((event) async {
                                                    //   safeSetState(() => _model.vapeHovered = false);
                                                    //   if (animationsMap['mouseRegionOnActionTriggerAnimation9'] != null) {
                                                    //     animationsMap['mouseRegionOnActionTriggerAnimation9']!.controller.reverse();
                                                    //   }
                                                    // }),
                                                  ),
                                                  // .animateOnActionTrigger(
                                                  //   animationsMap['mouseRegionOnActionTriggerAnimation9']!,
                                                  // ),
                                                ),
                                              ].divide(SizedBox(width: 12.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                              // .animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),

                        Row(
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
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
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
                                              Icons.pie_chart_rounded,
                                              color: FlutterFlowTheme.of(context).primary,
                                              size: 16.0,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'ร้อยละผู้ป่วยกลุ่มโรคไม่ติดต่อเรื้อรัง',
                                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Sarabun',
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(24.0),
                                        child: Container(
                                            width: double.infinity,
                                            height: 256.0,
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
                                            child: Obx(
                                              () => Container(
                                                width: 256.0,
                                                height: 256.0,
                                                child: custom_widgets.SyncfusionDonutOverview(
                                                  width: 256.0,
                                                  height: 256.0,
                                                  CholesterolPercent: getX.diseaseCholesterolPercent.value,
                                                  DiabetesPercent: getX.diseaseDiabetesPercent.value,
                                                  EmphysemaPercent: getX.diseaseEmphysemaPercent.value,
                                                  HeartPercent: getX.diseaseHeartPercent.value,
                                                  StrokePercent: getX.diseaseStrokePercent.value,
                                                  HypertensionPercent: getX.diseaseHypertensionPercent.value,
                                                  KidneyPercent: getX.diseaseKidneyPercent.value,
                                                  ObesityPercent: getX.diseaseObesityPercent.value,
                                                  cancerPercent: getX.diseaseCancerPercent.value,
                                                  ECigarettePercent: getX.e_cigarettePercent.value,
                                                ),
                                              ),
                                            )),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
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
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      LayoutBuilder(builder: (context, constraints) {
                                        final showRemark = constraints.maxWidth > 500;
                                        return Row(
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
                                                Icons.pie_chart_rounded,
                                                color: FlutterFlowTheme.of(context).primary,
                                                size: 16.0,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'จำนวนผู้ป่วยกลุ่มโรคไม่ติดต่อเรื้อรัง',
                                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                                      fontFamily: 'Sarabun',
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // wrapWithModel(
                                            //   model: _model.remarkWidgetModel1,
                                            //   updateCallback: () => safeSetState(() {}),
                                            //   child: RemarkWidgetWidget(
                                            //     text: 'หน่วยนับ : คน',
                                            //   ),
                                            // ),
                                            if (showRemark) ...[
                                              SizedBox(width: 8),
                                              wrapWithModel(
                                                model: _model.remarkWidgetModel1,
                                                updateCallback: () => safeSetState(() {}),
                                                child: RemarkWidgetWidget(text: 'หน่วยนับ : คน'),
                                              ),
                                            ],
                                          ].divide(SizedBox(width: 8.0)),
                                        );
                                      }),
                                      Container(
                                        height: 256.0,
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
                                          borderRadius: BorderRadius.circular(24.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                          ),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          height: 256.0,
                                          child: custom_widgets.SyncfusionCombineCharts(
                                            width: double.infinity,
                                            height: 256.0,
                                            selected: fiscalYear,
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),

                        // .animateOnPageLoad(animationsMap['rowOnPageLoadAnimation1']!),

                        Row(
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
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      LayoutBuilder(builder: (context, constraints) {
                                        // ถ้า maxWidth มากกว่า 320px ถึงโชว์ remark
                                        final showRemark = constraints.maxWidth > 500;
                                        return Row(
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
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: Image.asset(
                                                  'assets/images/image_33.png',
                                                  width: 16.0,
                                                  height: 16.0,
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment(0.0, 0.0),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'ผู้ป่วยกลุ่มโรคไม่ติดต่อเรื้อรังจำแนกตามเพศ',
                                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                                      fontFamily: 'Sarabun',
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // wrapWithModel(
                                            //   model: _model.remarkWidgetModel2,
                                            //   updateCallback: () => safeSetState(() {}),
                                            //   child: RemarkWidgetWidget(
                                            //     text: 'หน่วยนับ : คน',
                                            //   ),
                                            // ),
                                            if (showRemark) ...[
                                              SizedBox(width: 8),
                                              wrapWithModel(
                                                model: _model.remarkWidgetModel2,
                                                updateCallback: () => safeSetState(() {}),
                                                child: RemarkWidgetWidget(text: 'หน่วยนับ : คน'),
                                              ),
                                            ],
                                          ].divide(SizedBox(width: 8.0)),
                                        );
                                      }),
                                      // Expanded(
                                      Container(
                                        height: 100.0,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 100.0,
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
                                                borderRadius: BorderRadius.circular(16.0),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 54.0,
                                                      height: 54.0,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xFFEAF7FF),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(context).alternate,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      alignment: AlignmentDirectional(0.0, 0.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/image_34.png',
                                                          width: 36.0,
                                                          height: 36.0,
                                                          fit: BoxFit.cover,
                                                          alignment: Alignment(0.0, 0.0),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 54.0,
                                                      height: 54.0,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xFFFFEBEF),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(context).alternate,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      alignment: AlignmentDirectional(0.0, 0.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/image_35.png',
                                                          width: 36.0,
                                                          height: 36.0,
                                                          fit: BoxFit.cover,
                                                          alignment: Alignment(0.0, 0.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(SizedBox(width: 8.0)),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(0.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(80.0, 0.0, 80.0, 20.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 63.0,
                                                  child: custom_widgets.CustomSegmentedProgressBar(
                                                    width: double.infinity,
                                                    height: 40.0, //40
                                                    selected: fiscalYear,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),

                        // .animateOnPageLoad(animationsMap['rowOnPageLoadAnimation2']!),
                        Row(
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
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      LayoutBuilder(builder: (context, constraints) {
                                        // ถ้า maxWidth มากกว่า 320px ถึงโชว์ remark
                                        final showRemark = constraints.maxWidth > 500;
                                        return Row(
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
                                                Icons.bar_chart_rounded,
                                                color: FlutterFlowTheme.of(context).primary,
                                                size: 16.0,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'จำนวนผู้ป่วยกลุ่มโรคไม่ติดต่อเรื้อรัง จำแนกเขตสุขภาพ',
                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                      fontFamily: 'Sarabun',
                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // wrapWithModel(
                                            //   model: _model.remarkWidgetModel3,
                                            //   updateCallback: () => safeSetState(() {}),
                                            //   child: RemarkWidgetWidget(
                                            //     text: 'หน่วยนับ : คน',
                                            //   ),
                                            // ),
                                            if (showRemark) ...[
                                              SizedBox(width: 8),
                                              wrapWithModel(
                                                model: _model.remarkWidgetModel3,
                                                updateCallback: () => safeSetState(() {}),
                                                child: RemarkWidgetWidget(text: 'หน่วยนับ : คน'),
                                              ),
                                            ],
                                          ].divide(SizedBox(width: 8.0)),
                                        );
                                      }),
                                      Container(
                                        width: double.infinity,
                                        height: 256.0,
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
                                          borderRadius: BorderRadius.circular(24.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 228.0,
                                              child: custom_widgets.SyncfusionBar(
                                                width: double.infinity,
                                                height: 228.0,
                                                rate: '1',
                                                selected: fiscalYear,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    '1',
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '2',
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '3',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '4',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '5',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '6',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '7',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '8',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '9',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '10',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '11',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '12',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '13',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
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
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      LayoutBuilder(builder: (context, constraints) {
                                        // ถ้า maxWidth มากกว่า 320px ถึงโชว์ remark
                                        final showRemark = constraints.maxWidth > 500;
                                        return Row(
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
                                                Icons.bar_chart_rounded,
                                                color: FlutterFlowTheme.of(context).primary,
                                                size: 16.0,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'อัตราผู้ป่วยกลุ่มโรคไม่ติดต่อเรื้อรัง จำแนกเขตสุขภาพ',
                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                      fontFamily: 'Sarabun',
                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // wrapWithModel(
                                            //   model: _model.remarkWidgetModel4,
                                            //   updateCallback: () => safeSetState(() {}),
                                            //   child: RemarkWidgetWidget(
                                            //     text: 'ต่อประชากรพันคน',
                                            //   ),
                                            // ),
                                            if (showRemark) ...[
                                              SizedBox(width: 8),
                                              wrapWithModel(
                                                model: _model.remarkWidgetModel4,
                                                updateCallback: () => safeSetState(() {}),
                                                child: RemarkWidgetWidget(text: 'ต่อประชากรพันคน'),
                                              ),
                                            ],
                                          ].divide(SizedBox(width: 8.0)),
                                        );
                                      }),
                                      Container(
                                        width: double.infinity,
                                        height: 256.0,
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
                                          borderRadius: BorderRadius.circular(24.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 228.0,
                                              child: custom_widgets.SyncfusionBar2(
                                                width: double.infinity,
                                                height: 228.0,
                                                selected: fiscalYear,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    '1',
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '2',
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '3',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '4',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '5',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '6',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '7',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '8',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '9',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '10',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '11',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '12',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '13',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Sarabun',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: wrapWithModel(
                                model: _model.pieByReportModel,
                                updateCallback: () => safeSetState(() {}),
                                child: Obx(() => PieByReportWidget(
                                      submitted: getX.statusSubmittedCount.value,
                                      await: getX.statusNotSubmittedCount.value,
                                      submittedPercent: getX.statusSubmittedPercent.value,
                                      awaitPercent: getX.statusNotSubmittedPercent.value,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: wrapWithModel(
                                model: _model.pieBySubmitStatusModel,
                                updateCallback: () => safeSetState(() {}),
                                child: Obx(() => PieBySubmitStatusWidget(
                                      ontime: getX.statusExcellentCount.value,
                                      pending: getX.statusPendingCount.value,
                                      late: getX.statusLateCount.value,
                                      ontimePercent: getX.statusExcellentPercent.value,
                                      pendingPercent: getX.statusPendingPercent.value,
                                      latePercent: getX.statusLatePercent.value,
                                    )),
                              ),
                            ),
                          ],
                        ),

                        wrapWithModel(
                          model: _model.healthRegionModel,
                          updateCallback: () => safeSetState(() {}),
                          child: HealthRegionWidget(),
                        ),
                        // .animateOnPageLoad(animationsMap['rowOnPageLoadAnimation3']!),
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
