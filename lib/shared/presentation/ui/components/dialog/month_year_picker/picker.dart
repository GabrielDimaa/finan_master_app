import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ################################## CLASSES ##################################
class MonthPicker extends StatefulWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const MonthPicker({
    required this.firstDate,
    required this.lastDate,
    required this.initialDate,
    required this.selectedDate,
    required this.onMonthSelected,
    required this.onPageChanged,
    this.selectableMonthYearPredicate,
    super.key,
  });

  // ---------------------------------- FIELDS ---------------------------------
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onMonthSelected;
  final ValueChanged<DateTime> onPageChanged;
  final SelectableMonthYearPredicate? selectableMonthYearPredicate;

  // --------------------------------- METHODS ---------------------------------
  @override
  State<MonthPicker> createState() => MonthPickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime>('firstDate', firstDate))
      ..add(DiagnosticsProperty<DateTime>('lastDate', lastDate))
      ..add(DiagnosticsProperty<DateTime>('initialDate', initialDate))
      ..add(DiagnosticsProperty<DateTime>('selectedDate', selectedDate))
      ..add(
        ObjectFlagProperty<ValueChanged<DateTime>>.has(
          'onMonthSelected',
          onMonthSelected,
        ),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<DateTime>>.has(
          'onPageChanged',
          onPageChanged,
        ),
      )
      ..add(
        ObjectFlagProperty<SelectableMonthYearPredicate?>.has(
          'selectableMonthYearPredicate',
          selectableMonthYearPredicate,
        ),
      );
  }
}

class MonthPickerState extends State<MonthPicker> {
  // ---------------------------------- FIELDS ---------------------------------
  late final PageController _pageController;
  var _currentPage = 0;

  // -------------------------------- PROPERTIES -------------------------------
  bool get canGoDown => _currentPage > 0;

  bool get canGoUp => _currentPage < (_pageCount - 1);

  int get _pageCount => widget.lastDate.year - widget.firstDate.year + 1;

  // --------------------------------- METHODS ---------------------------------
  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialDate.year - widget.firstDate.year;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      physics: const AlwaysScrollableScrollPhysics(),
      onPageChanged: _onPageChanged,
      itemCount: _pageCount,
      itemBuilder: _buildItem,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('canGoDown', canGoDown))
      ..add(DiagnosticsProperty<bool>('canGoUp', canGoUp));
  }

  void goToYear({required int year}) {
    _currentPage = year - widget.firstDate.year;
    _pageController.jumpToPage(_currentPage);
  }

  Future<void> goDown() {
    _currentPage = _pageController.page!.toInt() - 1;
    return _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> goUp() {
    _currentPage = _pageController.page!.toInt() + 1;
    return _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildItem(final BuildContext context, final int page) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      children: [
        for (var i = 0; i < 12; i++)
          _MonthButton(
            page: page,
            index: i,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            selectedDate: widget.selectedDate,
            onMonthSelected: widget.onMonthSelected,
            selectableMonthYearPredicate: widget.selectableMonthYearPredicate,
          ),
      ],
    );
  }

  void _onPageChanged(final int page) {
    _currentPage = page;
    var newDate = DateTime(
      widget.firstDate.year + page,
      widget.selectedDate.month,
    );
    while (newDate.isAfter(widget.lastDate)) {
      newDate = newDate.subtract(const Duration(days: 1));
    }
    widget.onPageChanged(newDate);
  }
}

class YearPicker extends StatefulWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const YearPicker({
    required this.firstDate,
    required this.lastDate,
    required this.initialDate,
    required this.selectedDate,
    required this.onYearSelected,
    required this.onPageChanged,
    this.selectableMonthYearPredicate,
    super.key,
  });

  // ---------------------------------- FIELDS ---------------------------------
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onYearSelected;
  final ValueChanged<DateTime> onPageChanged;
  final SelectableMonthYearPredicate? selectableMonthYearPredicate;

  // --------------------------------- METHODS ---------------------------------
  @override
  State<YearPicker> createState() => YearPickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime>('firstDate', firstDate))
      ..add(DiagnosticsProperty<DateTime>('lastDate', lastDate))
      ..add(DiagnosticsProperty<DateTime>('initialDate', initialDate))
      ..add(DiagnosticsProperty<DateTime>('selectedDate', selectedDate))
      ..add(
        ObjectFlagProperty<ValueChanged<DateTime>>.has(
          'onYearSelected',
          onYearSelected,
        ),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<DateTime>>.has(
          'onPageChanged',
          onPageChanged,
        ),
      )
      ..add(
        ObjectFlagProperty<SelectableMonthYearPredicate?>.has(
          'selectableMonthYearPredicate',
          selectableMonthYearPredicate,
        ),
      );
  }
}

class YearPickerState extends State<YearPicker> {
  // ---------------------------------- FIELDS ---------------------------------
  late final PageController _pageController;
  var _currentPage = 0;

  // -------------------------------- PROPERTIES -------------------------------
  bool get canGoDown => _currentPage > 0;

  bool get canGoUp => _currentPage < (_pageCount - 1);

  int get _pageCount =>
      ((widget.lastDate.year - widget.firstDate.year + 1) / 12).ceil();

