import 'package:n_c_ds_registry_dashboard/pages/login/base_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_uuid_string/random_uuid_string.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'login_model.dart';
export 'login_model.dart';
import 'dart:html' as html;

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'Login';
  static String routePath = '/';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> with TickerProviderStateMixin {
  late LoginModel _model;
  String _redirectUri = '';
  String _stepLoginWithProvider = '';

  bool _isBussy = false;
  final _providerApiController = CallApiController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  // late TextEditingController _usernameController;
  // late FocusNode _usernameFocusNode;

  // late TextEditingController _passwordController;
  // late FocusNode _passwordFocusNode;

  Future<void> _authenticateForWeb() async {
    //debugPrint('Authentication Re Direct Uri: $_redirectUri');

    String providerIDstateID = "&scope=ProviderID&state=${RandomString.randomString(length: 20).toUpperCase()}";
    final url = Uri.parse('${_providerApiController.url_HealthID}/oauth/redirect?response_type=code&client_id=${_providerApiController.clientid_HealthID}&redirect_uri=$_redirectUri$providerIDstateID');

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        // forceSafariVC: true,
        // forceWebView: true,
        webOnlyWindowName: '_self',
      );
    } else {
      // log('Could not launch $url');
      // throw 'Could not launch $urlOauth';
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    // _model.textController1 ??= TextEditingController();
    // _model.textFieldFocusNode1 ??= FocusNode();

    // _model.textController2 ??= TextEditingController();
    // _model.textFieldFocusNode2 ??= FocusNode();

    // กำหนดค่าเริ่มต้นให้กับ TextEditingController และ FocusNode
    // _usernameController = TextEditingController();
    // _usernameFocusNode = FocusNode();

    // _passwordController = TextEditingController();
    // _passwordFocusNode = FocusNode();

    if (kIsWeb) {
      String url = html.window.location.href;
      //debugPrint('devlog url:$url');
      Uri uri = Uri.parse(url);
      String? code = uri.queryParameters['code'];
      //debugPrint('devlog code:$code');
      // html.window.history.pushState({}, '', '/');
      html.window.history.pushState({}, '', '/dashboard');

      _redirectUri = Uri.base.toString();
      _redirectUri = '${_redirectUri}';

      try {
        if (code != null) {
          if (code.trim() != '') {
            //debugPrint('_getProviderID');
            //debugPrint('Init ReDirect Uri: $_redirectUri');
            _getProviderID(code, _redirectUri);
          }
        }
      } catch (e) {
        //debugPrint(e.toString());
      }
    }

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, -15.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'imageOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.elasticOut,
            delay: 300.0.ms,
            duration: 2400.0.ms,
            begin: Offset(0.0, 30.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, -15.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'imageOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 500.0.ms,
            duration: 1200.0.ms,
            begin: Offset(15.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _getProviderID(String code, url) async {
    //Get.back();
    setState(() {
      _isBussy = true;
    });

    //debugPrint('Getting Provider ID...');
    //debugPrint('Result Code: $code');

    //debugPrint('[1]. Getting Moph Token Provider...');
    setState(() {
      _stepLoginWithProvider = 'Getting moph token provider...';
    });

    if (!await _providerApiController.GetMophTokenProvider(code, url)) {
      // MyWidget().showPopUpErrorWidget(context: Get.overlayContext!, caption: 'Getting moph token provider failed!');
      // await Future.delayed(const Duration(milliseconds: 4000));
      // Get.back();
      _isBussy = false;
      return;
    }

    //debugPrint('[2]. Getting Moph Account...');
    setState(() {
      _stepLoginWithProvider = 'Getting moph account...';
    });

    if (!await _providerApiController.GetMophAccount()) {
      // MyWidget().showPopUpErrorWidget(context: Get.overlayContext!, caption: 'Getting moph account failed!');
      // await Future.delayed(const Duration(milliseconds: 4000));
      // Get.back();
      _isBussy = false;
      return;
    }

    //debugPrint('[3]. Getting Provider Token...');
    setState(() {
      _stepLoginWithProvider = 'Getting provider token...';
    });

    if (!await _providerApiController.GetProviderToken()) {
      // MyWidget().showPopUpErrorWidget(context: Get.overlayContext!, caption: 'Getting provider token failed!');
      // await Future.delayed(const Duration(milliseconds: 4000));
      // Get.back();
      _isBussy = false;
      return;
    }
//bbb
    //debugPrint('[4]. Getting Provider Profile Staff...');
    setState(() {
      _stepLoginWithProvider = 'Getting provider profile staff...';
    });

    if (!await _providerApiController.GetProviderProfileStaff(context)) {
      // MyWidget().showPopUpErrorWidget(context: Get.overlayContext!, caption: 'Getting provider profile staff failed!');
      // await Future.delayed(const Duration(milliseconds: 4000));
      // Get.back();
      _isBussy = false;
      return;
    }

    // if (Endpoints.apiUserJWT == '') {
    //   _isBussy.value = false;
    //   return;
    // }
    // //debugPrint('[5]. Logining ${EHPMobile.loginName}...');
    // _stepLoginWithProvider.value = 'Signing in ${EHPMobile.hospitalCode} ${EHPMobile.hospitalName}...';
    // if (await _entryTrackingGetX.loginDoctorWithCID(EHPMobile.loginName)) {
    //   log('officer_login_name: ${_entryTrackingGetX.officer.value?.officer_login_name}', name: 'OfficerLogin');
    //   log('officer_doctor_code: ${_entryTrackingGetX.officer.value?.officer_doctor_code}', name: 'OfficerLogin');
    //   log('officer_name: ${_entryTrackingGetX.officer.value?.officer_name}', name: 'OfficerLogin');

    //   //Get.back();

    //   log('After HospitalCode ${EHPMobile.hospitalCode}');

    //   //Get.off(() => const MainPageWidget())?.then((value) => _isBussy.value = false);
    // Get.offAllNamed(Routes.MAIN_PAGE)?.then((value) => _isBussy.value = false);

    // context.pushNamed('DashboardOverviewWidget');

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => DashboardOverviewWidget(),
    //     ));
    // context.pushNamed(
    //   DashboardOverviewWidget.routeName,
    // );
    context.goNamed(DashboardOverviewWidget.routeName);

    //   //_isBussy.value = false;
    // } else {
    //   // MyWidget().showPopUpErrorWidget(context: context, caption: 'Signing in doctor with CID failed! [${EHPMobile.hospitalCode}]');
    //   // await Future.delayed(const Duration(milliseconds: 4000));
    //   // _isBussy.value = false;
    //   // Get.back();
    // }
  }

  @override
  void dispose() {
    _model.dispose();
    // อย่าลืมล้างหน่วยความจำเมื่อไม่ใช้งาน
    // _usernameController.dispose();
    // _usernameFocusNode.dispose();

    // _passwordController.dispose();
    // _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: _isBussy
          ? Scaffold(
              // key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).accent2,
                      FlutterFlowTheme.of(context).accent1
                    ],
                    stops: const [
                      0.0,
                      1.0
                    ],
                    begin: const AlignmentDirectional(0.03, -1.0),
                    end: const AlignmentDirectional(-0.03, 1.0),
                  ),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.95,
                    height: MediaQuery.sizeOf(context).height * 0.86,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(
                          'assets/images/bg_provider_load.png',
                        ).image,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x33000000),
                          offset: Offset(
                            0.0,
                            0.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        width: 2.0,
                      ),
                    ),
                    child: Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          Column(mainAxisSize: MainAxisSize.max, children: [
                            //SizedBox(height: 100, width: 100, child: Center(child: LinearProgressIndicator(backgroundColor: Color.fromRGBO(9, 134, 79, 255), minHeight: 10.0, borderRadius: BorderRadius.circular(8.0)))),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/providerid.png',
                                  height: 120.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            Text(
                              'กำลังเข้าสู่ระบบ..',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context).labelLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                    letterSpacing: 0.0,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                    color: Colors.green[800],
                                  ),
                            ),
                            const SizedBox(height: 24.0),

                            Text(
                              // 'กำลังเข้าสู่ระบบ...',
                              _stepLoginWithProvider,
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context).labelLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w300,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                  ),
                            ),
                          ] //.divide(const SizedBox(height: 24.0)),
                              ),
                        ].divide(const SizedBox(height: 64.0)),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
                          padding: EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
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
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFDDEEFF),
                                        Colors.white
                                      ],
                                      stops: [
                                        0.0,
                                        1.0
                                      ],
                                      begin: AlignmentDirectional(0.0, -1.0),
                                      end: AlignmentDirectional(0, 1.0),
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              height: 56.0,
                                              decoration: BoxDecoration(
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
                                              ),
                                              child: Hero(
                                                tag: 'AppLogo',
                                                transitionOnUserGestures: true,
                                                child: Image.asset(
                                                  'assets/images/app_logo.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Align(
                                          alignment: AlignmentDirectional(0.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(52.0, 0.0, 52.0, 0.0),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(0.0),
                                                      child: Image.asset(
                                                        'assets/images/doctor_dashboard.png',
                                                        width: double.infinity,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation1']!),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'ยินดีต้อนรับสู่',
                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                  fontFamily: 'Sarabun',
                                                                  letterSpacing: 0.0,
                                                                ),
                                                          ),
                                                          GradientText(
                                                            'NCDs Registry',
                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                  fontFamily: 'Sarabun',
                                                                  letterSpacing: 0.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                            colors: [
                                                              Color(0xFF219B90),
                                                              Color(0xFFA0CE66)
                                                            ],
                                                            gradientDirection: GradientDirection.ltr,
                                                            gradientType: GradientType.linear,
                                                          ),
                                                        ].divide(SizedBox(width: 8.0)),
                                                      ),
                                                      Text(
                                                        'แดชบอร์ดข้อมูลผู้ป่วยโรคไม่ติดต่อเรื้อรัง (Non-Communicable Diseases : NCDs)',
                                                        textAlign: TextAlign.center,
                                                        style: FlutterFlowTheme.of(context).labelLarge.override(
                                                              fontFamily: 'Sarabun',
                                                              letterSpacing: 0.0,
                                                            ),
                                                      ),
                                                    ].divide(SizedBox(height: 16.0)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'ลงชื่อเข้าใช้งานด้วยระบบ Provider ID',
                                                        textAlign: TextAlign.center,
                                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                                              fontFamily: 'Sarabun',
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                              letterSpacing: 0.0,
                                                            ),
                                                      ),
                                                      InkWell(
                                                        splashColor: Colors.transparent,
                                                        focusColor: Colors.transparent,
                                                        hoverColor: Colors.transparent,
                                                        highlightColor: Colors.transparent,
                                                        onTap: () async {
                                                          // DashboardOverviewWidget.routeName,
                                                          // context.pushNamed('DashboardOverviewWidget');
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //       builder: (context) => DashboardOverviewWidget(),
                                                          //     ));
                                                          _authenticateForWeb();
                                                        },
                                                        child: Container(
                                                          width: 420.0,
                                                          height: 54.0,
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
                                                            borderRadius: BorderRadius.circular(16.0),
                                                            border: Border.all(
                                                              color: Color(0xFF28A440),
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(8.0),
                                                                child: Image.asset(
                                                                  'assets/images/provider_id.png',
                                                                  height: 36.0,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(width: 8.0)),
                                                          ),
                                                        ),
                                                      ),
                                                      //----------------------
                                                      // InkWell(
                                                      //   splashColor: Colors.transparent,
                                                      //   focusColor: Colors.transparent,
                                                      //   hoverColor: Colors.transparent,
                                                      //   highlightColor: Colors.transparent,
                                                      //   onTap: () async {
                                                      //     // context.pushNamed('Dashboard00');
                                                      //     _authenticateForWeb();
                                                      //   },
                                                      //   child: Container(
                                                      //     width: 400.0,
                                                      //     height: 56.0,
                                                      //     decoration: BoxDecoration(
                                                      //       color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      //       borderRadius: BorderRadius.circular(100.0),
                                                      //       border: Border.all(
                                                      //         color: FlutterFlowTheme.of(context).alternate,
                                                      //       ),
                                                      //     ),
                                                      //     child: Column(
                                                      //       mainAxisSize: MainAxisSize.max,
                                                      //       mainAxisAlignment: MainAxisAlignment.center,
                                                      //       children: [
                                                      //         ClipRRect(
                                                      //           borderRadius: BorderRadius.circular(8.0),
                                                      //           child: Image.asset(
                                                      //             'assets/images/providerid.png',
                                                      //             height: 32.0,
                                                      //             fit: BoxFit.cover,
                                                      //           ),
                                                      //         ),
                                                      //       ].divide(SizedBox(height: 8.0)),
                                                      //     ),
                                                      //   ),
                                                      // ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
                                                    ].divide(SizedBox(height: 8.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: AlignmentDirectional(0.0, 1.0),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 16.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'BANGKOK MEDICAL SOFTWARE CO.,LTD.',
                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                        fontFamily: 'Sarabun',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                                Text(
                                                  'VERSION 30.7.68.1',
                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                        fontFamily: 'Sarabun',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
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
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Color(0xFFDDEEFF)
                                      ],
                                      stops: [
                                        0.0,
                                        1.0
                                      ],
                                      begin: AlignmentDirectional(0.0, -1.0),
                                      end: AlignmentDirectional(0, 1.0),
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: AlignmentDirectional(-1.0, 1.0),
                                    children: [
                                      Stack(
                                        alignment: AlignmentDirectional(1.0, -1.0),
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'เข้าถึงข้อมูลผู้ป่วย NCDs อย่างครบครัน',
                                                      style: FlutterFlowTheme.of(context).titleSmall.override(
                                                            fontFamily: 'Sarabun',
                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                            letterSpacing: 0.0,
                                                            fontWeight: FontWeight.normal,
                                                          ),
                                                    ),
                                                    Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'ภายใน ',
                                                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                fontFamily: 'Sarabun',
                                                                letterSpacing: 0.0,
                                                              ),
                                                        ),
                                                        GradientText(
                                                          'Dashboard ',
                                                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                fontFamily: 'Sarabun',
                                                                letterSpacing: 0.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                          colors: [
                                                            FlutterFlowTheme.of(context).primary,
                                                            FlutterFlowTheme.of(context).secondary
                                                          ],
                                                          gradientDirection: GradientDirection.ltr,
                                                          gradientType: GradientType.linear,
                                                        ),
                                                        Text(
                                                          'เดียว',
                                                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                fontFamily: 'Sarabun',
                                                                letterSpacing: 0.0,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ].divide(SizedBox(height: 4.0)),
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment: AlignmentDirectional(1.0, 0.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    child: Image.asset(
                                                      'assets/images/hilight.png',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 40.0, 0.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                'assets/images/decorate_login1.png',
                                                height: 142.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 24.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/decorate_login2.png',
                                            height: 180.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!),
                              ),
                            ].divide(SizedBox(width: 24.0)),
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
