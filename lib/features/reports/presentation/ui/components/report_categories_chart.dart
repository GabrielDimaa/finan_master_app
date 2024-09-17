import 'package:finan_master_app/features/reports/domain/entities/report_category_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportCategoriesChart extends StatefulWidget {
  final List<ReportCategoryEntity> entities;
  final double total;

  const ReportCategoriesChart({Key? key, required this.entities, required this.total}) : super(key: key);

  @override
  State<ReportCategoriesChart> createState() => _ReportCategoriesChartState();
}

class _ReportCategoriesChartState extends State<ReportCategoriesChart> with ThemeContext {
  List<GlobalObjectKey> globalKeys = [];
  List<ExpansionTileController> expansionTileControllers = [];

  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();

    for (final entity in widget.entities) {
      globalKeys.add(GlobalObjectKey(entity));
      expansionTileControllers.add(ExpansionTileController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacing.y(2),
          SizedBox(
            width: 200,
            height: 200,
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                centerSpaceRadius: 40,
                sections: sections(),
                pieTouchData: PieTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) async {
                    setState(() {
                      if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;

                      if ((event is FlTapUpEvent || event is FlTapDownEvent)  && touchedIndex >= 0) {
                        expansionTileControllers[touchedIndex].expand();
                        Scrollable.ensureVisible(
                          globalKeys[touchedIndex].currentContext!,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          const Spacing.y(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(strings.total),
                Text(widget.total.money, style: textTheme.titleSmall),
              ],
            ),
          ),
          const Spacing.y(),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.entities.length,
            itemBuilder: (_, index) {
              final ReportCategoryEntity entity = widget.entities[index];
              return ExpansionTile(
                key: globalKeys[index],
                controller: expansionTileControllers[index],
                leading: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Color(entity.category.color.toColor() ?? 0),
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text('${entity.category.description} - ${((entity.amount / widget.total) * 100).toRound(2).formatted}%'),
                subtitle: Text(entity.amount.money, style: Theme.of(context).textTheme.titleSmall),
                children: entity.transactions.map((ITransactionEntity transaction) {
                  return switch (transaction) {
                    ExpenseEntity expense => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(expense.description),
                        subtitle: Text(expense.date.format()),
                        trailing: Text(expense.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0XFFFF5454))),
                      ),
                    IncomeEntity income => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(income.description),
                        subtitle: Text(income.date.format()),
                        trailing: Text(income.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0XFF3CDE87))),
                      ),
                    _ => const SizedBox.shrink(),
                  };
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> sections() {
    final List<PieChartSectionData> data = [];

    for (int i = 0; i < widget.entities.length; i++) {
      final ReportCategoryEntity entity = widget.entities[i];
      final double value = ((entity.amount / widget.total) * 100).toRound(2);

      data.add(
        PieChartSectionData(
          color: Color(entity.category.color.toColor() ?? 0),
          value: value,
          radius: i == touchedIndex ? 60 : 50,
          showTitle: false,
        ),
      );
    }

    return data;
  }
}
