import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/reports/presentation/enums/date_period_enum.dart';
import 'package:finan_master_app/features/reports/presentation/notifiers/report_categories_notifier.dart';
import 'package:finan_master_app/features/reports/presentation/states/report_categories_state.dart';
import 'package:finan_master_app/features/reports/presentation/ui/components/report_categories_chart.dart';
import 'package:finan_master_app/features/reports/presentation/ui/components/report_filters_bottom_sheet.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/filters/date_period_filter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:flutter/material.dart';

class ReportCategoriesPage extends StatefulWidget {
  static const String route = 'report-categories';

  const ReportCategoriesPage({Key? key}) : super(key: key);

  @override
  State<ReportCategoriesPage> createState() => _ReportCategoriesPageState();
}

class _ReportCategoriesPageState extends State<ReportCategoriesPage> with ThemeContext {
  final ReportCategoriesNotifier notifier = DI.get<ReportCategoriesNotifier>();

  List<Tab> get tabs => [Tab(text: strings.expenses), Tab(text: strings.incomes)];

  @override
  void initState() {
    super.initState();
    notifier.findByPeriod(DateTime.now().getInitialMonth(), DateTime.now().getFinalMonth());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.categories),
          actions: [
            IconButton(
              tooltip: strings.filters,
              onPressed: filters,
              icon: const Icon(Icons.filter_list_outlined),
            ),
          ],
          bottom: TabBar(tabs: tabs),
        ),
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: notifier,
            builder: (_, ReportCategoriesState state, __) {
              return switch (state) {
                LoadingReportCategoriesState _ => const Center(child: CircularProgressIndicator()),
                ErrorReportCategoriesState state => MessageErrorWidget(state.message),
                StartReportCategoriesState _ => const SizedBox.shrink(),
                LoadedReportCategoriesState _ => TabBarView(
                    children: [
                      Visibility(
                        visible: notifier.reportCategoriesExpenses.isNotEmpty,
                        replacement: NoContentWidget(child: Text(strings.noRecordsFound)),
                        child: ReportCategoriesChart(entities: notifier.reportCategoriesExpenses, total: notifier.totalExpenses),
                      ),
                      Visibility(
                        visible: notifier.reportCategoriesIncomes.isNotEmpty,
                        replacement: NoContentWidget(child: Text(strings.noRecordsFound)),
                        child: ReportCategoriesChart(entities: notifier.reportCategoriesIncomes, total: notifier.totalIncomes),
                      ),
                    ],
                  ),
              };
            },
          ),
        ),
      ),
    );
  }

  Future<void> filters() async {
    await ReportFiltersBottomSheet.show(
      context: context,
      filter: () => notifier.findByPeriod(notifier.dateInitialFilter, notifier.dateFinalFilter),
      children: [
        DatePeriodFilter(
          periods: DatePeriodEnum.values,
          onSelected: (DateTime? dateTimeInitial, DateTime? dateTimeFinal) {
            notifier.dateInitialFilter = dateTimeInitial;
            notifier.dateFinalFilter = dateTimeFinal;
          },
          dateRange: DateTimeRange(start: notifier.dateInitialFilter ?? DatePeriodEnum.oneMonth.getDateTime().start, end: notifier.dateFinalFilter ?? DatePeriodEnum.oneMonth.getDateTime().end),
        ),
      ],
    );
  }
}
