import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:pharmacy_intervention_sheet/extension/function/my_widget.dart';

// import '../../extension/flutter_flow/flutter_flow_icon_button.dart';
// import '../../extension/flutter_flow/flutter_flow_theme.dart';
// import '../../extension/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';
import 'package:n_c_ds_registry_dashboard/flutter_flow/flutter_flow_icon_button.dart';
import 'package:n_c_ds_registry_dashboard/flutter_flow/flutter_flow_model.dart';
import 'package:n_c_ds_registry_dashboard/flutter_flow/flutter_flow_theme.dart';
import 'package:n_c_ds_registry_dashboard/flutter_flow/flutter_flow_util.dart';
import 'select_hospital_model.dart';
export 'select_hospital_model.dart';

class SelectHospitalWidget extends StatefulWidget {
  const SelectHospitalWidget({super.key});

  @override
  State<SelectHospitalWidget> createState() => _SelectHospitalWidgetState();
}

class _SelectHospitalWidgetState extends State<SelectHospitalWidget> {
  late SelectHospitalModel _model;
  late final List<dynamic> hList;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // final getX = Get.find<HospitalController>();
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectHospitalModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    final getX = Get.find<HospitalController>();
    hList = getX.organizationList.toList();
    log('Controller hash at SET: ${Get.find<HospitalController>().hashCode}');

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/images/bg22.png',
            ).image,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 80.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 16.0,
                              borderWidth: 1.0,
                              buttonSize: 56.0,
                              fillColor: const Color(0x34FFFFFF),
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                // color: FlutterFlowTheme.of(context).customColor1,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                // Get.back();
                                Navigator.pop(context);
                              },
                            ),
                            Text(
                              'เลือกสถานพยาบาล',
                              style: FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                    // color: FlutterFlowTheme.of(context).customColor1,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).titleLargeFamily),
                                  ),
                            ),
                          ].divide(const SizedBox(width: 16.0)),
                        ),
                      ].divide(const SizedBox(width: 16.0)),
                    ),
                  ),
                ].divide(const SizedBox(width: 16.0)).around(const SizedBox(width: 16.0)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Lottie.asset(
                      //   'assets/lottie_animations/hospital.json',
                      //   width: 400.0,
                      //   height: 300.0,
                      //   fit: BoxFit.contain,
                      //   animate: false,
                      // ),
                      Image.asset(
                        'assets/images/hospital.png',
                        width: 200.0,
                        height: 250.0,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        'กรุณาเลือกสถานพยาบาลที่ให้บริการ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                            ),
                      ),
                      // Search
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: TextFormField(
                                      onChanged: (val) {
                                        setState(() {
                                          _filter = val;
                                        });
                                      },
                                      controller: _model.textController,
                                      focusNode: _model.textFieldFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: false,
                                        hintText: 'ค้นหา',
                                        hintStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                              fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w300,
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(0.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(0.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(0.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(0.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search_sharp,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          size: 20.0,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context).labelLarge.override(
                                            fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                          ),
                                      cursorColor: FlutterFlowTheme.of(context).primary,
                                      validator: _model.textControllerValidator.asValidator(context),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 48.0,
                                child: VerticalDivider(
                                  width: 1.0,
                                  thickness: 1.0,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // List Hospital
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              removeBottom: true,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: hList.length,
                                  itemBuilder: (context, index) {
                                    final item = hList[index];
                                    return item['hname_th'].toLowerCase().contains(_filter.toLowerCase()) || item['hcode'].toLowerCase().contains(_filter.toLowerCase())
                                        ? Material(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(8.0),
                                              // splashColor:   MyWidget().clPrimary.withOpacity(.2),
                                              // highlightColor: MyWidget().clPrimary.withOpacity(.2),
                                              onTap: () {
                                                Navigator.pop(context, item);

                                                // Get.back(result: item);
                                              },
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            child: Image.asset(
                                                              'assets/images/clinic_(1).png',
                                                              width: 56.0,
                                                              height: 56.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          Text(
                                                            //'โรงพยาบาลทดลองทกสอบ',
                                                            '${item['hname_th'] ?? '-'} [${item['hcode'] ?? '-'}]',
                                                            style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                  letterSpacing: 0.0,
                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).titleSmallFamily),
                                                                ),
                                                          ),
                                                        ].divide(const SizedBox(width: 16.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 1.0,
                                                    thickness: 1.0,
                                                    color: FlutterFlowTheme.of(context).alternate,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }),
                            )
                          ].divide(const SizedBox(height: 8.0)),
                        ),
                      ),
                    ].divide(const SizedBox(height: 16.0)),
                  ),
                ),
              ),
            ),
          ].addToStart(const SizedBox(height: 16.0)),
        ),
      ),
    );
  }
}
