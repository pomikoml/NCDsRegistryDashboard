import '/components/remark_widget/remark_widget_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'by_genders_widget_widget.dart' show ByGendersWidgetWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ByGendersWidgetModel extends FlutterFlowModel<ByGendersWidgetWidget> {
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
