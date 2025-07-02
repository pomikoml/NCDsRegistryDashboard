import '/components/header/header_widget.dart';
import '/components/remark_widget/remark_widget_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'dashboard_overview_widget.dart' show DashboardOverviewWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardOverviewModel extends FlutterFlowModel<DashboardOverviewWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Header component.
  late HeaderModel headerModel;
  // State field(s) for DropDown widget.
  List<String>? dropDownValue;
  String? dropDownValue1;
  FormFieldController<List<String>>? dropDownValueController;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for Diabetes widget.
  bool diabetesHovered = false;
  // State field(s) for HighBlood widget.
  bool highBloodHovered = false;
  // State field(s) for Kidney widget.
  bool kidneyHovered = false;
  // State field(s) for Artery widget.
  bool arteryHovered = false;
  // State field(s) for Brain widget.
  bool brainHovered = false;
  // State field(s) for COPD widget.
  bool copdHovered = false;
  // State field(s) for BloodFat widget.
  bool bloodFatHovered = false;
  // State field(s) for Obesity widget.
  bool obesityHovered = false;
  // State field(s) for Vape widget.
  bool vapeHovered = false;
  // Model for RemarkWidget component.
  late RemarkWidgetModel remarkWidgetModel1;
  // Model for RemarkWidget component.
  late RemarkWidgetModel remarkWidgetModel2;
  // Model for RemarkWidget component.
  late RemarkWidgetModel remarkWidgetModel3;
  // Model for RemarkWidget component.
  late RemarkWidgetModel remarkWidgetModel4;

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
    remarkWidgetModel1 = createModel(context, () => RemarkWidgetModel());
    remarkWidgetModel2 = createModel(context, () => RemarkWidgetModel());
    remarkWidgetModel3 = createModel(context, () => RemarkWidgetModel());
    remarkWidgetModel4 = createModel(context, () => RemarkWidgetModel());
  }

  @override
  void dispose() {
    headerModel.dispose();
    remarkWidgetModel1.dispose();
    remarkWidgetModel2.dispose();
    remarkWidgetModel3.dispose();
    remarkWidgetModel4.dispose();
  }
}
