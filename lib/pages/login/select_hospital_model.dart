

// import '../../extension/flutter_flow/flutter_flow_icon_button.dart';
// import '../../extension/flutter_flow/flutter_flow_theme.dart';
// import '../../extension/flutter_flow/flutter_flow_util.dart';
// import '../../extension/flutter_flow/flutter_flow_widgets.dart';
import 'package:n_c_ds_registry_dashboard/flutter_flow/flutter_flow_model.dart';

import 'select_hospital_widget.dart' show SelectHospitalWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SelectHospitalModel extends FlutterFlowModel<SelectHospitalWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