  // --------------------------------- METHODS ---------------------------------
  @override
  void initState() {
    super.initState();
    _currentPage =
        ((widget.initialDate.year - widget.firstDate.year) / 12).floor();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      onPageChanged: _onPageChanged,
      itemCount: _pageCount,
      itemBuilder: _buildItem,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('canGoDown', canGoDown))
      ..add(DiagnosticsProperty<bool>('canGoUp', canGoUp));
  }

  Future<void> goDown() {
    _currentPage = _pageController.page!.toInt() - 1;
    return _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> goUp() {
    _currentPage = _pageController.page!.toInt() + 1;
    return _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildItem(final BuildContext context, final int page) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      children: [
        for (var i = 0; i < 12; i++)
          _YearButton(
            page: page,
            index: i,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            selectedDate: widget.selectedDate,
            onYearSelected: widget.onYearSelected,
            selectableMonthYearPredicate: widget.selectableMonthYearPredicate,
          ),
      ],
    );
  }

  void _onPageChanged(final int page) {
    _currentPage = page;
    widget.onPageChanged(DateTime(widget.firstDate.year + (page * 12)));
  }
}

class _MonthButton extends StatelessWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const _MonthButton({
    required this.page,
    required this.index,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onMonthSelected,
    this.selectableMonthYearPredicate,
  });

  // ---------------------------------- FIELDS ---------------------------------
  final int page;
  final int index;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onMonthSelected;
  final SelectableMonthYearPredicate? selectableMonthYearPredicate;

  // --------------------------------- METHODS ---------------------------------
  @override
  Widget build(BuildContext context) {
    final year = firstDate.year + page;
    final date = DateTime(year, index + 1);
    final locale = Localizations.localeOf(context).toString();

    final isEnabled = selectableMonthYearPredicate == null
        ? firstDate.compareTo(date) <= 0 && lastDate.compareTo(date) >= 0
        : selectableMonthYearPredicate!(date);
    final isSelected =
        date.month == selectedDate.month && date.year == selectedDate.year;

    final now = DateTime.now();
    final isThisMonth = date.month == now.month && date.year == now.year;

    return _Button(
      label: DateFormat.MMM(locale).format(date),
      isEnabled: isEnabled,
      isHighlighted: isThisMonth,
      isSelected: isSelected,
      onPressed: () => onMonthSelected(DateTime(date.year, date.month)),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('page', page))
      ..add(IntProperty('index', index))
      ..add(DiagnosticsProperty<DateTime>('firstDate', firstDate))
      ..add(DiagnosticsProperty<DateTime>('lastDate', lastDate))
      ..add(DiagnosticsProperty<DateTime>('selectedDate', selectedDate))
      ..add(
        ObjectFlagProperty<ValueChanged<DateTime>>.has(
          'onMonthSelected',
          onMonthSelected,
        ),
      )
      ..add(
        ObjectFlagProperty<SelectableMonthYearPredicate?>.has(
          'selectableMonthYearPredicate',
          selectableMonthYearPredicate,
        ),
      );
  }
}

class _YearButton extends StatelessWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const _YearButton({
    required this.page,
    required this.index,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onYearSelected,
    this.selectableMonthYearPredicate,
  });

  // ---------------------------------- FIELDS ---------------------------------
  final int page;
  final int index;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onYearSelected;
  final SelectableMonthYearPredicate? selectableMonthYearPredicate;

  // --------------------------------- METHODS ---------------------------------
  @override
  Widget build(BuildContext context) {
    final year = firstDate.year + (page * 12) + index;
    final date = DateTime(year);
    final locale = Localizations.localeOf(context).toString();

    final isEnabled = selectableMonthYearPredicate == null
        ? year >= firstDate.year && year <= lastDate.year
        : selectableMonthYearPredicate!(date);
    final isSelected = year == selectedDate.year;

    final now = DateTime.now();
    final isThisYear = year == now.year;

    return _Button(
      label: DateFormat.y(locale).format(date),
      isEnabled: isEnabled,
      isHighlighted: isThisYear,
      isSelected: isSelected,
      onPressed: () => onYearSelected(DateTime(date.year)),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('page', page))
      ..add(IntProperty('index', index))
      ..add(DiagnosticsProperty<DateTime>('firstDate', firstDate))
      ..add(DiagnosticsProperty<DateTime>('lastDate', lastDate))
      ..add(DiagnosticsProperty<DateTime>('selectedDate', selectedDate))
      ..add(
        ObjectFlagProperty<ValueChanged<DateTime>>.has(
          'onYearSelected',
          onYearSelected,
        ),
      )
      ..add(
        ObjectFlagProperty<SelectableMonthYearPredicate?>.has(
          'selectableMonthYearPredicate',
          selectableMonthYearPredicate,
        ),
      );
  }
}

class _Button extends StatelessWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const _Button({
    required this.label,
    required this.isEnabled,
    required this.isHighlighted,
    required this.isSelected,
    required this.onPressed,
  });

  // ---------------------------------- FIELDS ---------------------------------
  final String label;
  final bool isEnabled;
  final bool isHighlighted;
  final bool isSelected;
  final VoidCallback onPressed;

  // --------------------------------- METHODS ---------------------------------
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonBackground = isSelected ? colorScheme.secondary : null;
    final buttonText = isSelected
        ? colorScheme.onSecondary
        : isHighlighted
        ? colorScheme.secondary
        : colorScheme.onSurface;

    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        backgroundColor: buttonBackground,
        foregroundColor: buttonText,
        disabledForegroundColor: buttonText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        textStyle: TextStyle(color: buttonText),
      ),
      child: Text(label),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled))
      ..add(DiagnosticsProperty<bool>('isHighlighted', isHighlighted))
      ..add(DiagnosticsProperty<bool>('isSelected', isSelected))
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}

// ################################## TYPEDEFS #################################
/// Signature for predicating dates for enabled month/year selections.
typedef SelectableMonthYearPredicate = bool Function(DateTime my);