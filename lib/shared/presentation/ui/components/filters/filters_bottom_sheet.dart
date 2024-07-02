import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/draggable_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FiltersBottomSheet extends StatefulWidget {
  final VoidCallback filter;
  final List<Widget> children;

  const FiltersBottomSheet._({required this.filter, required this.children});

  static Future<void> show({required BuildContext context, required VoidCallback filter, required List<Widget> children}) async {
    return await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => FiltersBottomSheet._(filter: filter, children: children),
    );
  }

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheet(
      builder: (ScrollController scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(strings.filters, style: textTheme.titleMedium),
                    const Spacing.y(),
                    ...widget.children,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                icon: const Icon(Icons.filter_alt_outlined),
                label: Text(strings.filter),
                onPressed: filter,
              ),
            ),
          ],
        );
      },
    );
  }

  void filter() {
    widget.filter();
    context.pop();
  }
}
