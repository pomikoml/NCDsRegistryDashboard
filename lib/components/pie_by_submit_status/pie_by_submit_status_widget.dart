import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pie_by_submit_status_model.dart';
export 'pie_by_submit_status_model.dart';

class PieBySubmitStatusWidget extends StatefulWidget {
  const PieBySubmitStatusWidget({
    super.key,
    this.ontime,
    this.ontimePercent,
    this.pending,
    this.pendingPercent,
    this.late,
    this.latePercent,
  });

  final int? ontime;
  final double? ontimePercent;
  final int? pending;
  final double? pendingPercent;
  final int? late;
  final double? latePercent;

  @override
  State<PieBySubmitStatusWidget> createState() => _PieBySubmitStatusWidgetState();
}

class _PieBySubmitStatusWidgetState extends State<PieBySubmitStatusWidget> {
  late PieBySubmitStatusModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PieBySubmitStatusModel());

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
                Text(
                  'ภาพรวมสถานะการนำส่งข้อมูล',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'IBM Plex Sans Thai Looped',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ].divide(SizedBox(width: 8.0)),
            ),
            Container(
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
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 312.0,
                      child: custom_widgets.SyncfusionPieSubmissionOverview(
                        width: double.infinity,
                        height: 312.0,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
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
                            borderRadius: BorderRadius.circular(24.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ส่งตรงเวลา',
                                      style: FlutterFlowTheme.of(context).labelMedium.override(
                                            fontFamily: 'IBM Plex Sans Thai Looped',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          valueOrDefault<String>(
                                            formatNumber(
                                              widget!.ontime,
                                              formatType: FormatType.decimal,
                                              decimalType: DecimalType.periodDecimal,
                                            ),
                                            '10,620',
                                          ),
                                          style: FlutterFlowTheme.of(context).headlineLarge.override(
                                                fontFamily: 'IBM Plex Sans Thai Looped',
                                                color: FlutterFlowTheme.of(context).accent1,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xCDFFFFFF),
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).alternate,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              // valueOrDefault<String>(
                                              //   formatNumber(
                                              //     widget!.ontimePercent,
                                              //     formatType: FormatType.percent,
                                              //   ),
                                              //   '29.56%',
                                              // ),
                                              '${(widget!.ontimePercent ?? 0).toStringAsFixed(2)}%',
                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                    fontFamily: 'IBM Plex Sans Thai Looped',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 1.0,
                                  height: 64.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ส่งล่าช้า',
                                      style: FlutterFlowTheme.of(context).labelMedium.override(
                                            fontFamily: 'IBM Plex Sans Thai Looped',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          valueOrDefault<String>(
                                            formatNumber(
                                              widget!.pending,
                                              formatType: FormatType.decimal,
                                              decimalType: DecimalType.periodDecimal,
                                            ),
                                            '20,000',
                                          ),
                                          style: FlutterFlowTheme.of(context).headlineLarge.override(
                                                fontFamily: 'IBM Plex Sans Thai Looped',
                                                color: FlutterFlowTheme.of(context).tertiary,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xCDFFFFFF),
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).alternate,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              // valueOrDefault<String>(
                                              //   formatNumber(
                                              //     widget!.pendingPercent,
                                              //     formatType: FormatType.percent,
                                              //   ),
                                              //   '55.70%',
                                              // ),
                                              '${(widget!.pendingPercent ?? 0).toStringAsFixed(2)}%',
                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                    fontFamily: 'IBM Plex Sans Thai Looped',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 1.0,
                                  height: 64.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ยังไม่ส่ง',
                                      style: FlutterFlowTheme.of(context).labelMedium.override(
                                            fontFamily: 'IBM Plex Sans Thai Looped',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          valueOrDefault<String>(
                                            formatNumber(
                                              widget!.late,
                                              formatType: FormatType.decimal,
                                              decimalType: DecimalType.periodDecimal,
                                            ),
                                            '5,301',
                                          ),
                                          style: FlutterFlowTheme.of(context).headlineLarge.override(
                                                fontFamily: 'IBM Plex Sans Thai Looped',
                                                color: FlutterFlowTheme.of(context).accent3,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xCDFFFFFF),
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).alternate,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              // valueOrDefault<String>(
                                              //   formatNumber(
                                              //     widget!.latePercent,
                                              //     formatType: FormatType.percent,
                                              //   ),
                                              //   '14.74%',
                                              // ),
                                              '${(widget!.latePercent ?? 0).toStringAsFixed(2)}%',
                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                    fontFamily: 'IBM Plex Sans Thai Looped',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                  ],
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                  ],
                ),
              ),
            ),
          ].divide(SizedBox(height: 8.0)),
        ),
      ),
    );
  }
}
