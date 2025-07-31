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

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SyncfusionPieSubmissionOverview extends StatefulWidget {
  const SyncfusionPieSubmissionOverview({
    super.key,
    this.width,
    this.height,
    this.selected,
  });

  final double? width;
  final double? height;
  final int? selected;

  @override
  State<SyncfusionPieSubmissionOverview> createState() => _SyncfusionPieSubmissionOverviewState();
}

class _SyncfusionPieSubmissionOverviewState extends State<SyncfusionPieSubmissionOverview> {
  late TooltipBehavior _tooltip;
  late List<ChartData> chartData;
  late double total;
  final getX = Get.find<NCDsgetX>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getX.fetchSubmissionStatus(fiscalYear: widget.selected ?? 0);
    });
    // chartData = [
    //   ChartData('ส่งตรงเวลา', getX.statusExcellentCount.toDouble(), const Color(0xFF009688)), // teal
    //   ChartData('รอนำส่ง', getX.statusPendingCount.toDouble(), const Color(0xFFF28B50)), // orange
    //   ChartData('ส่งล่าช้า', getX.statusLateCount.toDouble(), const Color(0xFFE53935)), // red
    // ];

    // total = chartData.fold(0, (sum, item) => sum + item.y);

    _tooltip = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
      tooltipPosition: TooltipPosition.pointer,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final numberFormat = NumberFormat.decimalPattern();

  //   return Container(
  //     width: widget.width ?? double.infinity,
  //     height: widget.height,
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         SfCircularChart(
  //           tooltipBehavior: _tooltip,
  //           legend: Legend(
  //             isVisible: false,
  //             position: LegendPosition.bottom,
  //             overflowMode: LegendItemOverflowMode.wrap,
  //             textStyle: const TextStyle(color: Colors.black),
  //           ),
  //           series: <CircularSeries>[
  //             DoughnutSeries<ChartData, String>(
  //               dataSource: chartData,
  //               radius: '90%',
  //               innerRadius: '50%',
  //               xValueMapper: (ChartData data, _) => data.x,
  //               yValueMapper: (ChartData data, _) => data.y,
  //               pointColorMapper: (ChartData data, _) => data.color,
  //               dataLabelMapper: (ChartData data, _) {
  //                 final formatted = numberFormat.format(data.y);
  //                 return '${data.x}\n$formatted';
  //               },
  //               dataLabelSettings: const DataLabelSettings(
  //                 isVisible: true,
  //                 labelPosition: ChartDataLabelPosition.outside,
  //                 textStyle: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               'ทั้งหมด',
  //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  //             ),
  //             Text(
  //               numberFormat.format(total),
  //               style: const TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xFF1C77BD), // Blue color
  //               ),
  //             ),
  //             const Text(
  //               'หน่วยบริการ',
  //               style: TextStyle(fontSize: 12, color: Colors.black54),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern();

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: Obx(() {
        // Reactive counts
        final excellent = getX.statusExcellentCount.toDouble();
        final pending = getX.statusPendingCount.toDouble();
        final late = getX.statusLateCount.toDouble();

        // Build chart data
        final chartData = <ChartData>[
          ChartData('ส่งตรงเวลา', excellent, const Color(0xFF009688)), // teal
          ChartData('รอนำส่ง', pending, const Color(0xFFF28B50)), // orange
          ChartData('ส่งล่าช้า', late, const Color(0xFFE53935)), // red
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
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
                textStyle: const TextStyle(color: Colors.black),
              ),
              series: <CircularSeries>[
                DoughnutSeries<ChartData, String>(
                  dataSource: chartData,
                  radius: '90%',
                  innerRadius: '50%',
                  xValueMapper: (ChartData d, _) => d.x,
                  yValueMapper: (ChartData d, _) => d.y,
                  pointColorMapper: (ChartData d, _) => d.color,
                  dataLabelMapper: (ChartData d, _) {
                    final val = numberFormat.format(d.y);
                    return '${d.x}\n$val';
                  },
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
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

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
