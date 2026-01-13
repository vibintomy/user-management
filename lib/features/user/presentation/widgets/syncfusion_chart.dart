import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class ChartData {
  final int x;
  final double y;
  ChartData(this.x, this.y);
}

class SyncfusionBarChart extends StatefulWidget {
  const SyncfusionBarChart({super.key});

  @override
  State<SyncfusionBarChart> createState() => _SyncfusionBarChartState();
}

class _SyncfusionBarChartState extends State<SyncfusionBarChart> {
  late TooltipBehavior _tooltip;

  final List<ChartData> chartData = [
    ChartData(1, 35),
    ChartData(2, 23),
    ChartData(3, 34),
    ChartData(4, 25),
    ChartData(5, 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Theme.of(context).colorScheme.surface),
      child: SfCartesianChart(
          borderWidth: 0,
          tooltipBehavior: _tooltip,
          series: <CartesianSeries<ChartData, int>>[
            ColumnSeries<ChartData, int>(
                dataSource: chartData,
                color: Theme.of(context).colorScheme.primary,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(5)),
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y)
          ]),
    );
  }

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }
}
