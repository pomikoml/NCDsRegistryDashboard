import '/components/remark_widget/remark_widget_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'blood_pressure_grouping_d_ialog_widget.dart'
    show BloodPressureGroupingDIalogWidget;
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BloodPressureGroupingDIalogModel
    extends FlutterFlowModel<BloodPressureGroupingDIalogWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for RemarkWidget component.
  late RemarkWidgetModel remarkWidgetModel;

  @override
  void initState(BuildContext context) {
    remarkWidgetModel = createModel(context, () => RemarkWidgetModel());
  }

  @override
  void dispose() {
    remarkWidgetModel.dispose();
  }
}
