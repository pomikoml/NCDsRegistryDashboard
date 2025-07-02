import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'remark_widget_model.dart';
export 'remark_widget_model.dart';

class RemarkWidgetWidget extends StatefulWidget {
  const RemarkWidgetWidget({
    super.key,
    this.text,
    this.count,
    this.unit,
  });

  final String? text;
  final int? count;
  final String? unit;

  @override
  State<RemarkWidgetWidget> createState() => _RemarkWidgetWidgetState();
}

class _RemarkWidgetWidgetState extends State<RemarkWidgetWidget> {
  late RemarkWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RemarkWidgetModel());

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
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 16.0,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  widget!.text,
                  '{text}',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'IBM Plex Sans Thai Looped',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (widget!.count != 0)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                child: Text(
                  formatNumber(
                    widget!.count,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.periodDecimal,
                  ),
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'IBM Plex Sans Thai Looped',
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            if (widget!.unit != null && widget!.unit != '')
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                child: Text(
                  valueOrDefault<String>(
                    widget!.unit,
                    '[unit]',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'IBM Plex Sans Thai Looped',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
          ].divide(SizedBox(width: 4.0)),
        ),
      ),
    );
  }
}
