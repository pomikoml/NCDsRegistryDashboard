import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'sample_table_model.dart';
export 'sample_table_model.dart';

class SampleTableWidget extends StatefulWidget {
  const SampleTableWidget({
    super.key,
    this.onRowTap,
    this.selectedRegion,
  });

  final Function(int region)? onRowTap;
  final int? selectedRegion;

  @override
  State<SampleTableWidget> createState() => _SampleTableWidgetState();
}

class _SampleTableWidgetState extends State<SampleTableWidget> {
  final ScrollController _verticalController = ScrollController();
  late SampleTableModel _model;
  final getX = Get.find<NCDsgetX>(); // เชื่อมต่อกับ GetX controller

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SampleTableModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  // ฟังก์ชันสำหรับดึงข้อมูลจำนวนผู้ป่วยของแต่ละโรคในแต่ละเขตสุขภาพ
  int getDiseaseCountForRegion(int regionId, String diseaseKey) {
    final count = getX.getDiseaseCountByHealthRegion(regionId, diseaseKey);
    return count;
  }

  // ฟังก์ชันสำหรับ format ตัวเลข
  String formatNumber(int number) {
    if (number == 0) return '0';
    return NumberFormat('#,###').format(number);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final maxTableHeight = availableHeight > 600 ? 600.0 : availableHeight * 0.9;

        return Container(
          width: double.infinity,
          height: maxTableHeight,
          decoration: BoxDecoration(
            color: Color(0xCDFFFFFF),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        // Fixed left column (เขตสุขภาพ)
                        Container(
                          width: 156.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFEAF7FF),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 0.0,
                                color: FlutterFlowTheme.of(context).alternate,
                                offset: Offset(1.0, 0.0),
                              )
                            ],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(14.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(14.0),
                              topRight: Radius.circular(0.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Header
                              Container(
                                width: 156.0,
                                height: 54.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFEAF7FF),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14.0),
                                    topRight: Radius.circular(0.0),
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'เขตสุขภาพ',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'IBM Plex Sans Thai Looped',
                                            color: FlutterFlowTheme.of(context).primary,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ),
                              ),

                              // Data rows
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(14.0),
                                    ),
                                  ),
                                  child: ListView.builder(
                                    controller: _verticalController, // ← เพิ่มตรงนี้
                                    physics: ClampingScrollPhysics(), // ← ปรับ physics ให้แน่นหน่อย
                                    padding: EdgeInsets.zero,
                                    itemCount: 13,
                                    itemExtent: 64.0,
                                    itemBuilder: (context, index) {
                                      int i = index + 1;
                                      return Container(
                                        height: 64.0,
                                        width: 156.0,
                                        decoration: BoxDecoration(
                                          color: widget.selectedRegion == i
                                              ? FlutterFlowTheme.of(context).primary.withOpacity(0.1) // Highlight selected
                                              : i % 2 == 0
                                                  ? FlutterFlowTheme.of(context).primaryBackground
                                                  : FlutterFlowTheme.of(context).secondaryBackground,
                                          border: widget.selectedRegion == i
                                              ? Border.all(
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  width: 2.0,
                                                )
                                              : null,
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(
                                              'เขตสุขภาพที่ $i',
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                    fontFamily: 'IBM Plex Sans Thai Looped',
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Scrollable content area (ข้อมูลโรค)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(14.0),
                                topRight: Radius.circular(14.0),
                              ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  // Header row
                                  Container(
                                    height: 54.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEAF7FF),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(14.0),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        for (String header in [
                                          'เบาหวาน',
                                          'ความดันโลหิตสูง',
                                          'ไตวายเรื้อรัง',
                                          'โรคหัวใจ',
                                          'หลอดเลือดสมอง',
                                          'COPD',
                                          'ไขมันในเลือดสูง',
                                          'โรคอ้วน',
                                          'บุหรี่ไฟฟ้า'
                                        ]) ...[
                                          Container(
                                            width: 156.0,
                                            height: 54.0,
                                            decoration: BoxDecoration(),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  header,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        fontFamily: 'IBM Plex Sans Thai Looped',
                                                        color: FlutterFlowTheme.of(context).primary,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 24.0),
                                        ],
                                      ],
                                    ),
                                  ),

                                  // Data rows with API data
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(14.0),
                                        ),
                                      ),
                                      child: Obx(() {
                                        // แสดง loading หากข้อมูลยังไม่พร้อม
                                        if (getX.isLoading.value) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: FlutterFlowTheme.of(context).primary,
                                            ),
                                          );
                                        }

                                        return ListView.builder(
                                          controller: _verticalController, // ← และตรงนี้ด้วย
                                          physics: ClampingScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: 13,
                                          itemExtent: 64.0,
                                          itemBuilder: (context, index) {
                                            int regionId = index + 1;

                                            // ดึงข้อมูลจาก API ผ่าน GetX controller
                                            List<String> diseaseData = [
                                              formatNumber(getDiseaseCountForRegion(regionId, 'diabetes')), // เบาหวาน
                                              formatNumber(getDiseaseCountForRegion(regionId, 'hypertension')), // ความดันโลหิตสูง
                                              formatNumber(getDiseaseCountForRegion(regionId, 'kidney')), // ไตวายเรื้อรัง
                                              formatNumber(getDiseaseCountForRegion(regionId, 'heart')), // โรคหัวใจ
                                              formatNumber(getDiseaseCountForRegion(regionId, 'stroke')), // หลอดเลือดสมอง
                                              formatNumber(getDiseaseCountForRegion(regionId, 'copd')), // COPD
                                              formatNumber(getDiseaseCountForRegion(regionId, 'cholesterol')), // ไขมันในเลือดสูง
                                              formatNumber(getDiseaseCountForRegion(regionId, 'obesity')), // โรคอ้วน
                                              formatNumber(getDiseaseCountForRegion(regionId, 'e_cigarette')), // บุหรี่ไฟฟ้า
                                            ];

                                            return MouseRegion(
                                              onEnter: (_) {},
                                              onExit: (_) {},
                                              child: InkWell(
                                                onTap: () => widget.onRowTap?.call(regionId),
                                                child: Container(
                                                  height: 64.0,
                                                  decoration: BoxDecoration(
                                                    color: widget.selectedRegion == regionId
                                                        ? FlutterFlowTheme.of(context).primary.withOpacity(0.1) // Highlight selected
                                                        : regionId % 2 == 0
                                                            ? FlutterFlowTheme.of(context).primaryBackground
                                                            : FlutterFlowTheme.of(context).secondaryBackground,
                                                    border: widget.selectedRegion == regionId
                                                        ? Border.all(
                                                            color: FlutterFlowTheme.of(context).primary,
                                                            width: 2.0,
                                                          )
                                                        : null,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      for (String data in diseaseData) ...[
                                                        Container(
                                                          width: 156.0,
                                                          height: 64.0,
                                                          decoration: BoxDecoration(),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Text(
                                                                data,
                                                                textAlign: TextAlign.center,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                      fontFamily: 'IBM Plex Sans Thai Looped',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 24.0),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
