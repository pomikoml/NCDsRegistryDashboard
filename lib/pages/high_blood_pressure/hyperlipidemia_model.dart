import 'package:n_c_ds_registry_dashboard/pages/high_blood_pressure/hyperlipidemia_widget.dart' show HyperlipidemiaWidget;

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
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HyperlipidemiaModel extends FlutterFlowModel<HyperlipidemiaWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Header component.
  late HeaderModel headerModel;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // State field(s) for DropDown widget.
  String? dropDownValue3;
  FormFieldController<String>? dropDownValueController3;
  // State field(s) for DropDown widget.
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController4;
  // State field(s) for DropDown widget.
  String? dropDownValue5;
  FormFieldController<String>? dropDownValueController5;
  // Model for RemarkWidget component.
  late RemarkWidgetModel remarkWidgetModel1;
  // Model for RemarkWidget component.
  late RemarkWidgetModel remarkWidgetModel2;
  // Model for RemarkWidget component.
  late RemarkWidgetModel remarkWidgetModel3;

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
    remarkWidgetModel1 = createModel(context, () => RemarkWidgetModel());
    remarkWidgetModel2 = createModel(context, () => RemarkWidgetModel());
    remarkWidgetModel3 = createModel(context, () => RemarkWidgetModel());
  }

  @override
  void dispose() {
    headerModel.dispose();
    remarkWidgetModel1.dispose();
    remarkWidgetModel2.dispose();
    remarkWidgetModel3.dispose();
  }
}
