import '/components/remark_widget/remark_widget_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'blood_pressure_grouping_d_ialog_model.dart';
export 'blood_pressure_grouping_d_ialog_model.dart';

class BloodPressureGroupingDIalogWidget extends StatefulWidget {
  const BloodPressureGroupingDIalogWidget({super.key});

  @override
  State<BloodPressureGroupingDIalogWidget> createState() =>
      _BloodPressureGroupingDIalogWidgetState();
}

class _BloodPressureGroupingDIalogWidgetState
    extends State<BloodPressureGroupingDIalogWidget> {
  late BloodPressureGroupingDIalogModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BloodPressureGroupingDIalogModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.0,
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
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'การจัดกลุ่มค่าความดัน',
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Sarabun',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                wrapWithModel(
                  model: _model.remarkWidgetModel,
                  updateCallback: () => safeSetState(() {}),
                  child: RemarkWidgetWidget(
                    text: 'หน่วยนับ : mmHg',
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFFFF6F5)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(-1.0, 0.87),
                      end: AlignmentDirectional(1.0, -0.87),
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ความดันบนต่ำ',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          '<90',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    color: Color(0xFFFF6058),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFE7F6FF)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(-1.0, 0.87),
                      end: AlignmentDirectional(1.0, -0.87),
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ความดันบนปกติ',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          '90 - 120',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFFFF6F5)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(-1.0, 0.87),
                      end: AlignmentDirectional(1.0, -0.87),
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ความดันบนสูง',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          '>= 140',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    color: Color(0xFFFF6058),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                StyledDivider(
                  thickness: 1.5,
                  color: FlutterFlowTheme.of(context).alternate,
                  lineStyle: DividerLineStyle.dashed,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFFFF6F5)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(-1.0, 0.87),
                      end: AlignmentDirectional(1.0, -0.87),
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ความดันล่างต่ำ',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          '<60',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    color: Color(0xFFFF6058),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFE7F6FF)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(-1.0, 0.87),
                      end: AlignmentDirectional(1.0, -0.87),
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ความดันล่างปกติ',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          '60 - 90',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFFFF6F5)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(-1.0, 0.87),
                      end: AlignmentDirectional(1.0, -0.87),
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ความดันล่างสูง',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          '>=90',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    color: Color(0xFFFF6058),
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
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }
}
