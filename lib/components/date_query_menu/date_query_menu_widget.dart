import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'date_query_menu_model.dart';
export 'date_query_menu_model.dart';

class DateQueryMenuWidget extends StatefulWidget {
  const DateQueryMenuWidget({super.key});

  @override
  State<DateQueryMenuWidget> createState() => _DateQueryMenuWidgetState();
}

class _DateQueryMenuWidgetState extends State<DateQueryMenuWidget> {
  late DateQueryMenuModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DateQueryMenuModel());

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
                      _model.dropDownValueController?.reset();
                    });
                  },
                  text: 'รีเซ็ต',
                  icon: Icon(
                    Icons.restore_rounded,
                    size: 16.0,
                  ),
                  options: FFButtonOptions(
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
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 12.0),
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
                                Expanded(
                                  child: FlutterFlowDropDown<String>(
                                    multiSelectController: _model.dropDownValueController ??= FormListFieldController<String>(_model.dropDownValue ??= List<String>.from(
                                      FFAppConstants.years.take(1).toList() ?? [],
                                    )),
                                    options: [
                                      'ทั้งหมด',
                                      'พ.ศ. 2567',
                                      'พ.ศ. 2566',
                                      '...'
                                    ],
                                    searchHintTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                          fontFamily: 'Sarabun',
                                          letterSpacing: 0.0,
                                        ),
                                    searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Sarabun',
                                          letterSpacing: 0.0,
                                        ),
                                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Sarabun',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    hintText: 'ทั้งหมด',
                                    searchHintText: 'ค้นหาปี',
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      size: 0.0,
                                    ),
                                    elevation: 2.0,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0.0,
                                    borderRadius: 8.0,
                                    margin: EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 0.0, 0.0),
                                    hidesUnderline: true,
                                    isOverButton: false,
                                    isSearchable: true,
                                    isMultiSelect: true,
                                    onMultiSelectChanged: (val) => safeSetState(() => _model.dropDownValue = val),
                                    dropdownHeight: 150,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 0.0, 0.0),
                              child: Text(
                                'เลือกจากปฏิทิน',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Sarabun',
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                          child: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ].divide(SizedBox(height: 8.0)),
      ),
    );
  }
}
