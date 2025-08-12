import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ChartSectionWidget extends StatelessWidget {
  final String selectedPeriod;

  const ChartSectionWidget({
    Key? key,
    required this.selectedPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text('Analyse Graphique',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface))),
      SizedBox(height: 2.h),
      _buildIncomeExpenseChart(),
      SizedBox(height: 3.h),
      _buildCategoryPieChart(),
      SizedBox(height: 3.h),
      _buildTrendLineChart(),
    ]);
  }

  Widget _buildIncomeExpenseChart() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Revenus vs Dépenses',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          SizedBox(
              height: 25.h,
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5000000,
                  barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBorder: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline))),
                  titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final months = [
                                  'Jan',
                                  'Fév',
                                  'Mar',
                                  'Avr',
                                  'Mai',
                                  'Jun'
                                ];
                                return Text(
                                    months[value.toInt() % months.length],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall);
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 15.w,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                    '${(value / 1000000).toStringAsFixed(1)}M',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall);
                              })),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false))),
                  borderData: FlBorderData(show: false),
                  barGroups: _generateBarData(),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1000000,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      })))),
        ]));
  }

  Widget _buildCategoryPieChart() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Répartition par Catégorie',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          SizedBox(
              height: 25.h,
              child: Row(children: [
                Expanded(
                    flex: 3,
                    child: PieChart(PieChartData(
                        sections: _generatePieData(),
                        centerSpaceRadius: 8.w,
                        sectionsSpace: 2,
                        pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {})))),
                Expanded(
                    flex: 2,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem(
                              'Dîmes', AppTheme.lightTheme.colorScheme.primary),
                          _buildLegendItem('Offrandes', AppTheme.accentLight),
                          _buildLegendItem('Dons', AppTheme.successLight),
                          _buildLegendItem('Projets', AppTheme.warningLight),
                        ])),
              ])),
        ]));
  }

  Widget _buildTrendLineChart() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tendance Mensuelle',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          SizedBox(
              height: 25.h,
              child: LineChart(LineChartData(
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 500000,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      }),
                  titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final months = [
                                  'Jan',
                                  'Fév',
                                  'Mar',
                                  'Avr',
                                  'Mai',
                                  'Jun'
                                ];
                                return Text(
                                    months[value.toInt() % months.length],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall);
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 15.w,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                    '${(value / 1000000).toStringAsFixed(1)}M',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall);
                              })),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false))),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 3000000,
                  lineBarsData: [
                    LineChartBarData(
                        spots: _generateLineData(),
                        isCurved: true,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                  radius: 4,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white);
                            }),
                        belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1))),
                  ],
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                          tooltipBorder: BorderSide(
                              color:
                                  AppTheme.lightTheme.colorScheme.outline)))))),
        ]));
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5.h),
        child: Row(children: [
          Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          SizedBox(width: 2.w),
          Expanded(
              child: Text(label,
                  style: AppTheme.lightTheme.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis)),
        ]));
  }

  List<BarChartGroupData> _generateBarData() {
    final incomeData = [
      2500000.0,
      2800000.0,
      2200000.0,
      3100000.0,
      2900000.0,
      3300000.0
    ];
    final expenseData = [
      1800000.0,
      2100000.0,
      1900000.0,
      2400000.0,
      2200000.0,
      2600000.0
    ];

    return List.generate(6, (index) {
      return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
                toY: incomeData[index],
                color: AppTheme.successLight,
                width: 4.w,
                borderRadius: BorderRadius.circular(2)),
            BarChartRodData(
                toY: expenseData[index],
                color: AppTheme.errorLight,
                width: 4.w,
                borderRadius: BorderRadius.circular(2)),
          ],
          barsSpace: 1.w);
    });
  }

  List<PieChartSectionData> _generatePieData() {
    return [
      PieChartSectionData(
          color: AppTheme.lightTheme.colorScheme.primary,
          value: 40,
          title: '40%',
          radius: 12.w,
          titleStyle: AppTheme.lightTheme.textTheme.bodySmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
      PieChartSectionData(
          color: AppTheme.accentLight,
          value: 30,
          title: '30%',
          radius: 12.w,
          titleStyle: AppTheme.lightTheme.textTheme.bodySmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
      PieChartSectionData(
          color: AppTheme.successLight,
          value: 20,
          title: '20%',
          radius: 12.w,
          titleStyle: AppTheme.lightTheme.textTheme.bodySmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
      PieChartSectionData(
          color: AppTheme.warningLight,
          value: 10,
          title: '10%',
          radius: 12.w,
          titleStyle: AppTheme.lightTheme.textTheme.bodySmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
    ];
  }

  List<FlSpot> _generateLineData() {
    return [
      const FlSpot(0, 2500000),
      const FlSpot(1, 2800000),
      const FlSpot(2, 2200000),
      const FlSpot(3, 3100000),
      const FlSpot(4, 2900000),
      const FlSpot(5, 3300000),
    ];
  }
}
