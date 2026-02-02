import 'package:finan_master_app/l10n/generated/app_localizations.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/month_year_picker/picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide YearPicker;

// ################################# CONSTANTS #################################
const _portraitDialogSize = Size(320.0, 480.0);
const _landscapeDialogSize = Size(496.0, 344.0);
const _dialogSizeAnimationDuration = Duration(milliseconds: 200);
const _datePickerHeaderLandscapeWidth = 120.0;
const _datePickerHeaderPortraitHeight = 120.0;
const _headerPaddingLandscape = 16.0;

DateTime monthYearOnly(DateTime dateTime) =>
    DateTime(dateTime.year, dateTime.month);

// ################################# FUNCTIONS #################################
/// Displays month year picker dialog.
/// [initialDate] is the initially selected month.
/// [firstDate] is the lower bound for month selection.
/// [lastDate] is the upper bound for month selection.
Future<DateTime?> showMonthYearPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  SelectableMonthYearPredicate? selectableMonthYearPredicate,
  Locale? locale,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  MonthYearPickerMode initialMonthYearPickerMode = MonthYearPickerMode.month,
}) {
  initialDate = monthYearOnly(initialDate);
  firstDate = monthYearOnly(firstDate);
  lastDate = monthYearOnly(lastDate);

  assert(
  !lastDate.isBefore(firstDate),
  'lastDate $lastDate must be on or after firstDate $firstDate.',
  );
  assert(
  !initialDate.isBefore(firstDate),
  'initialDate $initialDate must be on or after firstDate $firstDate.',
  );
  assert(
  !initialDate.isAfter(lastDate),
  'initialDate $initialDate must be on or before lastDate $lastDate.',
  );

  Widget dialog = MonthYearPickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    initialMonthYearPickerMode: initialMonthYearPickerMode,
    selectableMonthYearPredicate: selectableMonthYearPredicate,
  );

  if (textDirection != null) {
    dialog = Directionality(
      textDirection: textDirection,
      child: dialog,
    );
  }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showDialog<DateTime>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (context) => builder == null ? dialog : builder(context, dialog),
  );
}

// ################################ ENUMERATIONS ###############################
enum MonthYearPickerMode {
  month,
  year,
}

