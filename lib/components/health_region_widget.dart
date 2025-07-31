import 'dart:convert';
import 'package:get/get.dart';
import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'health_region_model.dart';
export 'health_region_model.dart';

// ปรับ imports สำหรับ file download
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Platform, File;
// สำหรับ web platform only:
import 'dart:html' as html show Blob, Url, document, AnchorElement;

class SampleTableWidget extends StatefulWidget {
  const SampleTableWidget({
    super.key,
    this.onRowTap,
    this.selectedRegion,
  });

  final void Function(int region)? onRowTap;
  final int? selectedRegion;

  @override
  State<SampleTableWidget> createState() => _SampleTableWidgetState();
}

class _SampleTableWidgetState extends State<SampleTableWidget> {
  late ScrollController _leftController;
  late ScrollController _rightController;
  final numberFormat = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _leftController = ScrollController();
    _rightController = ScrollController();

    // ซิงก์ตำแหน่ง scroll แนวตั้ง
    _leftController.addListener(() {
      if (_rightController.hasClients && _rightController.offset != _leftController.offset) {
        _rightController.jumpTo(_leftController.offset);
      }
    });
    _rightController.addListener(() {
      if (_leftController.hasClients && _leftController.offset != _rightController.offset) {
        _leftController.jumpTo(_rightController.offset);
      }
    });
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   final hc = Get.find<NCDsgetX>();

  //   return Obx(() {
  //     final tableData = hc.getHealthRegionTableData();
  //     final headers = [
  //       'เบาหวาน',
  //       'ความดันโลหิตสูง',
  //       'ไตวายเรื้อรัง',
  //       'โรคหัวใจ',
  //       'หลอดเลือดสมอง',
  //       'COPD',
  //       'ไขมันในเลือดสูง',
  //       'โรคอ้วน',
  //       'บุหรี่ไฟฟ้า',
  //     ];

  //     return LayoutBuilder(builder: (context, constraints) {
  //       final maxTableHeight = (constraints.maxHeight > 900 ? 900.0 : constraints.maxHeight * 0.9);

  //       return Container(
  //         width: double.infinity,
  //         height: maxTableHeight,
  //         decoration: BoxDecoration(
  //           // color: const Color.fromARGB(255, 234, 255, 237),
  //           color: const Color.fromARGB(255, 11, 245, 46),
  //           borderRadius: BorderRadius.circular(16),
  //           border: Border.all(color: FlutterFlowTheme.of(context).secondaryBackground),
  //         ),
  //         child: Row(
  //           children: [
  //             // — คอลัมน์ซ้าย (Fixed) —
  //             Column(
  //               children: [
  //                 // Header
  //                 Container(
  //                   width: 156,
  //                   height: 54,
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     'เขตสุขภาพ',
  //                     style: FlutterFlowTheme.of(context).bodyMedium.override(
  //                           fontFamily: 'IBM Plex Sans Thai Looped',
  //                           color: FlutterFlowTheme.of(context).primary,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                   ),
  //                 ),
  //                 // รายชื่อเขตสุขภาพ
  //                 Expanded(
  //                   child: SingleChildScrollView(
  //                     controller: _leftController,
  //                     child: Column(
  //                       children: List.generate(tableData.length, (i) {
  //                         final regionId = tableData[i]['region_id'] as int;
  //                         final isEven = regionId % 2 == 0;
  //                         return InkWell(
  //                           onTap: () => widget.onRowTap?.call(regionId),
  //                           child: Container(
  //                             width: 156,
  //                             height: 64,
  //                             color: isEven ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).secondaryBackground,
  //                             alignment: Alignment.center,
  //                             child: Text(
  //                               'เขตสุขภาพที่ $regionId',
  //                               style: FlutterFlowTheme.of(context).bodyLarge.override(
  //                                     fontFamily: 'IBM Plex Sans Thai Looped',
  //                                     color: FlutterFlowTheme.of(context).secondaryText,
  //                                   ),
  //                             ),
  //                           ),
  //                         );
  //                       }),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),

  //             // — ช่องว่างแบ่งคอลัมน์ —
  //             const SizedBox(width: 1),

