// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';

class CustomSegmentedProgressBar extends StatefulWidget {
  const CustomSegmentedProgressBar({
    super.key,
    this.width,
    this.height,
    this.selected,
  });

  final double? width;
  final double? height;
  final int? selected;

  @override
  State<CustomSegmentedProgressBar> createState() => _CustomSegmentedProgressBarState();
}

class _CustomSegmentedProgressBarState extends State<CustomSegmentedProgressBar> {
  final getX = Get.find<NCDsgetX>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getX.fetchGroupByGender(fiscalYear: widget.selected ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = getX.totalGender.value;
      final maleProportion = total > 0 ? getX.countM.value / total : 0.0;
      final femaleProportion = total > 0 ? getX.countF.value / total : 0.0;
      final maleFlex = total > 0 ? (maleProportion * 1000).round().clamp(1, 1000) : 1;
      final femaleFlex = total > 0 ? (femaleProportion * 1000).round() : 1;

      // if (getX.totalGender.value == 0) {
      //   // ยังโหลดไม่เสร็จ
      //   return const Center(child: CircularProgressIndicator());
      // }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('เพศชาย', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('เพศหญิง', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Expanded(
                  flex: maleFlex,
                  // ((maleProportion * 1000).round()).clamp(1, 1000),
                  child: Tooltip(
                    message: 'เพศชาย : ${getX.countM.value}',
                    preferBelow: false,
                    verticalOffset: 8.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    waitDuration: Duration(milliseconds: 300),
                    child: Container(
                      color: Color.fromARGB(255, 0, 121, 197),
                      height: widget.height ?? 24,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        _formatNumber(getX.countM.value),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: femaleFlex,
                  // (femaleProportion * 1000).round(),
                  child: Tooltip(
                    message: 'เพศหญิง : ${getX.countF.value}',
                    preferBelow: false,
                    verticalOffset: 8.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    waitDuration: Duration(milliseconds: 300),
                    child: Container(
                      color: Color.fromARGB(255, 255, 142, 240),
                      height: widget.height,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        _formatNumber(getX.countF.value),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}