// ################################## CLASSES ##################################
class MonthYearPickerDialog extends StatefulWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const MonthYearPickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.initialMonthYearPickerMode,
    this.selectableMonthYearPredicate,
  });

  // ---------------------------------- FIELDS ---------------------------------
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final MonthYearPickerMode initialMonthYearPickerMode;
  final SelectableMonthYearPredicate? selectableMonthYearPredicate;

  // --------------------------------- METHODS ---------------------------------
  @override
  State<MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime>('initialDate', initialDate))
      ..add(DiagnosticsProperty<DateTime>('firstDate', firstDate))
      ..add(DiagnosticsProperty<DateTime>('lastDate', lastDate))
      ..add(
        EnumProperty<MonthYearPickerMode>(
          'initialMonthYearPickerMode',
          initialMonthYearPickerMode,
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

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  // ---------------------------------- FIELDS ---------------------------------
  final _yearPickerState = GlobalKey<YearPickerState>();
  final _monthPickerState = GlobalKey<MonthPickerState>();
  var _isShowingYear = false;
  var _canGoPrevious = false;
  var _canGoNext = false;
  late DateTime _selectedDate = widget.initialDate;

  // -------------------------------- PROPERTIES -------------------------------
  Size get _dialogSize {
    final orientation = MediaQuery.of(context).orientation;
    final offset =
    Theme.of(context).materialTapTargetSize == MaterialTapTargetSize.padded
        ? const Offset(0.0, 24.0)
        : Offset.zero;
    switch (orientation) {
      case Orientation.portrait:
        return _portraitDialogSize + offset;
      case Orientation.landscape:
        return _landscapeDialogSize + offset;
    }
  }

  // --------------------------------- METHODS ---------------------------------
  @override
  void initState() {
    super.initState();
    _isShowingYear =
        widget.initialMonthYearPickerMode == MonthYearPickerMode.year;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(_updatePaginators);
    });
  }

  @override
  Widget build(BuildContext context) {
    final materialLocalizations = MaterialLocalizations.of(context);
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final orientation = media.orientation;
    final textTheme = theme.textTheme;
    // Constrain the textScaleFactor to the largest supported value to prevent
    // layout issues.
    final textScaler = media.textScaler;
    final direction = Directionality.of(context);

    final dateText = materialLocalizations.formatMonthYear(_selectedDate);
    final onPrimarySurface = colorScheme.brightness == Brightness.light
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final dateStyle = orientation == Orientation.landscape
        ? textTheme.headlineSmall?.copyWith(color: onPrimarySurface)
        : textTheme.headlineMedium?.copyWith(color: onPrimarySurface);

    final Widget actions = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: OverflowBar(
        spacing: 8.0,
        children: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(materialLocalizations.cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _selectedDate),
            child: Text(materialLocalizations.okButtonLabel),
          ),
        ],
      ),
    );

    final semanticText = materialLocalizations.formatMonthYear(_selectedDate);
    final header = _Header(
      helpText: AppLocalizations.of(context)!.selectMonthDate,
      titleText: dateText,
      titleSemanticsLabel: semanticText,
      titleStyle: dateStyle,
      orientation: orientation,
    );

    final switcher = Stack(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            foregroundColor: Theme.of(context).textTheme.bodySmall?.color,
          ),
          child: Row(
            children: [
              Text(materialLocalizations.formatYear(_selectedDate)),
              AnimatedRotation(
                duration: _dialogSizeAnimationDuration,
                turns: _isShowingYear ? 0.5 : 0.0,
                child: const Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
          onPressed: () {
            setState(() {
              _isShowingYear = !_isShowingYear;
              _updatePaginators();
            });
          },
        ),
        PositionedDirectional(
          end: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  direction == TextDirection.rtl
                      ? Icons.keyboard_arrow_right
                      : Icons.keyboard_arrow_left,
                ),
                onPressed: _canGoPrevious ? _goToPreviousPage : null,
              ),
              IconButton(
                icon: Icon(
                  direction == TextDirection.rtl
                      ? Icons.keyboard_arrow_left
                      : Icons.keyboard_arrow_right,
                ),
                onPressed: _canGoNext ? _goToNextPage : null,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12.0),
      ],
    );

    final picker = LayoutBuilder(
      builder: (context, constraints) {
        final pickerMaxWidth =
            _landscapeDialogSize.width - _datePickerHeaderLandscapeWidth;
        final width = constraints.maxHeight < pickerMaxWidth
            ? constraints.maxHeight / 3.0 * 4.0
            : null;

        return Stack(
          children: [
            AnimatedPositioned(
              duration: _dialogSizeAnimationDuration,
              curve: Curves.easeOut,
              left: 0.0,
              right: pickerMaxWidth - (width ?? pickerMaxWidth),
              top: _isShowingYear ? 0.0 : -constraints.maxHeight,
              bottom: _isShowingYear ? 0.0 : constraints.maxHeight,
              child: SizedBox(
                height: constraints.maxHeight,
                child: YearPicker(
                  key: _yearPickerState,
                  initialDate: _selectedDate,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  onPageChanged: _updateSelectedDate,
                  onYearSelected: _updateYear,
                  selectedDate: _selectedDate,
                  selectableMonthYearPredicate:
                  widget.selectableMonthYearPredicate,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: _dialogSizeAnimationDuration,
              curve: Curves.easeOut,
              left: 0.0,
              right: pickerMaxWidth - (width ?? pickerMaxWidth),
              top: _isShowingYear ? constraints.maxHeight : 0.0,
              bottom: _isShowingYear ? -constraints.maxHeight : 0.0,
              child: SizedBox(
                height: constraints.maxHeight,
                child: MonthPicker(
                  key: _monthPickerState,
                  initialDate: _selectedDate,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  onPageChanged: _updateSelectedDate,
                  onMonthSelected: _updateMonth,
                  selectedDate: _selectedDate,
                  selectableMonthYearPredicate:
                  widget.selectableMonthYearPredicate,
                ),
              ),
            ),
          ],
        );
      },
    );

    return Directionality(
      textDirection: direction,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        clipBehavior: Clip.antiAlias,
        child: AnimatedContainer(
          width: textScaler.scale(_dialogSize.width),
          height: textScaler.scale(_dialogSize.height),
          duration: _dialogSizeAnimationDuration,
          curve: Curves.easeIn,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: Builder(
              builder: (context) {
                switch (orientation) {
                  case Orientation.portrait:
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        header,
                        switcher,
                        Expanded(child: picker),
                        actions,
                      ],
                    );
                  case Orientation.landscape:
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        header,
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              switcher,
                              Expanded(child: picker),
                              actions,
                            ],
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _updateYear(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, _selectedDate.month);
      _isShowingYear = false;
      _monthPickerState.currentState!.goToYear(year: _selectedDate.year);
    });
  }

  void _updateMonth(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month);
    });
  }

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month);
      _updatePaginators();
    });
  }

  void _updatePaginators() {
    if (_isShowingYear) {
      _canGoNext = _yearPickerState.currentState!.canGoUp;
      _canGoPrevious = _yearPickerState.currentState!.canGoDown;
    } else {
      _canGoNext = _monthPickerState.currentState!.canGoUp;
      _canGoPrevious = _monthPickerState.currentState!.canGoDown;
    }
  }

  Future<void> _goToPreviousPage() => _isShowingYear
      ? _yearPickerState.currentState!.goDown()
      : _monthPickerState.currentState!.goDown();

  Future<void> _goToNextPage() => _isShowingYear
      ? _yearPickerState.currentState!.goUp()
      : _monthPickerState.currentState!.goUp();
}

