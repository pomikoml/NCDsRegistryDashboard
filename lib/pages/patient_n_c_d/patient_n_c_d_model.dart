import 'package:n_c_ds_registry_dashboard/flutter_flow/form_field_controller.dart';

import '/components/regist_n_c_d/regist_n_c_d_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'patient_n_c_d_widget.dart' show PatientNCDWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class PatientNCDModel extends FlutterFlowModel<PatientNCDWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  FocusNode? textFieldcidFocusNode;
  TextEditingController? textController;
  TextEditingController? textControllercid;
  String? Function(BuildContext, String?)? textControllerValidator;
  String? Function(BuildContext, String?)? textControllercidValidator;

  DateTimeRange? pickedDateRange;
  TextEditingController? dateRangeController;

  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  FormFieldController<String>? dropDownDiseaseController;

  TextEditingController? diseaseController;
  TextEditingController? filterstatusController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
    textFieldcidFocusNode?.dispose();
    textControllercid?.dispose();
    dateRangeController?.dispose();
  }
}
