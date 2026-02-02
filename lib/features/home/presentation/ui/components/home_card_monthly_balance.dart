import 'dart:math';

import 'package:collection/collection.dart';
import 'package:finan_master_app/features/home/domain/entities/home_monthly_balance_entity.dart';
import 'package:finan_master_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeCardMonthlyBalance extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeCardMonthlyBalance({super.key, required this.viewModel});

  @override
  State<HomeCardMonthlyBalance> createState() => _HomeCardMonthlyBalanceState();
}

class _HomeCardMonthlyBalanceState extends State<HomeCardMonthlyBalance> with ThemeContext {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: Text(strings.monthlyBalance, style: textTheme.bodyLarge)),
                Text(strings.lastSixMonths, style: textTheme.bodySmall),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 12 / 7,
            child: ListenableBuilder(
              listenable: widget.viewModel.loadMonthlyBalance,
              builder: (_, __) {
                final prev = widget.viewModel.loadMonthlyBalance.previous;

                if (widget.viewModel.loadMonthlyBalance.hasError) {
                  return Center(
                    child: Text(
                      widget.viewModel.loadMonthlyBalance.error.toString().replaceAll('Exception: ', ''),
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  );
                }

                if (widget.viewModel.loadMonthlyBalance.running && prev?.completed != true) {
                  return const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()));
                }

                final List<HomeMonthlyBalanceEntity> monthlyBalances = widget.viewModel.loadMonthlyBalance.result ?? widget.viewModel.loadMonthlyBalance.previous?.result ?? [];

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: BarChart(
                    swapAnimationDuration: const Duration(milliseconds: 250),
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 80,
                            getTitlesWidget: (double value, TitleMeta meta) => SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: ListenableBuilder(
                                  listenable: widget.viewModel,
                                  builder: (_, __) {
                                    return Text(
                                      widget.viewModel.hideAmounts ? '●●●●' : value.money,
                                      style: textTheme.bodySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w300),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 38,
                            getTitlesWidget: (double value, TitleMeta meta) => SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 8,
                              child: Text(monthlyBalances[value.toInt()].date.formatMMM(), style: textTheme.bodySmall),
                            ),
                          ),
                        ),
                      ),
                      barGroups: barGroups(monthlyBalances),
                      barTouchData: BarTouchData(
                        touchCallback: touchCallback,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => colorScheme.outlineVariant,
                          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                          getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int? rodIndex) {
                            final HomeMonthlyBalanceEntity monthlyBalance = monthlyBalances[group.x];
                            return BarTooltipItem(
                              '${monthlyBalance.date.formatMMMM().capitalizeFirstLetter()}\n',
                              textTheme.labelMedium!,
                              children: [
                                TextSpan(
                                  text: rod.toY.money,
                                  style: textTheme.labelLarge,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void touchCallback(FlTouchEvent event, barTouchResponse) {
    setState(() {
      if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
        touchedIndex = -1;
        return;
      }

      touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
    });
  }

  List<BarChartGroupData> barGroups(List<HomeMonthlyBalanceEntity> monthlyBalances) {
    return monthlyBalances.map((e) {
          final int index = monthlyBalances.indexOf(e);

          final Color color = e.balance < 0 ? const Color(0xFFFF5454) : const Color(0xFF3CDE87);

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: e.balance,
                color: index == touchedIndex ? color : color.withAlpha(100),
                width: 18,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: max(monthlyBalances.map((e) => e.balance).max, 100),
                  color: colorScheme.outlineVariant.withAlpha(80),
                ),
              ),
            ],
          );
        }).toList();
  }
}