class _Header extends StatelessWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const _Header({
    required this.helpText,
    required this.titleText,
    this.titleSemanticsLabel,
    required this.titleStyle,
    required this.orientation,
  });

  // ---------------------------------- FIELDS ---------------------------------
  final String helpText;
  final String titleText;
  final String? titleSemanticsLabel;
  final TextStyle? titleStyle;
  final Orientation orientation;

  // --------------------------------- METHODS ---------------------------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // The header should use the primary color in light themes and surface color
    // in dark.
    final isDark = colorScheme.brightness == Brightness.dark;
    final primarySurfaceColor =
    isDark ? colorScheme.surface : colorScheme.primary;
    final onPrimarySurfaceColor =
    isDark ? colorScheme.onSurface : colorScheme.onPrimary;

    final helpStyle = textTheme.labelSmall?.copyWith(
      color: onPrimarySurfaceColor,
    );

    final help = Text(
      helpText,
      style: helpStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final title = Text(
      titleText,
      semanticsLabel: titleSemanticsLabel ?? titleText,
      style: titleStyle,
      maxLines: orientation == Orientation.portrait ? 1 : 2,
      overflow: TextOverflow.ellipsis,
    );

    switch (orientation) {
      case Orientation.portrait:
        return SizedBox(
          height: _datePickerHeaderPortraitHeight,
          child: Material(
            color: primarySurfaceColor,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 24.0,
                end: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  help,
                  const Flexible(child: SizedBox(height: 38.0)),
                  title,
                ],
              ),
            ),
          ),
        );
      case Orientation.landscape:
        return SizedBox(
          width: _datePickerHeaderLandscapeWidth,
          child: Material(
            color: primarySurfaceColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _headerPaddingLandscape,
                  ),
                  child: help,
                ),
                const SizedBox(height: 56.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _headerPaddingLandscape,
                    ),
                    child: title,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('helpText', helpText))
      ..add(StringProperty('titleText', titleText))
      ..add(StringProperty('titleSemanticsLabel', titleSemanticsLabel))
      ..add(DiagnosticsProperty<TextStyle?>('titleStyle', titleStyle))
      ..add(EnumProperty<Orientation>('orientation', orientation));
  }
}