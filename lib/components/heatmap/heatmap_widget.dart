import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'heatmap_model.dart';
export 'heatmap_model.dart';

class HeatmapWidget extends StatefulWidget {
  const HeatmapWidget({
    super.key,
    required this.topFirst,
    required this.topSec,
    required this.topThird,
    required this.midFirst,
    required this.midSec,
    required this.midThird,
    this.botFirst,
    required this.botSec,
    required this.botThird,
  });

  final int? topFirst;
  final int? topSec;
  final int? topThird;
  final int? midFirst;
  final int? midSec;
  final int? midThird;
  final int? botFirst;
  final int? botSec;
  final int? botThird;

  @override
  State<HeatmapWidget> createState() => _HeatmapWidgetState();
}

class _HeatmapWidgetState extends State<HeatmapWidget> {
  late HeatmapModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HeatmapModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
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
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.topFirst! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.topFirst! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.topFirst! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.topFirst! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.topFirst! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.topFirst! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.topFirst! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.topFirst! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.topFirst! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return FlutterFlowTheme.of(context)
                                      .secondaryBackground;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.topFirst,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '1',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.topFirst! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.topSec! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.topSec! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.topSec! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.topSec! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.topSec! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.topSec! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.topSec! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.topSec! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.topSec! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.topSec,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '2',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.topSec! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.topThird! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.topThird! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.topThird! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.topThird! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.topThird! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.topThird! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.topThird! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.topThird! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.topThird! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.topThird,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '3',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.topThird! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
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
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.midFirst! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.midFirst! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.midFirst! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.midFirst! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.midFirst! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.midFirst! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.midFirst! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.midFirst! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.midFirst! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.midFirst,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '4',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.midFirst! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.midSec! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.midSec! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.midSec! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.midSec! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.midSec! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.midSec! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.midSec! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.midSec! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.midSec! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.midSec,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '5',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.midSec! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.midThird! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.midThird! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.midThird! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.midThird! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.midThird! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.midThird! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.midThird! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.midThird! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.midThird! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.midThird,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '6',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.midThird! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
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
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.botFirst! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.botFirst! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.botFirst! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.botFirst! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.botFirst! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.botFirst! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.botFirst! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.botFirst! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.botFirst! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else if (widget!.botFirst == 0) {
                                  return FlutterFlowTheme.of(context)
                                      .primaryBackground;
                                } else {
                                  return Color(0x00000000);
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.botFirst,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '7',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.botFirst! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.botSec! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.botSec! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.botSec! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.botSec! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.botSec! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.botSec! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.botSec! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.botSec! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.botSec! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.botSec,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '8',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.botSec! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.botThird! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.botThird! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.botThird! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.botThird! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.topFirst! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.botThird! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.botThird! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.botThird! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.botThird! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.botThird,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '9',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.botThird! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
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
                  if (responsiveVisibility(
                    context: context,
                    phone: false,
                    tablet: false,
                    tabletLandscape: false,
                    desktop: false,
                  ))
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
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.topFirst! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.topFirst! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.topFirst! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.topFirst! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.topFirst! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.topFirst! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.topFirst! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.topFirst! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.topFirst! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.topFirst,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '1',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.topFirst! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.topSec! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.topSec! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.topSec! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.topSec! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.topSec! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.topSec! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.topSec! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.topSec! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.topSec! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.topSec,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '2',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.topSec! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.topThird! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.topThird! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.topThird! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.topThird! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.topThird! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.topThird! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.topThird! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.topThird! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.topThird! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.topThird,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '3',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.topThird! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.midFirst! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.midFirst! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.midFirst! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.midFirst! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.midFirst! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.midFirst! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.midFirst! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.midFirst! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.midFirst! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.midFirst,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '4',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.midFirst! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.midSec! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.midSec! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.midSec! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.midSec! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.midSec! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.midSec! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.midSec! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.midSec! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.midSec! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.midSec,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '5',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.midSec! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.midThird! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.midThird! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.midThird! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.midThird! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.midThird! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.midThird! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.midThird! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.midThird! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.midThird! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.midThird,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '6',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.midThird! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.botFirst! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.botFirst! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.botFirst! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.botFirst! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.botFirst! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.botFirst! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.botFirst! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.botFirst! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.botFirst! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.botFirst,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '7',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.botFirst! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.botSec! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.botSec! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.botSec! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.botSec! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.botSec! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.botSec! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.botSec! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.botSec! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.botSec! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.botSec,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '8',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.botSec! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget!.botThird! <= 500) {
                                  return Color(0xFFA4E3D3);
                                } else if (widget!.botThird! <= 2600) {
                                  return Color(0xFF91D1C8);
                                } else if (widget!.botThird! <= 5100) {
                                  return Color(0xFF7EBEBD);
                                } else if (widget!.botThird! <= 7600) {
                                  return Color(0xFF6BABB2);
                                } else if (widget!.topFirst! <= 10100) {
                                  return Color(0xFF5798A6);
                                } else if (widget!.botThird! <= 12600) {
                                  return Color(0xFF44859B);
                                } else if (widget!.botThird! <= 15100) {
                                  return Color(0xFF317390);
                                } else if (widget!.botThird! <= 17600) {
                                  return Color(0xFF1E6085);
                                } else if (widget!.botThird! >= 19600) {
                                  return Color(0xFF0F517C);
                                } else {
                                  return Colors.white;
                                }
                              }(),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      widget!.botThird,
                                      formatType: FormatType.decimal,
                                      decimalType: DecimalType.periodDecimal,
                                    ),
                                    '9',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Sarabun',
                                        color: widget!.botThird! >= 15100
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
