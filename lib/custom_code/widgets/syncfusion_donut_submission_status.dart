// Automatic FlutterFlow imports
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:n_c_ds_registry_dashboard/NCDs_getX.dart';

import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SyncfusionDonutSubmissionStatus extends StatefulWidget {
  const SyncfusionDonutSubmissionStatus({
    super.key,
    this.width,
    this.height,
    this.selected,
  });

  final double? width;
  final double? height;
  final int? selected;

  @override
  State<SyncfusionDonutSubmissionStatus> createState() => _SyncfusionDonutSubmissionStatusState();
}

class _SyncfusionDonutSubmissionStatusState extends State<SyncfusionDonutSubmissionStatus> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  late double total;
  final getX = Get.find<NCDsgetX>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getX.fetchSubmissionStatus(fiscalYear: widget.selected ?? 0);
    });
    // data = [
    //   _ChartData('ส่งข้อมูลแล้ว', getX.statusSubmittedCount.toDouble(), const Color(0xFF009688)), // เขียว
    //   _ChartData('ยังไม่ส่งข้อมูล', getX.statusNotSubmittedCount.toDouble(), const Color(0xFFE53935)), // แดง
    // ];

    // total = data.fold(0, (sum, item) => sum + item.y);

    _tooltip = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
      tooltipPosition: TooltipPosition.pointer,
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     final numberFormat = NumberFormat.decimalPattern();
//     final formattedTotal = numberFormat.format(total);

//     return Container(
//       width: widget.width,
//       height: widget.height,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           SfCircularChart(
//             tooltipBehavior: _tooltip,
//             legend: Legend(
//               isVisible: false,
//               position: LegendPosition.right,
//               overflowMode: LegendItemOverflowMode.wrap,
//             ),
//             series: <CircularSeries<_ChartData, String>>[
//               DoughnutSeries<_ChartData, String>(
//                 dataSource: data,
//                 xValueMapper: (_ChartData data, _) => data.x,
//                 yValueMapper: (_ChartData data, _) => data.y,
//                 pointColorMapper: (_ChartData data, _) => data.color,
//                 radius: '90%',
//                 innerRadius: '50%',
//                 dataLabelMapper: (_ChartData data, _) {
//                   final formattedValue = numberFormat.format(data.y);
//                   return '${data.x}\n$formattedValue';
//                 },
//                 dataLabelSettings: const DataLabelSettings(
//                   isVisible: true,
//                   labelPosition: ChartDataLabelPosition.outside,
//                   textStyle: TextStyle(fontSize: 14),
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'ทั้งหมด',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//               ),
//               Text(
//                 formattedTotal,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1C77BD),
//                 ),
//               ),
//               const Text(
//                 'หน่วยบริการ',
//                 style: TextStyle(fontSize: 12, color: Colors.black54),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern();

    return Container(
      width: widget.width,
      height: widget.height,
      child: Obx(() {
        // Read reactive counts
        final submitted = getX.statusSubmittedCount.toDouble();
        final notSubmitted = getX.statusNotSubmittedCount.toDouble();

        // Build chart data
        final chartData = <_ChartData>[
          _ChartData('ส่งข้อมูลแล้ว', submitted, const Color(0xFF009688)),
          _ChartData('ยังไม่ส่งข้อมูล', notSubmitted, const Color(0xFFE53935)),
        ];

        // Compute total
        final total = chartData.fold<double>(0, (sum, item) => sum + item.y);
        final formattedTotal = numberFormat.format(total);

        return Stack(
          alignment: Alignment.center,
          children: [
            SfCircularChart(
              tooltipBehavior: _tooltip,
              legend: Legend(
                isVisible: false,
                position: LegendPosition.right,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              series: <CircularSeries<_ChartData, String>>[
                DoughnutSeries<_ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  pointColorMapper: (_ChartData data, _) => data.color,
                  radius: '90%',
                  innerRadius: '50%',
                  dataLabelMapper: (_ChartData data, _) {
                    final val = numberFormat.format(data.y);
                    return '${data.x}\n$val';
                  },
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ทั้งหมด',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  formattedTotal,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C77BD),
                  ),
                ),
                const Text(
                  'หน่วยบริการ',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