  //             // — ข้อมูลขวา (Scroll แนวนอน + แนวตั้ง) —
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 child: SizedBox(
  //                   width: headers.length * 156.0,
  //                   child: Column(
  //                     children: [
  //                       // Header row ของข้อมูล
  //                       Container(
  //                         height: 54,
  //                         child: Row(
  //                           children: headers.map((h) {
  //                             return Container(
  //                               // width: 156,
  //                               height: 54,
  //                               alignment: Alignment.center,
  //                               child: Text(
  //                                 h,
  //                                 style: FlutterFlowTheme.of(context).bodyMedium.override(
  //                                       fontFamily: 'IBM Plex Sans Thai Looped',
  //                                       color: FlutterFlowTheme.of(context).primary,
  //                                       fontWeight: FontWeight.w600,
  //                                     ),
  //                               ),
  //                             );
  //                           }).toList(),
  //                         ),
  //                       ),
  //                       // Data rows
  //                       Expanded(
  //                         child: SingleChildScrollView(
  //                           controller: _rightController,
  //                           child: Column(
  //                             children: tableData.map((row) {
  //                               final regionId = row['region_id'] as int;
  //                               final isEven = regionId % 2 == 0;
  //                               return InkWell(
  //                                 onTap: () => widget.onRowTap?.call(regionId),
  //                                 child: Row(
  //                                   children: headers.map((key) {
  //                                     final mapKey = {
  //                                       'เบาหวาน': 'diabetes',
  //                                       'ความดันโลหิตสูง': 'hypertension',
  //                                       'ไตวายเรื้อรัง': 'kidney',
  //                                       'โรคหัวใจ': 'heart',
  //                                       'หลอดเลือดสมอง': 'stroke',
  //                                       'COPD': 'copd',
  //                                       'ไขมันในเลือดสูง': 'cholesterol',
  //                                       'โรคอ้วน': 'obesity',
  //                                       'บุหรี่ไฟฟ้า': 'e_cigarette',
  //                                     }[key]!;
  //                                     return Container(
  //                                       width: 156,
  //                                       height: 64,
  //                                       alignment: Alignment.center,
  //                                       color: isEven ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).secondaryBackground,
  //                                       child: Text(
  //                                         numberFormat.format(row[mapKey] ?? 0),
  //                                         style: FlutterFlowTheme.of(context).bodyLarge.override(
  //                                               fontFamily: 'IBM Plex Sans Thai Looped',
  //                                               color: FlutterFlowTheme.of(context).secondaryText,
  //                                               fontWeight: FontWeight.w600,
  //                                             ),
  //                                       ),
  //                                     );
  //                                   }).toList(),
  //                                 ),
  //                               );
  //                             }).toList(),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final hc = Get.find<NCDsgetX>();

    return Obx(() {
      final tableData = hc.getHealthRegionTableData();
      final headers = [
        'เบาหวาน',
        'ความดันโลหิตสูง',
        'ไตวายเรื้อรัง',
        'โรคหัวใจ',
        'หลอดเลือดสมอง',
        'COPD',
        'ไขมันในเลือดสูง',
        'โรคอ้วน',
        'บุหรี่ไฟฟ้า',
      ];

      return LayoutBuilder(builder: (context, constraints) {
        final maxTableHeight = (constraints.maxHeight > 900 ? 900.0 : constraints.maxHeight * 0.9);

        // คำนวณความกว้างที่เหลือหลังจากหักคอลัมน์ซ้าย
        final availableWidth = constraints.maxWidth - 158 - 1; // หัก fixed column และ separator
        final columnWidth = availableWidth / headers.length; // แบ่งเท่าๆ กัน

        return Container(
          width: double.infinity,
          height: maxTableHeight,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 234, 251, 255),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: FlutterFlowTheme.of(context).secondaryBackground),
          ),
          child: Row(
            children: [
              // — คอลัมน์ซ้าย (Fixed) —
              Column(
                children: [
                  // Header
                  Container(
                    width: 156,
                    height: 54,
                    alignment: Alignment.center,
                    child: Text(
                      'เขตสุขภาพ',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'IBM Plex Sans Thai Looped',
                            color: FlutterFlowTheme.of(context).primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  // รายชื่อเขตสุขภาพ
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _leftController,
                      child: Column(
                        children: List.generate(tableData.length, (i) {
                          final regionId = tableData[i]['region_id'] as int;
                          final isEven = regionId % 2 == 0;
                          return InkWell(
                            onTap: () => widget.onRowTap?.call(regionId),
                            child: Container(
                              width: 156,
                              height: 64,
                              color: isEven ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).secondaryBackground,
                              alignment: Alignment.center,
                              child: Text(
                                'เขตสุขภาพที่ $regionId',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'IBM Plex Sans Thai Looped',
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),

              // — ช่องว่างแบ่งคอลัมน์ —
              const SizedBox(width: 1),

              // — ข้อมูลขวา (ขยายเต็มพื้นที่) —
              Expanded(
                child: Column(
                  children: [
                    // Header row ของข้อมูล
                    Container(
                      height: 54,
                      child: Row(
                        children: headers.map((h) {
                          return Container(
                            width: columnWidth, // ใช้ความกว้างที่คำนวณแล้ว
                            height: 54,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              h,
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'IBM Plex Sans Thai Looped',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12, // ลดขนาดตัวอักษรเพื่อให้พอดี
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // Data rows
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _rightController,
                        child: Column(
                          children: tableData.map((row) {
                            final regionId = row['region_id'] as int;
                            final isEven = regionId % 2 == 0;
                            return InkWell(
                              onTap: () => widget.onRowTap?.call(regionId),
                              child: Row(
                                children: headers.map((key) {
                                  final mapKey = {
                                    'เบาหวาน': 'diabetes',
                                    'ความดันโลหิตสูง': 'hypertension',
                                    'ไตวายเรื้อรัง': 'kidney',
                                    'โรคหัวใจ': 'heart',
                                    'หลอดเลือดสมอง': 'stroke',
                                    'COPD': 'copd',
                                    'ไขมันในเลือดสูง': 'cholesterol',
                                    'โรคอ้วน': 'obesity',
                                    'บุหรี่ไฟฟ้า': 'e_cigarette',
                                  }[key]!;
                                  return Container(
                                    width: columnWidth, // ใช้ความกว้างที่คำนวณแล้ว
                                    height: 64,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isEven ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).secondaryBackground,
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      numberFormat.format(row[mapKey] ?? 0),
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                            fontFamily: 'IBM Plex Sans Thai Looped',
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13, // ลดขนาดตัวอักษรเล็กน้อย
                                          ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}

// Enhanced Download Button Widget with type detection
class EnhancedDownloadButton extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String defaultFileName;
  final String? dataType; // 'region' หรือ 'organization'

  const EnhancedDownloadButton({
    super.key,
    required this.data,
    this.defaultFileName = 'health_region_data',
    this.dataType = 'organization', // default เป็น organization
  });

  @override
  State<EnhancedDownloadButton> createState() => _EnhancedDownloadButtonState();
}

class _EnhancedDownloadButtonState extends State<EnhancedDownloadButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _showDownloadModal() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => XMLDownloadModal(
  //       data: widget.data,
  //       defaultFileName: widget.defaultFileName,
  //       dataType: widget.dataType ?? '', // ส่ง dataType ไปด้วย
  //       onDownload: (data, fileName, format) {
  //         print('Downloading file: $fileName in format: $format');
  //         print('Data length: ${data.length} characters');
  //       },
  //     ),
  //   );
  // }
  void _showDownloadModal() {
    final isOrg = widget.dataType == 'organization';

    // กำหนดค่าชุด fields+labels ตรงนี้
    final fieldLabels = isOrg
        ? {
            'organization_code': 'รหัสหน่วยบริการ',
            'organization_name': 'ชื่อหน่วยบริการ',
            'hypertension': 'ความดันโลหิตสูง',
            'diabetes': 'เบาหวาน',
            'kidney': 'ไตวายเรื้อรัง',
            'heart': 'โรคหัวใจ',
            'stroke': 'หลอดเลือดสมอง',
            'copd': 'COPD',
            'cholesterol': 'ไขมันในเลือดสูง',
            'obesity': 'โรคอ้วน',
            'e_cigarette': 'บุหรี่ไฟฟ้า',
          }
        : {
            'hypertension': 'ความดันโลหิตสูง',
            'diabetes': 'เบาหวาน',
            'kidney': 'ไตวายเรื้อรัง',
            'heart': 'โรคหัวใจ',
            'stroke': 'หลอดเลือดสมอง',
            'copd': 'COPD',
            'cholesterol': 'ไขมันในเลือดสูง',
            'obesity': 'โรคอ้วน',
            'e_cigarette': 'บุหรี่ไฟฟ้า',
          };

    final selectedFields = isOrg
        ? {
            'organization_code': true,
            'organization_name': true,
            'hypertension': true,
            'diabetes': true,
            'kidney': true,
            'heart': true,
            'stroke': true,
            'copd': true,
            'cholesterol': true,
            'obesity': true,
            'e_cigarette': true,
          }
        : {
            'hypertension': true,
            'diabetes': true,
            'kidney': true,
            'heart': true,
            'stroke': true,
            'copd': true,
            'cholesterol': true,
            'obesity': true,
            'e_cigarette': true,
          };

    // final selectedFields = Map.fromEntries(
    //   fieldLabels.keys.map((k) => MapEntry(k, true)),
    // );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => XMLDownloadModal(
        data: widget.data,
        defaultFileName: widget.defaultFileName,
        dataType: widget.dataType!,
        onDownload: (data, fileName, format) {
          // print('Downloading file: $fileName in format: $format');
          // print('Data length: ${data.length} characters');
        },
        // ส่ง config ที่เตรียมไว้เข้าไป
        initialSelectedFields: selectedFields,
        initialFieldLabels: fieldLabels,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: _showDownloadModal,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 52.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isHovered
                        ? [
                            Color(0xFF00A569),
                            Color(0xFF00855B)
                          ]
                        : [
                            Color(0xFF00855B),
                            Color(0xFF00A569)
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: _isHovered ? 8.0 : 5.0,
                      color: const Color(0xFF00855B).withOpacity(0.3),
                      offset: Offset(0.0, _isHovered ? 4.0 : 2.0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ดาวน์โหลด',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Thai Looped',
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      // const SizedBox(width: 8),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white.withOpacity(0.2),
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Text(
                      //     'ขั้นสูง',
                      //     style: TextStyle(
                      //       fontFamily: 'IBM Plex Sans Thai Looped',
                      //       color: Colors.white,
                      //       fontSize: 10,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// XML Download Modal Widget
class XMLDownloadModal extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String defaultFileName;
  final String dataType;
  final Function(String data, String fileName, String format)? onDownload;

  /// เพิ่มพารามิเตอร์ใหม่
  final Map<String, bool>? initialSelectedFields;
  final Map<String, String>? initialFieldLabels;

  const XMLDownloadModal({
    super.key,
    required this.data,
    required this.defaultFileName,
    this.onDownload,
    required this.dataType,
    this.initialSelectedFields,
    this.initialFieldLabels,
  });

  @override
  State<XMLDownloadModal> createState() => _XMLDownloadModalState();
}

class _XMLDownloadModalState extends State<XMLDownloadModal> with TickerProviderStateMixin {
  late TextEditingController _fileNameController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  DateTime? _startDate;
  DateTime? _endDate;
  String _dataPreview = '';
  bool _isGeneratingPreview = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _selectedFormat = 'excel';

  late Map<String, bool> _selectedFields;
  late Map<String, String> _fieldLabels;

  // Data selection options - ลบ organization fields ออก
  // Map<String, bool> _selectedFields = {
  //   'hypertension': true,
  //   'diabetes': true,
  //   'kidney': true,
  //   'heart': true,
  //   'stroke': true,
  //   'copd': true,
  //   'cholesterol': true,
  //   'obesity': true,
  //   'e_cigarette': true,
  // };

  // final Map<String, String> _fieldLabels = {
  //   'hypertension': 'ความดันโลหิตสูง',
  //   'diabetes': 'เบาหวาน',
  //   'kidney': 'ไตวายเรื้อรัง',
  //   'heart': 'โรคหัวใจ',
  //   'stroke': 'หลอดเลือดสมอง',
  //   'copd': 'COPD',
  //   'cholesterol': 'ไขมันในเลือดสูง',
  //   'obesity': 'โรคอ้วน',
  //   'e_cigarette': 'บุหรี่ไฟฟ้า',
  // };

  @override
  void initState() {
    super.initState();
    _fileNameController = TextEditingController(text: widget.defaultFileName);

    // ถ้ามีส่งมาให้ใช้ชุดนั้นก่อน ไม่งั้น fallback ไปเช็ค widget.dataType เอง
    if (widget.initialSelectedFields != null && widget.initialFieldLabels != null) {
      _selectedFields = widget.initialSelectedFields!;
      _fieldLabels = widget.initialFieldLabels!;
    } else if (widget.dataType == 'organization') {
      _selectedFields = {
        'organization_code': true,
        'organization_name': true,
        'hypertension': true,
        'diabetes': true,
        'kidney': true,
        'heart': true,
        'stroke': true,
        'copd': true,
        'cholesterol': true,
        'obesity': true,
        'e_cigarette': true,
      };
      _fieldLabels = {
        'organization_code': 'รหัสหน่วยบริการ',
        'organization_name': 'ชื่อหน่วยบริการ',
        'hypertension': 'ความดันโลหิตสูง',
        'diabetes': 'เบาหวาน',
        'kidney': 'ไตวายเรื้อรัง',
        'heart': 'โรคหัวใจ',
        'stroke': 'หลอดเลือดสมอง',
        'copd': 'COPD',
        'cholesterol': 'ไขมันในเลือดสูง',
        'obesity': 'โรคอ้วน',
        'e_cigarette': 'บุหรี่ไฟฟ้า',
      };
    } else {
      _selectedFields = {
        'hypertension': true,
        'diabetes': true,
        'kidney': true,
        'heart': true,
        'stroke': true,
        'copd': true,
        'cholesterol': true,
        'obesity': true,
        'e_cigarette': true,
      };
      _fieldLabels = {
        'hypertension': 'ความดันโลหิตสูง',
        'diabetes': 'เบาหวาน',
        'kidney': 'ไตวายเรื้อรัง',
        'heart': 'โรคหัวใจ',
        'stroke': 'หลอดเลือดสมอง',
        'copd': 'COPD',
        'cholesterol': 'ไขมันในเลือดสูง',
        'obesity': 'โรคอ้วน',
        'e_cigarette': 'บุหรี่ไฟฟ้า',
      };
    }

    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  String _generateXML() {
    final selectedData = widget.data.where((item) {
      if (_startDate != null && _endDate != null) {
        return true;
      }
      return true;
    }).toList();

    final StringBuffer xml = StringBuffer();
    xml.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    xml.writeln('<HealthRegionData>');
    xml.writeln('  <GeneratedAt>${DateTime.now().toIso8601String()}</GeneratedAt>');
    xml.writeln('  <TotalRecords>${selectedData.length}</TotalRecords>');

    if (_startDate != null) {
      xml.writeln('  <DateRange>');
      xml.writeln('    <StartDate>${_startDate!.toIso8601String()}</StartDate>');
      xml.writeln('    <EndDate>${_endDate!.toIso8601String()}</EndDate>');
      xml.writeln('  </DateRange>');
    }

    xml.writeln('  <Records>');

    for (int i = 0; i < selectedData.length; i++) {
      final record = selectedData[i];
      final regionId = record['region_id'] ?? (i + 1);
      xml.writeln('    <Record id="$regionId">');
      xml.writeln('      <region_id>$regionId</region_id>');
      xml.writeln('      <region_name>$regionId</region_name>');

      _selectedFields.forEach((key, isSelected) {
        if (isSelected && record.containsKey(key)) {
          final value = record[key];
          xml.writeln('      <$key>$value</$key>');
        }
      });

      xml.writeln('    </Record>');
    }

    xml.writeln('  </Records>');
    xml.writeln('</HealthRegionData>');

    return xml.toString();
  }

  String _generateExcel() {
    final selectedData = widget.data.where((item) {
      if (_startDate != null && _endDate != null) {
        return true;
      }
      return true;
    }).toList();

    final StringBuffer html = StringBuffer();

    html.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    html.writeln('<?mso-application progid="Excel.Sheet"?>');
    html.writeln('<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"');
    html.writeln(' xmlns:o="urn:schemas-microsoft-com:office:office"');
    html.writeln(' xmlns:x="urn:schemas-microsoft-com:office:excel"');
    html.writeln(' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"');
    html.writeln(' xmlns:html="http://www.w3.org/TR/REC-html40">');
    html.writeln('<Worksheet ss:Name="HealthRegionData">');
    html.writeln('<Table>');

    // Header row - เริ่มจากลำดับเขตสุขภาพ
    html.writeln('<Row>');
    if (widget.dataType == 'organization') {
      html.write('<Cell><Data ss:Type="String">ลำดับ</Data></Cell>');
    } else {
      html.write('<Cell><Data ss:Type="String">เขตสุขภาพ</Data></Cell>');
    }
    // html.write('<Cell><Data ss:Type="String">เขตสุขภาพ</Data></Cell>');
    _selectedFields.forEach((key, isSelected) {
      if (isSelected) {
        final label = _fieldLabels[key] ?? key;
        html.write('<Cell><Data ss:Type="String">$label</Data></Cell>');
      }
    });
    html.writeln('</Row>');

    // Data rows - แสดงข้อมูลเขตสุขภาพ
    for (int i = 0; i < selectedData.length; i++) {
      final record = selectedData[i];
      html.writeln('<Row>');
      // แสดงเขตสุขภาพที่ (region_id)
      final regionId = record['region_id'] ?? (i + 1);
      if (widget.dataType == 'organization') {
        html.write('<Cell><Data ss:Type="String">$regionId</Data></Cell>');
      } else {
        html.write('<Cell><Data ss:Type="String">เขตสุขภาพที่ $regionId</Data></Cell>');
      }
      // html.write('<Cell><Data ss:Type="String">เขตสุขภาพที่ $regionId</Data></Cell>');

      // _selectedFields.forEach((key, isSelected) {
      //   if (isSelected && record.containsKey(key)) {
      //     final value = record[key];
      //     html.write('<Cell><Data ss:Type="Number">$value</Data></Cell>');
      //   }
      // });
      _selectedFields.forEach((key, isSelected) {
        if (!isSelected || !record.containsKey(key)) return;
        final value = record[key];
        // ถ้าเป็นตัวเลขให้ Number, ถ้าไม่ใช่ให้ String
        final cellType = (value is num) ? 'Number' : 'String';
        html.write('<Cell><Data ss:Type="$cellType">$value</Data></Cell>');
      });
      html.writeln('</Row>');
    }

    html.writeln('</Table>');
    html.writeln('</Worksheet>');
    html.writeln('</Workbook>');

    return html.toString();
  }

  String _generateCSV() {
    final selectedData = widget.data.where((item) {
      if (_startDate != null && _endDate != null) {
        return true;
      }
      return true;
    }).toList();

    final StringBuffer csv = StringBuffer();

    // Header row - เริ่มจากเขตสุขภาพ
    List<String> headers = [];
    if (widget.dataType == 'organization') {
      headers.add('ลำดับ');
    } else {
      headers.add('เขตสุขภาพ');
    }
    // headers.add('เขตสุขภาพ');

    _selectedFields.forEach((key, isSelected) {
      if (isSelected) {
        headers.add(_fieldLabels[key] ?? key);
      }
    });
    csv.writeln(headers.join(','));

    // Data rows - แสดงข้อมูลเขตสุขภาพ
    for (int i = 0; i < selectedData.length; i++) {
      final record = selectedData[i];
      List<String> row = [];
      // แสดงเขตสุขภาพที่
      final regionId = record['region_id'] ?? (i + 1);
      if (widget.dataType == 'organization') {
        row.add(regionId.toString());
      } else {
        row.add('เขตสุขภาพที่ $regionId');
      }
      // row.add('เขตสุขภาพที่ $regionId');

      _selectedFields.forEach((key, isSelected) {
        if (isSelected && record.containsKey(key)) {
          final value = record[key];
          String csvValue = value.toString().replaceAll('"', '""');
          if (csvValue.contains(',') || csvValue.contains('"') || csvValue.contains('\n')) {
            csvValue = '"$csvValue"';
          }
          row.add(csvValue);
        }
      });
      csv.writeln(row.join(','));
    }

    return csv.toString();
  }

  String _generateExcelPreview() {
    final selectedData = widget.data.take(5).toList();
    final StringBuffer excel = StringBuffer();

    // Header row - เริ่มจากเขตสุขภาพ
    List<String> headers = [];
    headers.add('เขตสุขภาพ');
    _selectedFields.forEach((key, isSelected) {
      if (isSelected) {
        headers.add(_fieldLabels[key] ?? key);
      }
    });
    excel.writeln(headers.join('\t'));

    // Data rows - แสดงข้อมูลเขตสุขภาพ (แสดง 5 แถวแรก)
    for (int i = 0; i < selectedData.length; i++) {
      final record = selectedData[i];
      List<String> row = [];
      // แสดงเขตสุขภาพที่
      final regionId = record['region_id'] ?? (i + 1);
      row.add('เขตสุขภาพที่ $regionId');

      _selectedFields.forEach((key, isSelected) {
        if (isSelected && record.containsKey(key)) {
          final value = record[key];
          row.add(value.toString());
        }
      });
      excel.writeln(row.join('\t'));
    }

    if (widget.data.length > 5) {
      excel.writeln('... และอีก ${widget.data.length - 5} แถว');
    }

    return excel.toString();
  }

  Future<void> _generatePreview() async {
    setState(() {
      _isGeneratingPreview = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    String preview;
    if (_selectedFormat == 'xml') {
      final fullXml = _generateXML();
      final lines = fullXml.split('\n');
      final previewLines = lines.take(20).join('\n');
      preview = previewLines + (lines.length > 20 ? '\n  ...' : '');
    } else if (_selectedFormat == 'csv') {
      final fullCsv = _generateCSV();
      final lines = fullCsv.split('\n');
      final previewLines = lines.take(10).join('\n');
      preview = previewLines + (lines.length > 10 ? '\n... และอีก ${lines.length - 10} แถว' : '');
    } else {
      preview = _generateExcelPreview();
    }

    setState(() {
      _dataPreview = preview;
      _isGeneratingPreview = false;
    });
  }

  Future<void> _downloadFile() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    _progressController.reset();
    _progressController.forward();

    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _downloadProgress = i / 100;
      });
    }

    String fileData;
    String fileExtension;

    switch (_selectedFormat) {
      case 'xml':
        fileData = _generateXML();
        fileExtension = 'xml';
        break;
      case 'csv':
        fileData = _generateCSV();
        fileExtension = 'csv';
        break;
      default:
        fileData = _generateExcel();
        fileExtension = 'xls';
        break;
    }

    final fileName = _fileNameController.text.trim();
    final finalFileName = fileName.contains('.') ? fileName : '$fileName.$fileExtension';

    await _saveFileWithPicker(fileData, finalFileName);

    setState(() {
      _isDownloading = false;
    });

    _showSuccessToast();

    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveFileWithPicker(String content, String fileName) async {
    try {
      if (kIsWeb) {
        await _downloadFileWeb(content, fileName);
      } else {
        await _saveFileMobile(content, fileName);
      }
    } catch (e) {
      print('Error saving file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการบันทึกไฟล์: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _downloadFileWeb(String content, String fileName) async {
    final bytes = utf8.encode(content);
    final blob = html.Blob([
      bytes
    ]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;

    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _saveFileMobile(String content, String fileName) async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw 'Storage permission denied';
        }
      }

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'บันทึกไฟล์',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: [
          _selectedFormat
        ],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(content);
        print('File saved to: $outputFile');
      } else {
        throw 'User cancelled file save';
      }
    } catch (e) {
      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(content);
        print('File saved to app directory: ${file.path}');
      }
    }
  }

  void _showSuccessToast() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'ดาวน์โหลด ${_selectedFormat.toUpperCase()} สำเร็จ!',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Thai Looped',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF00855B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00855B),
                    const Color(0xFF00A569),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ดาวน์โหลดไฟล์ข้อมูล',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Thai Looped',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'เลือกรูปแบบและกำหนดค่าการส่งออกข้อมูล',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Thai Looped',
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // File Name Section
                    _buildSection(
                      title: 'ชื่อไฟล์',
                      icon: Icons.edit_outlined,
                      child: TextFormField(
                        controller: _fileNameController,
                        decoration: InputDecoration(
                          hintText: 'ระบุชื่อไฟล์',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: const Color(0xFF00855B)),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Thai Looped',
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // File Format Section
                    _buildSection(
                      title: 'รูปแบบไฟล์',
                      icon: Icons.description_outlined,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedFormat,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: InputBorder.none,
                            hintText: 'เลือกรูปแบบไฟล์',
                          ),
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Thai Looped',
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                          items: [
                            DropdownMenuItem(
                              value: 'excel',
                              child: Row(
                                children: [
                                  Icon(Icons.table_view, size: 20, color: Colors.green[700]),
                                  SizedBox(width: 12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Excel (.xls)',
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        ' - เหมาะสำหรับการวิเคราะห์ข้อมูล',
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'xml',
                              child: Row(
                                children: [
                                  Icon(Icons.code, size: 20, color: Colors.blue[700]),
                                  SizedBox(width: 12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'XML (.xml)',
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        ' - เหมาะสำหรับการแลกเปลี่ยนข้อมูล',
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'csv',
                              child: Row(
                                children: [
                                  Icon(Icons.text_snippet, size: 20, color: Colors.orange[700]),
                                  SizedBox(width: 12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'CSV (.csv)',
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        ' - เหมาะสำหรับการนำเข้าข้อมูล',
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedFormat = value!;
                              _dataPreview = '';
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Date Range Section
                    _buildSection(
                      title: 'ช่วงวันที่ (ไม่บังคับ)',
                      icon: Icons.date_range_outlined,
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker(
                              label: 'วันที่เริ่มต้น',
                              date: _startDate,
                              onDateSelected: (date) {
                                setState(() {
                                  _startDate = date;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDatePicker(
                              label: 'วันที่สิ้นสุด',
                              date: _endDate,
                              onDateSelected: (date) {
                                setState(() {
                                  _endDate = date;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Field Selection Section
                    _buildSection(
                      title: 'เลือกข้อมูลที่ต้องการส่งออก',
                      icon: Icons.checklist_outlined,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedFields.updateAll((key, value) => true);
                                  });
                                },
                                child: Text('เลือกทั้งหมด'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedFields.updateAll((key, value) => false);
                                  });
                                },
                                child: Text('ยกเลิกทั้งหมด'),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedFields.entries.map((entry) {
                              return FilterChip(
                                label: Text(
                                  _fieldLabels[entry.key] ?? entry.key,
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans Thai Looped',
                                    fontSize: 12,
                                  ),
                                ),
                                selected: entry.value,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFields[entry.key] = selected;
                                  });
                                },
                                selectedColor: const Color(0xFF00855B).withOpacity(0.2),
                                checkmarkColor: const Color(0xFF00855B),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Preview Section
                    _buildSection(
                      title: 'ตัวอย่างข้อมูล${_selectedFormat == 'xml' ? ' XML' : _selectedFormat == 'csv' ? ' CSV' : ' Excel'}',
                      icon: _selectedFormat == 'xml'
                          ? Icons.code
                          : _selectedFormat == 'csv'
                              ? Icons.text_snippet
                              : Icons.table_view_outlined,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isGeneratingPreview ? null : _generatePreview,
                              icon: _isGeneratingPreview
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Icon(Icons.refresh),
                              label: Text(_isGeneratingPreview ? 'กำลังสร้าง...' : 'สร้างตัวอย่าง'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00855B),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          if (_dataPreview.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              height: 200,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _selectedFormat == 'xml'
                                    ? Colors.blue[50]
                                    : _selectedFormat == 'csv'
                                        ? Colors.orange[50]
                                        : Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: _selectedFormat == 'xml'
                                        ? Colors.blue[200]!
                                        : _selectedFormat == 'csv'
                                            ? Colors.orange[200]!
                                            : const Color(0xFF00855B).withOpacity(0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                          _selectedFormat == 'xml'
                                              ? Icons.code
                                              : _selectedFormat == 'csv'
                                                  ? Icons.text_snippet
                                                  : Icons.table_chart,
                                          size: 16,
                                          color: _selectedFormat == 'xml'
                                              ? Colors.blue[700]
                                              : _selectedFormat == 'csv'
                                                  ? Colors.orange[700]
                                                  : const Color(0xFF00855B)),
                                      SizedBox(width: 8),
                                      Text(
                                        'ตัวอย่างข้อมูล ${_selectedFormat.toUpperCase()}${_selectedFormat != 'xml' ? ' (แสดง 5 แถวแรก)' : ''}',
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _selectedFormat == 'xml'
                                              ? Colors.blue[700]
                                              : _selectedFormat == 'csv'
                                                  ? Colors.orange[700]
                                                  : const Color(0xFF00855B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        _dataPreview,
                                        style: TextStyle(
                                          fontFamily: 'Courier New',
                                          fontSize: 11,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'ไฟล์จริงจะมีข้อมูลครบทั้งหมด ${widget.data.length} รายการ ในรูปแบบ ${_selectedFormat.toUpperCase()}',
                                      style: TextStyle(
                                        fontFamily: 'IBM Plex Sans Thai Looped',
                                        fontSize: 12,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Progress Bar (show when downloading)
            if (_isDownloading)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'กำลังดาวน์โหลด...',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Thai Looped',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${(_downloadProgress * 100).toInt()}%',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Thai Looped',
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00855B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _downloadProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFF00855B),
                          ),
                          minHeight: 6,
                        );
                      },
                    ),
                  ],
                ),
              ),

            // Footer Buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isDownloading ? null : () => Navigator.of(context).pop(),
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Thai Looped',
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isDownloading ? null : _downloadFile,
                      icon: _isDownloading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(Icons.download_rounded),
                      label: Text(
                        _isDownloading ? 'กำลังดาวน์โหลด...' : 'ดาวน์โหลด ${_selectedFormat.toUpperCase()}',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Thai Looped',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00855B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF00855B),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Thai Looped',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required Function(DateTime?) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: const Color(0xFF00855B),
                ),
              ),
              child: child!,
            );
          },
        );
        onDateSelected(selectedDate);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Thai Looped',
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    date != null ? '${date.day}/${date.month}/${date.year}' : 'เลือกวันที่',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Thai Looped',
                      fontSize: 14,
                      color: date != null ? Colors.grey[800] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HealthRegionWidget (ส่วนหลัก) - แทนที่ปุ่มเดิมด้วย EnhancedDownloadButton
class HealthRegionWidget extends StatefulWidget {
  const HealthRegionWidget({super.key, this.selectedFiscalYear});
  final int? selectedFiscalYear;

  @override
  State<HealthRegionWidget> createState() => _HealthRegionWidgetState();
}

class _HealthRegionWidgetState extends State<HealthRegionWidget> with TickerProviderStateMixin {
  late HealthRegionModel _model;
  int selectedRegion = 1;
  late NCDsgetX _ctrl;
  final numberFormat = NumberFormat('#,###');

  int currentPage = 1;
  static const int rowsPerPage = 10;
  final animationsMap = <String, AnimationInfo>{};

  List<String> availableProvinces = [
    'ทั้งหมด'
  ];
  List<String> availableHospitalTypes = [
    'ทั้งหมด'
  ];
  var filteredTableData = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> originalTableData = [];

// เพิ่ม Map สำหรับเขตสุขภาพใน class _HealthRegionWidgetState
  final Map<String, String> provinceToRegionMap = {
    '50': '1',
    '51': '1',
    '52': '1',
    '54': '1',
    '55': '1',
    '56': '1',
    '57': '1',
    '58': '1',
    '63': '2',
    '64': '2',
    '65': '2',
    '67': '2',
    '53': '2',
    '60': '3',
    '61': '3',
    '62': '3',
    '66': '3',
    '18': '3',
    '12': '4',
    '13': '4',
    '14': '4',
    '15': '4',
    '16': '4',
    '17': '4',
    '19': '4',
    '26': '4',
    '70': '5',
    '71': '5',
    '72': '5',
    '73': '5',
    '74': '5',
    '75': '5',
    '76': '5',
    '77': '5',
    '11': '6',
    '20': '6',
    '21': '6',
    '22': '6',
    '23': '6',
    '24': '6',
    '25': '6',
    '27': '6',
    '40': '7',
    '44': '7',
    '45': '7',
    '46': '7',
    '38': '8',
    '39': '8',
    '41': '8',
    '42': '8',
    '43': '8',
    '47': '8',
    '48': '8',
    '30': '9',
    '31': '9',
    '32': '9',
    '36': '9',
    '33': '10',
    '34': '10',
    '35': '10',
    '37': '10',
    '49': '10',
    '80': '11',
    '81': '11',
    '82': '11',
    '83': '11',
    '84': '11',
    '85': '11',
    '86': '11',
    '90': '12',
    '91': '12',
    '92': '12',
    '93': '12',
    '94': '12',
    '95': '12',
    '96': '12',
    '10': '13',
  };

  final Map<String, String> provinceCodeToName = {
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
    '58': 'แม่ฮ่องสอน',
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

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  void _updateHospitalTypesByProvince(String? selectedProvince) {
    Future.delayed(Duration(milliseconds: 500), () {
      final currentData = _ctrl.getOrganizationTableData();
      final hospitalData = _ctrl.hospitalList;

      if (selectedProvince == null || selectedProvince == 'ทั้งหมด') {
        final hospitalNameSet = <String>{};
        for (var item in currentData) {
          final orgName = item['organization_name'].toString();
          if (orgName.isNotEmpty && orgName != 'null') {
            hospitalNameSet.add(orgName);
          }
        }

        if (mounted) {
          setState(() {
            availableHospitalTypes = [
              'ทั้งหมด',
              ...hospitalNameSet.toList()..sort()
            ];
            _model.dropDownValue2 = 'ทั้งหมด';
            _model.dropDownValueController2?.reset();
          });
        }
      } else {
        final selectedProvinceCode = provinceCodeToName.entries.firstWhere((entry) => entry.value == selectedProvince, orElse: () => const MapEntry('', '')).key;

        if (selectedProvinceCode.isNotEmpty) {
          final hospitalNameSet = <String>{};
          for (var item in currentData) {
            final orgCode = item['organization_code']?.toString() ?? '';
            final orgName = item['organization_name']?.toString() ?? '';

            final hospitalInfo = hospitalData.firstWhere(
              (hospital) => hospital['hospital_code'].toString() == orgCode,
              orElse: () => <String, dynamic>{},
            );

            if (hospitalInfo.isNotEmpty) {
              final hospitalProvinceCode = hospitalInfo['province_code'].toString();
              if (hospitalProvinceCode == selectedProvinceCode) {
                if (orgName.isNotEmpty && orgName != 'null') {
                  hospitalNameSet.add(orgName);
                }
              }
            }
          }

          if (mounted) {
            setState(() {
              availableHospitalTypes = [
                'ทั้งหมด',
                ...hospitalNameSet.toList()..sort()
              ];
              _model.dropDownValue2 = 'ทั้งหมด';
              _model.dropDownValueController2?.reset();
            });
          }
        }
      }
    });
  }

  void _filterData() {
    final allData = _ctrl.getOrganizationTableData();
    final hospitalData = _ctrl.hospitalList;
    List<Map<String, dynamic>> filtered = List.from(allData);

    if (_model.dropDownValue1 != null && _model.dropDownValue1 != 'ทั้งหมด') {
      final selectedProvince = _model.dropDownValue1!;
      final selectedProvinceCode = provinceCodeToName.entries.firstWhere((entry) => entry.value == selectedProvince, orElse: () => const MapEntry('', '')).key;

      if (selectedProvinceCode.isNotEmpty) {
        filtered = filtered.where((item) {
          final orgCode = item['organization_code'].toString();
          final hospitalInfo = hospitalData.firstWhere(
            (hospital) => hospital['hospital_code'].toString() == orgCode,
            orElse: () => <String, dynamic>{},
          );

          if (hospitalInfo.isNotEmpty) {
            final hospitalProvinceCode = hospitalInfo['province_code'].toString();
            return hospitalProvinceCode == selectedProvinceCode;
          }
          return false;
        }).toList();
      }
    }

    if (_model.dropDownValue2 != null && _model.dropDownValue2 != 'ทั้งหมด') {
      final selectedHospitalName = _model.dropDownValue2!;
      filtered = filtered.where((item) {
        final orgName = item['organization_name'].toString();
        return orgName == selectedHospitalName;
      }).toList();
    }

    setState(() {
      filteredTableData.assignAll(filtered);
      currentPage = 1;
    });
  }

  void _updateDataAndFilters() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          originalTableData = List.from(_ctrl.getOrganizationTableData());
        });
        _updateHospitalTypesByProvince(_model.dropDownValue1);
        Future.delayed(Duration(milliseconds: 200), () {
          _filterData();
        });
      }
    });
  }

  Widget buildOrganizationPagination() {
    final dataToShow = filteredTableData.isNotEmpty ? filteredTableData : _ctrl.getOrganizationTableData();
    final totalItems = dataToShow.length;
    final totalPages = (totalItems / rowsPerPage).ceil();

    if (totalPages <= 1) return const SizedBox.shrink();

    int maxButtons = 5;
    int startPage = (currentPage - 2).clamp(1, (totalPages - maxButtons + 1).clamp(1, totalPages));
    int endPage = (startPage + maxButtons - 1).clamp(1, totalPages);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: currentPage > 1 ? () => setState(() => currentPage = 1) : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null,
          ),
          for (int i = startPage; i <= endPage; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ElevatedButton(
                onPressed: () => setState(() => currentPage = i),
                style: ElevatedButton.styleFrom(
                  backgroundColor: i == currentPage ? const Color(0xFF00855B) : Colors.white,
                  foregroundColor: i == currentPage ? Colors.white : Colors.black,
                  minimumSize: const Size(36, 36),
                  padding: EdgeInsets.zero,
                ),
                child: Text('$i'),
              ),
            ),
          if (endPage < totalPages)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('...'),
            ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages ? () => setState(() => currentPage++) : null,
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: currentPage < totalPages ? () => setState(() => currentPage = totalPages) : null,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> getPaginatedData(List<Map<String, dynamic>> allData) {
    final startIndex = (currentPage - 1) * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, allData.length);
    return allData.sublist(startIndex, endIndex);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HealthRegionModel());
    _ctrl = Get.find<NCDsgetX>();
    _initializeData();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 800.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 800.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, -15.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  // Future<void> _initializeData() async {
  //   if (_ctrl.hospitalList.isEmpty) {
  //     await _ctrl.fetchAllHospitals();
  //   }

  //   _ctrl.getProvinceQueryParams().then((codeList) {
  //     final names = codeList.map((code) => provinceCodeToName[code]).whereType<String>().toSet().toList()..sort();

  //     if (mounted) {
  //       setState(() {
  //         availableProvinces = [
  //           'ทั้งหมด',
  //           ...provinceCodeToName.values.toList()..sort()
  //         ];
  //         _model.dropDownValue1 = 'ทั้งหมด';
  //         _model.dropDownValue2 = 'ทั้งหมด';
  //         _model.dropDownValueController1?.reset();
  //         _model.dropDownValueController2?.reset();
  //       });
  //     }
  //   });

  //   _ctrl
  //       .fetchGroupByOrganizationAndCd(
  //     fiscalYear: widget.selectedFiscalYear ?? 0,
  //     regionid: selectedRegion,
  //   )
  //       .then((_) {
  //     if (mounted) {
  //       _updateHospitalTypesByProvince('ทั้งหมด');
  //     }
  //   });
  // }
  Future<void> _initializeData() async {
    if (_ctrl.hospitalList.isEmpty) {
      await _ctrl.fetchAllHospitals();
    }

    // กรองจังหวัดตามเขตสุขภาพที่เลือก
    _updateAvailableProvinces();

    _ctrl
        .fetchGroupByOrganizationAndCd(
      fiscalYear: widget.selectedFiscalYear ?? 0,
      regionid: selectedRegion,
    )
        .then((_) {
      if (mounted) {
        _updateHospitalTypesByProvince('ทั้งหมด');
      }
    });
  }

// เพิ่ม method ใหม่สำหรับอัพเดตจังหวัดตามเขตสุขภาพ
  void _updateAvailableProvinces() {
    // หาจังหวัดที่อยู่ในเขตสุขภาพที่เลือก
    final provincesInRegion = provinceToRegionMap.entries.where((entry) => entry.value == selectedRegion.toString()).map((entry) => entry.key).toList();

    // แปลงรหัสจังหวัดเป็นชื่อจังหวัด
    final provinceNames = provincesInRegion.map((code) => provinceCodeToName[code]).whereType<String>().toList()..sort();

    if (mounted) {
      setState(() {
        availableProvinces = [
          'ทั้งหมด',
          ...provinceNames
        ];
        _model.dropDownValue1 = 'ทั้งหมด';
        _model.dropDownValue2 = 'ทั้งหมด';
        _model.dropDownValueController1?.reset();
        _model.dropDownValueController2?.reset();
      });
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showRemark = constraints.maxWidth > 600;
        return AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          width: constraints.maxWidth,
          constraints: BoxConstraints(
            minHeight: 200.0,
            maxHeight: constraints.maxHeight,
          ),
          decoration: BoxDecoration(
            // color: Color.fromARGB(205, 236, 10, 10),
            color: Color(0xCDFFFFFF),
            boxShadow: [
              BoxShadow(
                blurRadius: 24.0,
                color: Color(0x1E666666),
                offset: Offset(0.0, 2.0),
              )
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
              bottomRight: Radius.circular(32.0),
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            border: Border.all(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    if (_model.isViewRegion == false) {
                      // แสดงตารางเขตสุขภาพ
                      return Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header row
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                        FontAwesomeIcons.clipboardList,
                                        color: FlutterFlowTheme.of(context).primary,
                                        size: 14.0,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        'รายงานสรุปข้อมูลโรคไม่ติดต่อเรื้อรัง แยกตามเขตสุขภาพ',
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: 'IBM Plex Sans Thai Looped',
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ]
                                      .expand((widget) => [
                                            widget,
                                            SizedBox(width: 8.0)
                                          ])
                                      .take(3)
                                      .toList(),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      EnhancedDownloadButton(
                                        data: _ctrl.getHealthRegionTableData(),
                                        defaultFileName: 'health_regions_summary',
                                        dataType: 'region', // ระบุว่าเป็นข้อมูลเขต
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.0),
                            // Table section
                            Flexible(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: SampleTableWidget(
                                    // onRowTap: (int regionIndex) async {
                                    //   setState(() {
                                    //     selectedRegion = regionIndex;
                                    //     currentPage = 1;
                                    //     _ctrl.queryprovince = [];
                                    //   });

                                    //   _model.dropDownValue1 = 'ทั้งหมด';
                                    //   _model.dropDownValueController1?.reset();
                                    //   _model.dropDownValue2 = 'ทั้งหมด';
                                    //   _model.dropDownValueController2?.reset();
                                    //   filteredTableData.clear();

                                    //   await _ctrl.fetchGroupByOrganizationAndCd(
                                    //     fiscalYear: widget.selectedFiscalYear ?? 0,
                                    //     regionid: selectedRegion,
                                    //   );
                                    //   setState(() {
                                    //     _model.isViewRegion = true;
                                    //   });
                                    // },
                                    // selectedRegion: selectedRegion,
                                    onRowTap: (int regionIndex) async {
                                  setState(() {
                                    selectedRegion = regionIndex;
                                    currentPage = 1;
                                    _ctrl.queryprovince = [];
                                  });

                                  // อัพเดตรายการจังหวัดตามเขตสุขภาพใหม่
                                  _updateAvailableProvinces();

                                  filteredTableData.clear();

                                  await _ctrl.fetchGroupByOrganizationAndCd(
                                    fiscalYear: widget.selectedFiscalYear ?? 0,
                                    regionid: selectedRegion,
                                  );

                                  setState(() {
                                    _model.isViewRegion = true;
                                  });

                                  // อัพเดตรายการโรงพยาบาลหลังจากเปลี่ยนเขต
                                  _updateHospitalTypesByProvince('ทั้งหมด');
                                }),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Detail view with pagination
                      return Flexible(
                        child: LayoutBuilder(builder: (context, bc) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Breadcrumb and filters row
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      // Breadcrumb navigation
                                      Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xCDFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 24.0,
                                                color: Color(0x1E666666),
                                                offset: Offset(0.0, 2.0),
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
                                                    _model.isViewRegion = false;
                                                    currentPage = 1;
                                                    safeSetState(() {});
                                                  },
                                                  text: 'เขตสุขภาพทั้งหมด',
                                                  icon: Icon(Icons.table_chart, size: 16.0),
                                                  options: FFButtonOptions(
                                                    height: 36.0,
                                                    padding: EdgeInsets.all(8.0),
                                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                    iconColor: FlutterFlowTheme.of(context).primaryText,
                                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'IBM Plex Sans Thai Looped',
                                                          letterSpacing: 0.0,
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
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.list_alt_rounded,
                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          size: 20.0,
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Text(
                                                          'เขตสุขภาพที่ $selectedRegion',
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                fontFamily: 'IBM Plex Sans Thai Looped',
                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                letterSpacing: 0.0,
                                                                fontWeight: FontWeight.bold,
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
                                      ),
                                      SizedBox(width: 12.0),
                                      // Filters section
                                      Expanded(
                                        flex: 3,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Province filter
                                              Container(
                                                constraints: BoxConstraints(minWidth: 200.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xCDFFFFFF),
                                                  borderRadius: BorderRadius.circular(16.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(6.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: 24.0,
                                                            height: 24.0,
                                                            decoration: BoxDecoration(
                                                              color: Color(0xFF00855B),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.travel_explore_rounded,
                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                              size: 14.0,
                                                            ),
                                                          ),
                                                          SizedBox(width: 8.0),
                                                          Text(
                                                            'เลือกจังหวัด',
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  fontFamily: 'IBM Plex Sans Thai Looped',
                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 6.0),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          borderRadius: BorderRadius.circular(14.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).alternate,
                                                          ),
                                                        ),
                                                        child: FlutterFlowDropDown<String>(
                                                          controller: _model.dropDownValueController1 ??= FormFieldController<String>(
                                                            _model.dropDownValue1 ??= 'ทั้งหมด',
                                                          ),
                                                          options: availableProvinces,
                                                          onChanged: (val) async {
                                                            setState(() {
                                                              _model.dropDownValue1 = val;
                                                              _model.dropDownValue2 = 'ทั้งหมด';
                                                              _model.dropDownValueController2?.reset();
                                                              currentPage = 1;
                                                            });
                            
                                                            final provinceCode = provinceCodeToName.entries.firstWhere((e) => e.value == val, orElse: () => const MapEntry('', '')).key;
                            
                                                            if (provinceCode.isNotEmpty) {
                                                              _ctrl.queryprovince = [
                                                                provinceCode
                                                              ];
                                                            } else {
                                                              _ctrl.queryprovince = [];
                                                            }
                            
                                                            await _ctrl.fetchGroupByOrganizationAndCd(
                                                              fiscalYear: widget.selectedFiscalYear ?? 0,
                                                              regionid: selectedRegion,
                                                              orgProvinceCode: _ctrl.queryprovince.isNotEmpty ? _ctrl.queryprovince[0] : null,
                                                            );
                            
                                                            _updateDataAndFilters();
                                                          },
                                                          width: 300.0,
                                                          height: 36.0,
                                                          textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                fontFamily: 'IBM Plex Sans Thai Looped',
                                                                letterSpacing: 0.0,
                                                              ),
                                                          hintText: 'ทั้งหมด',
                                                          icon: Icon(
                                                            Icons.arrow_drop_down_rounded,
                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                            size: 24.0,
                                                          ),
                                                          elevation: 2.0,
                                                          borderColor: Colors.transparent,
                                                          borderWidth: 0.0,
                                                          borderRadius: 6.0,
                                                          margin: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                          hidesUnderline: true,
                                                          isSearchable: true,
                                                          isMultiSelect: false,
                                                          dropdownHeight: 300,
                                                          maxHeight: 300,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.0),
                                              // Type filter
                                              Container(
                                                constraints: BoxConstraints(minWidth: 200.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xCDFFFFFF),
                                                  borderRadius: BorderRadius.circular(16.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(6.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: 24.0,
                                                            height: 24.0,
                                                            decoration: BoxDecoration(
                                                              color: Color(0xFFCF507C),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.medical_services,
                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                              size: 14.0,
                                                            ),
                                                          ),
                                                          SizedBox(width: 8.0),
                                                          Text(
                                                            'ประเภท',
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  fontFamily: 'IBM Plex Sans Thai Looped',
                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 6.0),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          borderRadius: BorderRadius.circular(14.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme.of(context).alternate,
                                                          ),
                                                        ),
                                                        child: FlutterFlowDropDown<String>(
                                                          controller: _model.dropDownValueController2 ??= FormFieldController<String>(
                                                            _model.dropDownValue2 ??= 'ทั้งหมด',
                                                          ),
                                                          options: availableHospitalTypes,
                                                          onChanged: (val) async {
                                                            setState(() {
                                                              _model.dropDownValue2 = val;
                                                              currentPage = 1;
                                                            });
                                                            _filterData();
                                                          },
                                                          width: 300.0,
                                                          height: 36.0,
                                                          textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                fontFamily: 'IBM Plex Sans Thai Looped',
                                                                letterSpacing: 0.0,
                                                              ),
                                                          hintText: 'ทั้งหมด',
                                                          icon: Icon(
                                                            Icons.arrow_drop_down_rounded,
                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                            size: 24.0,
                                                          ),
                                                          elevation: 2.0,
                                                          borderColor: Colors.transparent,
                                                          borderWidth: 0.0,
                                                          borderRadius: 6.0,
                                                          margin: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                          hidesUnderline: true,
                                                          isSearchable: true,
                                                          isMultiSelect: false,
                                                          dropdownHeight: 300,
                                                          maxHeight: 300,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.0),
                                              // Download button
                                              EnhancedDownloadButton(
                                                data: filteredTableData.isNotEmpty ? filteredTableData : _ctrl.getOrganizationTableData(),
                                                defaultFileName: 'health_region_${selectedRegion}_organizations',
                                                dataType: 'organization', // ระบุว่าเป็นข้อมูลหน่วยบริการ
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            
                                SizedBox(height: 8.0),
                            
                                // Detail table with pagination
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Obx(() {
                                          final dataToShow = filteredTableData.isNotEmpty ? filteredTableData : _ctrl.getOrganizationTableData();
                                          final paginatedData = getPaginatedData(dataToShow);
                            
                                          return Row(
                                            children: [
                                              // Fixed left columns
                                              IntrinsicWidth(
                                                child: Column(
                                                  children: [
                                                    // Header
                                                    _buildFixedRow([
                                                      'ลำดับ',
                                                      'รหัส',
                                                      'หน่วยบริการ'
                                                    ], isHeader: true, background: const Color(0xFFEAF7FF)),
                                                    // Data rows
                                                    for (var i = 0; i < paginatedData.length; i++)
                                                      _buildFixedRow([
                                                        '${(currentPage - 1) * rowsPerPage + i + 1}',
                                                        paginatedData[i]['organization_code'].toString(),
                                                        paginatedData[i]['organization_name'].toString(),
                                                      ], background: i.isEven ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).secondaryBackground),
                                                  ],
                                                ),
                                              ),
                                              // Scrollable disease columns
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: IntrinsicWidth(
                                                    child: Column(
                                                      children: [
                                                        _buildScrollableRow([
                                                          'จังหวัด',
                                                          'ความดันโลหิตสูง',
                                                          'เบาหวาน',
                                                          'ไตวายเรื้อรัง',
                                                          'โรคหัวใจ',
                                                          'หลอดเลือดสมอง',
                                                          'COPD',
                                                          'ไขมันในเลือดสูง',
                                                          'โรคอ้วน',
                                                          'บุหรี่ไฟฟ้า',
                                                          'วันที่ส่ง',
                                                          'สถานะ',
                                                        ], isHeader: true, background: const Color(0xFFEAF7FF)),
                                                        for (int i = 0; i < paginatedData.length; i++)
                                                          _buildScrollableRow(
                                                            [
                                                              paginatedData[i]['province_name'], //จังหวัด
                                                              numberFormat.format(paginatedData[i]['hypertension'] ?? 0),
                                                              numberFormat.format(paginatedData[i]['diabetes'] ?? 0),
                                                              numberFormat.format(paginatedData[i]['kidney'] ?? 0),
                                                              numberFormat.format(paginatedData[i]['heart'] ?? 0),
                                                              numberFormat.format(paginatedData[i]['stroke'] ?? 0),
                                                              numberFormat.format(paginatedData[i]['copd'] ?? 0),
                                                              numberFormat.format(paginatedData[i]['cholesterol'] ?? 0),
                                                              numberFormat.format(paginatedData[i]['obesity'] ?? 0),
                                                              numberFormat.format(paginatedData[i]['e_cigarette'] ?? 0),
                                                              formatThaiDate(paginatedData[i]['register_datetime']), // วันที่ส่ง
                                                              paginatedData[i]['status'], // สถานะ
                                                            ],
                                                            background: i.isEven ? FlutterFlowTheme.of(context).primaryBackground : FlutterFlowTheme.of(context).secondaryBackground,
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                      // Pagination
                                      buildOrganizationPagination(),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      );
                   
                    }
                  },
                ),
              ],
            ),
          ),
        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
      },
    );
  }

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

  Widget _buildHeaderCell(String text, double width, {Alignment alignment = Alignment.center}) {
    return Container(
      width: width,
      height: 54,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Text(
        text,
        textAlign: alignment == Alignment.centerLeft ? TextAlign.left : TextAlign.center,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'IBM Plex Sans Thai Looped',
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              color: FlutterFlowTheme.of(context).primary,
              fontSize: width < 100 ? 11 : 12, // ปรับขนาดตัวอักษรตามความกว้าง
            ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDataCell(
    String text,
    double width, {
    Alignment alignment = Alignment.center,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Container(
      width: width,
      height: 54,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Text(
        text,
        textAlign: textAlign,
        style: FlutterFlowTheme.of(context).bodyLarge.override(
              fontFamily: 'IBM Plex Sans Thai Looped',
              fontWeight: FontWeight.normal,
              letterSpacing: 0,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: width < 100 ? 11 : 12, // ปรับขนาดตัวอักษรตามความกว้าง
            ),
        maxLines: width > 200 ? 2 : 1, // ชื่อหน่วยบริการให้แสดง 2 บรรทัดได้
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Widget _buildFixedRow(List<String> cells, {bool isHeader = false, Color? background}) {
  //   final style = isHeader ? _fixedHeaderTextStyle : _fixedDataTextStyle;
  //   return Container(
  //     color: background,
  //     height: 54,
  //     child: Row(
  //       children: cells.asMap().entries.map((entry) {
  //         final i = entry.key;
  //         final text = entry.value;
  //         final alignment = (i == cells.length - 1) ? Alignment.centerLeft : Alignment.center;
  //         final textAlign = (i == cells.length - 1) ? TextAlign.left : TextAlign.center;
  //         return Container(
  //           width: text == cells.last ? 500 : 64,
  //           alignment: alignment,
  //           padding: EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             border: Border(
  //               left: BorderSide(
  //                 color: Colors.grey.withOpacity(0.2),
  //                 width: 1,
  //               ),
  //               right: BorderSide(
  //                 color: Colors.grey.withOpacity(0.2),
  //                 width: 1,
  //               ),
  //             ),
  //           ),
  //           child: Text(text, textAlign: textAlign, style: style),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget _buildFixedRow(
    List<String> cells, {
    bool isHeader = false,
    Color? background,
  }) {
    final style = isHeader ? _fixedHeaderTextStyle : _fixedDataTextStyle;
    // อ่านความกว้างหน้าจอ
    final screenWidth = MediaQuery.of(context).size.width;
    // กำหนดความกว้างคอลัมน์สุดท้าย
    final lastColumnWidth = screenWidth < 1000 ? 156.0 : 500.0;

    return Container(
      color: background,
      height: 54,
      child: Row(
        children: cells.asMap().entries.map((entry) {
          final i = entry.key;
          final text = entry.value;
          final isLast = i == cells.length - 1;

          return Container(
            width: isLast ? lastColumnWidth : 64.0,
            alignment: isLast ? Alignment.centerLeft : Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                right: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
              ),
            ),
            child: Text(
              text,
              textAlign: isLast ? TextAlign.left : TextAlign.center,
              style: style,
            ),
          );
        }).toList(),
      ),
    );
  }

  // Widget _buildScrollableRow(List<String> cells, {bool isHeader = false, Color? background}) {
  //   final style = isHeader ? _scrollHeaderTextStyle : _scrollDataTextStyle;
  //   return Container(
  //     color: background,
  //     height: 54,
  //     child: Row(
  //       children: cells
  //           .map((text) => Container(
  //                 width: 132,
  //                 alignment: Alignment.center,
  //                 padding: EdgeInsets.all(8),
  //                 child: Text(text, textAlign: TextAlign.center, style: style),
  //               ))
  //           .toList(),
  //     ),
  //   );
  // }
  Widget _buildScrollableRow(List<String> cells, {bool isHeader = false, Color? background}) {
    final style = isHeader ? _scrollHeaderTextStyle : _scrollDataTextStyle;

    return Container(
      color: background,
      height: 54,
      child: Row(
        children: cells.map((text) {
          // 1) ตรงนี้เราสร้าง widget ของแต่ละ cell ขึ้นมา
          Widget cellContent;
          if (text == 'ส่งตรงเวลา') {
            cellContent = Container(
              decoration: BoxDecoration(
                color: const Color(0x18219B90),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: FlutterFlowTheme.of(context).accent1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'ส่งตรงเวลา',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'IBM Plex Sans Thai Looped',
                      color: FlutterFlowTheme.of(context).accent1,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            );
          } else if (text == 'ส่งล่าช้า') {
            cellContent = Container(
              decoration: BoxDecoration(
                color: const Color(0x1CFF5A5A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: FlutterFlowTheme.of(context).accent3),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'ส่งล่าช้า',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'IBM Plex Sans Thai Looped',
                      color: FlutterFlowTheme.of(context).accent3,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            );
          } else {
            // ธรรมดาให้เป็น Text ธรรมดา
            cellContent = Text(
              text,
              textAlign: TextAlign.center,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }

          // 2) เอา widget ที่สร้างแล้ว ไปใส่ใน Expanded/Container
          return Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                ),
              ),
              child: cellContent,
            ),
          );
        }).toList(),
      ),
    );
  }

  TextStyle get _fixedHeaderTextStyle => FlutterFlowTheme.of(context).bodyMedium.override(
        fontFamily: 'IBM Plex Sans Thai Looped',
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: FlutterFlowTheme.of(context).primary,
      );

  TextStyle get _fixedDataTextStyle => FlutterFlowTheme.of(context).bodyLarge.override(
        fontFamily: 'IBM Plex Sans Thai Looped',
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        color: FlutterFlowTheme.of(context).secondaryText,
      );

  TextStyle get _scrollHeaderTextStyle => FlutterFlowTheme.of(context).bodyMedium.override(
        fontFamily: 'IBM Plex Sans Thai Looped',
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: FlutterFlowTheme.of(context).primary,
      );

  TextStyle get _scrollDataTextStyle => FlutterFlowTheme.of(context).bodyLarge.override(
        fontFamily: 'IBM Plex Sans Thai Looped',
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        color: FlutterFlowTheme.of(context).secondaryText,
      );
}
