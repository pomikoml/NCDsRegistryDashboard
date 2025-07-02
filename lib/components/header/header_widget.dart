import 'package:flutter_svg/svg.dart';

import '/components/logout/logout_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'header_model.dart';
export 'header_model.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({
    super.key,
    this.username,
    this.position,
    this.organiazation,
  });

  final String? username;
  final String? position;
  final String? organiazation;

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late HeaderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HeaderModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 24.0,
                color: Color(0x1F666666),
                offset: Offset(
                  0.0,
                  2.0,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, -1.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child:
                          // SvgPicture.network(
                          //   'assets/images/ncd_logo.svg',
                          //   height: 52.0,
                          //   fit: BoxFit.contain,
                          // )

                          Image.asset(
                        'assets/images/ncds-logo.png',
                        height: 52.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MouseRegion(
                        opaque: false,
                        cursor: MouseCursor.defer ?? MouseCursor.defer,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            // context.pushNamed(PatientNCDWidget.routeName);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => PatientNCDWidget(),
                            //     ));
                            // context.pushNamed(
                            //   PatientNCDWidget.routeName,
                            // );
                            context.goNamed(PatientNCDWidget.routeName);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.list_alt_rounded,
                                color: _model.mouseRegionHovered! ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                              Text(
                                'ทะเบียนผู้ป่วย NCD',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.sarabun(
                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                      color: _model.mouseRegionHovered! ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                        ),
                        onEnter: ((event) async {
                          safeSetState(() => _model.mouseRegionHovered = true);
                        }),
                        onExit: ((event) async {
                          safeSetState(() => _model.mouseRegionHovered = false);
                        }),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget!.username,
                            'userName',
                          ),
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                fontFamily: 'Sarabun',
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                widget!.position,
                                'position',
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Text(
                              '•',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Text(
                              valueOrDefault<String>(
                                widget!.organiazation,
                                'organization',
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Sarabun',
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: Image.asset(
                        'assets/images/doctor-avatar.png',
                        width: 52.0,
                        height: 52.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Builder(
                      builder: (context) => FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        fillColor: Color(0xFFFF5A5A),
                        icon: Icon(
                          Icons.logout_rounded,
                          color: FlutterFlowTheme.of(context).info,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          await showDialog(
                            barrierColor: Color(0x99000000),
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                elevation: 0,
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                child: LogoutWidget(),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ].divide(SizedBox(width: 12.0)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
